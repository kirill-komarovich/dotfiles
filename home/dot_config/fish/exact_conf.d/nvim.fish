function nvim --wraps nvim
  if test -e .git/config
    set pipe_name (basename (pwd))

    command nvim --listen $HOME/.cache/nvim/$pipe_name.pipe $argv
  else
    command nvim $argv
  end
end

