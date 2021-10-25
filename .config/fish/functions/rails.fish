function rails
  if test -e Gemfile
    # run in bundle context
    command bundle exec rails $argv
  else
    # use global bin
    command rails $argv
  end
end

function rake
  if test -e Gemfile
    # run in bundle context
    command bundle exec rake $argv
  else
    # use global bin
    command rake $argv
  end
end
