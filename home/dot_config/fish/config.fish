if test $HOME/.local/bin/mise
  set --local mise $HOME/.local/bin/mise

  if status is-interactive
    $mise activate fish | source

    if not test -d $HOME/.config/fish/completions
      mkdir -p $HOME/.config/fish/completions;
    end

    if not test -e $HOME/.config/fish/completions/mise.fish
      $mise completion fish > $HOME/.config/fish/completions/mise.fish
    end
  else
    $mise activate fish --shims | source
  end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
