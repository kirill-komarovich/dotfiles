alias dcup='docker-compose up'
alias dcdn='docker-compose down'
alias dcb='docker-compose build'
alias dcr='docker-compose run --rm'
alias dce='docker-compose exec'
alias dcrs='docker-compose restart'
alias dcl='docker-compose logs -f'
alias dcchown='sudo chown -R $USER'

# alias livebook-up='docker run -d --rm --name livebook -p 127.0.0.1:8080:8080 -u (id -u):(id -g) -v ~/projects/elixir/.livebook:/data livebook/livebook'
alias livebook-up='docker run -d --rm --name livebook -p 8080:8080 -e LIVEBOOK_PASSWORD=f6fbd3f19ec020b64a62967c84c1c8e4 -u (id -u):(id -g) -v ~/projects/elixir/.livebook:/data livebook/livebook'
alias livebook-pass='echo f6fbd3f19ec020b64a62967c84c1c8e4'
alias livebook-down='docker stop livebook'

alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
