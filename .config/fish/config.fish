# load config files
set -l custom_config_files ~/.config/fish/config/aliases.fish

for file in $custom_config_files; . $file; end

set -e custom_config_files

