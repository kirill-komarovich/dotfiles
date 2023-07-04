set maybe_gemfile_commands rails rake sidekiq cap rspec rubocop

for name in $maybe_gemfile_commands
  function $name --wraps $name
    if test -e Gemfile -a (gem list "^($_)\$" -i) = true
      echo "Using Gemfile $_"
      command bundle exec $_ $argv
    else
      echo "Using global $_"
      command $_ $argv
    end
  end
end
