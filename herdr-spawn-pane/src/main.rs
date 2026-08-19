//! Spawn a pane along a full edge of the focused herdr tab.
//!
//! Nothing in herdr hangs a pane off the tab root: `pane.split` always
//! subdivides a single pane, `pane.move` refuses same-tab moves (it answers
//! `reason: "same_tab"` and changes nothing), and `layout.apply` rebuilds the
//! tab by respawning every terminal in it. Cross-tab moves are the one
//! primitive that keeps pane ids and live terminals, so the tab is replayed
//! top-down into a fresh tab with the new pane hung off the new root.
//!
//! Speaks the socket protocol instead of shelling out to `herdr`, which
//! exposes neither `layout.export` nor focus-by-id.

use serde_json::{Value, json};
use std::io::{BufRead, BufReader, Write};
use std::os::unix::net::UnixStream;

fn fail(message: &str) -> ! {
    eprintln!("herdr-spawn-pane: {message}");
    std::process::exit(1)
}

fn socket_path() -> String {
    std::env::var("HERDR_SOCKET_PATH").unwrap_or_else(|_| {
        let home = std::env::var("HOME").unwrap_or_default();
        format!("{home}/.config/herdr/herdr.sock")
    })
}

fn call(method: &str, params: Value) -> Value {
    // The server closes the connection after answering, so there is nothing to reuse.
    let stream = UnixStream::connect(socket_path())
        .unwrap_or_else(|error| fail(&format!("cannot reach herdr: {error}")));
    let request = json!({"id": "herdr-spawn-pane", "method": method, "params": params});
    (&stream)
        .write_all(format!("{request}\n").as_bytes())
        .unwrap_or_else(|error| fail(&format!("{method}: {error}")));

    let mut line = String::new();
    BufReader::new(&stream)
        .read_line(&mut line)
        .unwrap_or_else(|error| fail(&format!("{method}: {error}")));
    let reply: Value = serde_json::from_str(&line)
        .unwrap_or_else(|error| fail(&format!("{method}: malformed reply: {error}")));
    if let Some(error) = reply.get("error") {
        fail(&format!("{method} failed: {error}"));
    }
    reply["result"].clone()
}

fn pane_id(node: &Value) -> String {
    node["pane_id"]
        .as_str()
        .unwrap_or_else(|| fail("layout leaf without a pane id"))
        .to_string()
}

fn leftmost(node: &Value) -> String {
    let mut node = node;
    while node["type"] != "pane" {
        node = &node["first"];
    }
    pane_id(node)
}

fn find_cwd(node: &Value, target: &str) -> Option<String> {
    if node["type"] == "pane" {
        return match node["pane_id"].as_str() {
            Some(id) if id == target => node["cwd"].as_str().map(str::to_string),
            _ => None,
        };
    }
    find_cwd(&node["first"], target).or_else(|| find_cwd(&node["second"], target))
}

/// Recreate `node`'s subtree in `tab`, with `anchor` already sitting in its slot.
fn rebuild(node: &Value, anchor: &str, tab: &str) {
    if node["type"] == "pane" {
        return;
    }
    let incoming = leftmost(&node["second"]);
    call(
        "pane.move",
        json!({
            "pane_id": incoming,
            "destination": {
                "type": "tab",
                "tab_id": tab,
                "split": node["direction"],
                "target_pane_id": anchor,
                "ratio": node["ratio"],
            },
            "focus": false,
        }),
    );
    rebuild(&node["first"], anchor, tab);
    rebuild(&node["second"], &incoming, tab);
}

fn main() {
    let side = std::env::args().nth(1).unwrap_or_else(|| "bottom".to_string());
    let direction = match side.as_str() {
        "top" | "bottom" => "down",
        "left" | "right" => "right",
        _ => fail("usage: herdr-spawn-pane [top|bottom|left|right]"),
    };

    let layout = call("layout.export", json!({}))["layout"].clone();
    let root = layout["root"].clone();
    let anchor = leftmost(&root);
    let nested = root["type"] != "pane";

    let mut index = 0;
    let tab = if nested {
        let tabs = call("tab.list", json!({}))["tabs"].clone();
        let siblings: Vec<&Value> = tabs
            .as_array()
            .unwrap_or_else(|| fail("tab.list returned no tabs"))
            .iter()
            .filter(|tab| tab["workspace_id"] == layout["workspace_id"])
            .collect();
        index = siblings
            .iter()
            .position(|tab| tab["tab_id"] == layout["tab_id"])
            .unwrap_or(0);
        let label = siblings[index]["label"].clone();

        // Seeding the fresh tab by moving a pane into it, rather than creating
        // the tab, costs no throwaway shell: `tab.create` always spawns one.
        call(
            "pane.move",
            json!({
                "pane_id": anchor,
                "destination": {
                    "type": "new_tab",
                    "workspace_id": layout["workspace_id"],
                    "label": label,
                },
                "focus": false,
            }),
        )["move_result"]["pane"]["tab_id"]
            .as_str()
            .unwrap_or_else(|| fail("move to a new tab reported no tab"))
            .to_string()
    } else {
        layout["tab_id"]
            .as_str()
            .unwrap_or_else(|| fail("layout without a tab id"))
            .to_string()
    };

    let split = call(
        "pane.split",
        json!({
            "target_pane_id": anchor,
            "direction": direction,
            "cwd": find_cwd(&root, layout["focused_pane_id"].as_str().unwrap_or_default()),
            "focus": false,
        }),
    );
    let new_pane = pane_id(&split["pane"]);

    // A split can only append, so the leading edges land by swapping the pair back.
    if side == "top" || side == "left" {
        call(
            "pane.swap",
            json!({"source_pane_id": new_pane, "target_pane_id": anchor}),
        );
    }

    if nested {
        rebuild(&root, &anchor, &tab);
        call("tab.move", json!({"tab_id": tab, "insert_index": index}));
        call("tab.focus", json!({"tab_id": tab}));
    }
    call("pane.focus", json!({"pane_id": new_pane}));
}
