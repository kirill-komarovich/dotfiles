# ANSI slots only, so the terminal's palette drives fish.
# Globals, not universals: they shadow whatever fish_variables holds.
set -g fish_color_normal normal
set -g fish_color_command blue
set -g fish_color_keyword magenta
set -g fish_color_quote green
set -g fish_color_redirection cyan
set -g fish_color_end magenta
set -g fish_color_error red
set -g fish_color_param normal
set -g fish_color_option yellow
set -g fish_color_comment brblack
set -g fish_color_selection --background=brblack
set -g fish_color_operator cyan
set -g fish_color_escape yellow
set -g fish_color_autosuggestion brblack
set -g fish_color_cancel --reverse
set -g fish_color_search_match --background=brblack
set -g fish_color_valid_path --underline
set -g fish_color_match cyan
set -g fish_color_history_current --bold

set -g fish_color_cwd blue
set -g fish_color_cwd_root red
set -g fish_color_user green
set -g fish_color_host blue
set -g fish_color_host_remote yellow
set -g fish_color_status red

set -g fish_pager_color_completion normal
set -g fish_pager_color_description brblack
set -g fish_pager_color_prefix cyan --bold
set -g fish_pager_color_progress brblack --background=black
set -g fish_pager_color_selected_background --background=brblack
set -g fish_pager_color_selected_completion normal
set -g fish_pager_color_selected_description brblack
set -g fish_pager_color_selected_prefix cyan --bold
set -g fish_pager_color_secondary_background --background=black
set -g fish_pager_color_secondary_completion normal
set -g fish_pager_color_secondary_description brblack
set -g fish_pager_color_secondary_prefix cyan --bold
