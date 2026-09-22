function claude --wraps 'command claude' --description 'Run Claude Code in the configured profile'
    if set -q CLAUDE_CONFIG_DIR
        command claude $argv
        return
    end

    if set -q CLAUDE_PROFILE[1]; and test -n "$CLAUDE_PROFILE"
        CLAUDE_PROFILE=$CLAUDE_PROFILE command claude-profile $argv
        return
    end

    command claude-profile $argv
end
