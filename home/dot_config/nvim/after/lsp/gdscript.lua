-- The server lives inside the running Godot editor, so upstream's `cmd` is a
-- TCP connect. With no editor open that warns on every .gd buffer, so probe
-- the port first and simply never resolve a root when nothing is listening.
local port = tonumber(os.getenv("GDScript_Port") or "6005")

return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "project.godot", ".git" })
    if not root then
      return
    end

    local probe = vim.uv.new_tcp()
    if not probe then
      return
    end

    probe:connect("127.0.0.1", port, function(err)
      probe:close()
      if not err then
        vim.schedule(function()
          on_dir(root)
        end)
      end
    end)
  end,
}
