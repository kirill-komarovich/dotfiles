set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
fish_add_path -gP "$HOME/.local/bin" "$HOME/.cargo/bin"
