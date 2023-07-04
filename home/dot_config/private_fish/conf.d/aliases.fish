alias dcup='docker-compose up'
alias dcdn='docker-compose down'
alias dcb='docker-compose build'
alias dcr='docker-compose run --rm'
alias dce='docker-compose exec'
alias dcrs='docker-compose restart'
alias dcl='docker-compose logs -f'
alias dcchown='sudo chown -R $USER'

# alias livebook-up='docker run -d --rm --name livebook -p 127.0.0.1:8080:8080 -u (id -u):(id -g) -v ~/projects/elixir/.livebook:/data livebook/livebook'
alias livebook-up='docker run -d --rm --name livebook -p 127.0.0.1:8080:8080 -p 127.0.0.1:8081:8081 -e LIVEBOOK_TOKEN_ENABLED="false" -e XLAXLA_TARGET="cuda118" -u $(id -u):$(id -g) -v ~/projects/elixir/.livebook:/data --pull always ghcr.io/livebook-dev/livebook:latest-cuda11.8'

alias livebook-down='docker stop livebook'

alias cdc="cd && clear"
