# load config files
set -l custom_config_files ~/.config/fish/config/aliases.fish

for file in $custom_config_files; . $file; end

set -e custom_config_files

if test $HOME/.asdf/asdf.fish
    source $HOME/.asdf/asdf.fish

    if not test -d ~/.config/fish/completions
        mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
end
