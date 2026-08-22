//! The five hand-written manifests in `example-manifests/` are the fixtures. They are read from
//! where they live rather than copied in, so a fixture and its copy can never drift apart.

use std::path::{Path, PathBuf};

use herdr_dev::manifest::Project;

const DIR: &str = concat!(
    env!("CARGO_MANIFEST_DIR"),
    "/tests/fixtures/manifests"
);

fn load(project: &str) -> Project {
    let path = PathBuf::from(DIR).join(format!("{project}.herdr-dev.toml"));
    Project::load(&path).unwrap_or_else(|error| panic!("{error}"))
}

fn service_names(project: &Project) -> Vec<&str> {
    project.docker.iter().map(|s| s.name.as_str()).collect()
}

fn unit_names(project: &Project) -> Vec<&str> {
    project.local.iter().map(|u| u.name.as_str()).collect()
}

#[test]
fn every_example_manifest_parses_without_a_single_problem() {
    let mut found = Vec::new();
    for entry in std::fs::read_dir(DIR).expect("example-manifests directory") {
        let path = entry.unwrap().path();
        if path.extension() != Some(std::ffi::OsStr::new("toml")) {
            continue;
        }
        let project = Project::load(&path).unwrap_or_else(|error| panic!("{error}"));
        assert_eq!(project.problems, Vec::<String>::new(), "{}", path.display());
        assert!(!project.is_empty(), "{}", path.display());
        assert!(
            project.local.iter().all(|unit| !unit.is_broken()),
            "{}",
            path.display()
        );
        found.push(path.file_name().unwrap().to_string_lossy().into_owned());
    }
    found.sort();
    assert_eq!(
        found,
        [
            "game_server.herdr-dev.toml",
            "harmony.herdr-dev.toml",
            "liveops_server.herdr-dev.toml",
            "photos.herdr-dev.toml",
            "player_server.herdr-dev.toml",
        ]
    );
}

#[test]
fn photos_is_one_local_unit_and_no_rendered_service() {
    let photos = load("photos");
    assert_eq!(unit_names(&photos), ["phoenix"]);
    assert_eq!(photos.local[0].cmd, ["mix", "phx.server"]);
    assert_eq!(service_names(&photos), Vec::<&str>::new());
    assert!(photos.env.is_empty());
    assert!(photos.includes.is_empty());
}

#[test]
fn harmony_renders_one_service_and_three_included_repos() {
    let harmony = load("harmony");
    assert_eq!(unit_names(&harmony), ["rails", "vite"]);
    assert_eq!(service_names(&harmony), ["db"]);
    assert_eq!(
        harmony
            .includes
            .iter()
            .map(|include| include.name.as_str())
            .collect::<Vec<_>>(),
        ["player_server", "game_server", "liveops_server"]
    );
    let home = std::env::var("HOME").unwrap();
    assert_eq!(
        harmony.includes[0].path,
        Path::new(&home).join("projects/tds/player_server")
    );
}

#[test]
fn harmony_marks_a_hidden_service_one_shot_without_rendering_it() {
    let harmony = load("harmony");
    assert!(!harmony.docker.iter().any(|s| s.name == "minio_init"));
    assert!(harmony.problems.is_empty());
}

#[test]
fn game_server_keeps_names_order_and_carries_one_shot_and_notes() {
    let game_server = load("game_server");
    assert_eq!(unit_names(&game_server), ["rails", "sidekiq", "vite"]);
    assert_eq!(
        service_names(&game_server),
        [
            "db",
            "redis",
            "memcached",
            "mongo",
            "dragonfly",
            "redis-sentinel-1",
            "redis-sentinel-2",
            "harmony",
            "migrate",
        ]
    );
    let migrate = game_server.docker.last().unwrap();
    assert!(migrate.one_shot);
    assert_eq!(
        migrate.note.as_deref(),
        Some("declares no restart: key, so only a human can mark it one-shot")
    );
    assert!(game_server.docker[..8].iter().all(|s| !s.one_shot));
    assert!(game_server.docker[..8].iter().all(|s| s.note.is_none()));
}

#[test]
fn player_server_notes_a_rendered_service() {
    let player_server = load("player_server");
    assert_eq!(
        service_names(&player_server),
        ["db", "redis", "memcached", "mongo", "harmony"]
    );
    let harmony = player_server.docker.last().unwrap();
    assert_eq!(harmony.name, "harmony");
    assert_eq!(
        harmony.note.as_deref(),
        Some("run `docker compose run --rm harmony rails db:create db:migrate` once, by hand")
    );
}

#[test]
fn liveops_server_declares_no_one_shot() {
    let liveops = load("liveops_server");
    assert_eq!(unit_names(&liveops), ["rails", "sidekiq", "vite"]);
    assert_eq!(
        service_names(&liveops),
        ["db", "redis", "memcached", "harmony"]
    );
    assert!(liveops.docker.iter().all(|service| !service.one_shot));
}

#[test]
fn a_local_unit_defaults_to_the_manifests_directory() {
    let photos = load("photos");
    assert_eq!(photos.local[0].cwd, photos.root);
    assert_eq!(photos.manifest.parent().unwrap(), photos.root);
}
