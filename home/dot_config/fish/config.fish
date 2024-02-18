if test $HOME/.asdf/asdf.fish
  source $HOME/.asdf/asdf.fish

  if not test -d ~/.config/fish/completions
    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
  end

  if test -d $HOME/.asdf/plugins/java
    source $HOME/.asdf/plugins/java/set-java-home.fish
  end
end

# function fish_greeting
#   neofetch
# end

if type -q direnv
  direnv hook fish | source
end
