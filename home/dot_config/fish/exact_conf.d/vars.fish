set -gx SHELL (status fish-path)
set -gx EDITOR nvim-open
set -gx VISUAL nvim-open
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
fish_add_path -gPm "$HOME/.local/bin" "$HOME/.cargo/bin"
set -g fish_greeting

# A bare fish_add_path writes a universal fish_user_paths into fish_variables unless one is already defined.
set -g fish_user_paths
