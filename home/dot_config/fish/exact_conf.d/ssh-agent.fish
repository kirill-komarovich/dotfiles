if not set -q SSH_AUTH_SOCK; and test -S $XDG_RUNTIME_DIR/ssh-agent.socket
  set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end
