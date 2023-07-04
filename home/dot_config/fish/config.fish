if test $HOME/.asdf/asdf.fish
  source $HOME/.asdf/asdf.fish

  if not test -d ~/.config/fish/completions
    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
  end
end

# function fish_greeting
#   neofetch
# end

direnv hook fish | source
