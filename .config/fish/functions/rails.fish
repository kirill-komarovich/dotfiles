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

function sidekiq
  if test -e Gemfile
    # run in bundle context
    command bundle exec sidekiq $argv
  else
    # use global bin
    command sidekiq $argv
  end
end

function rspec
  if test -e Gemfile
    # run in bundle context
    command bundle exec rspec $argv
  else
    # use global bin
    command rspec $argv
  end
end

function pronto
  if test -e Gemfile
    # run in bundle context
    command bundle exec pronto $argv
  else
    # use global bin
    command pronto $argv
  end
end

function rubocop
  if test -e Gemfile
    # run in bundle context
    command bundle exec rubocop $argv
  else
    # use global bin
    command rubocop $argv
  end
end
