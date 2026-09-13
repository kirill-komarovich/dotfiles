function __claude_profiles
    for dir in $HOME/.claude-*
        test -d $dir; or continue
        string replace -- $HOME/.claude- '' $dir
    end
end

function __claude_show_profiles
    set -l profiles (__claude_profiles)
    if not set -q profiles[1]
        echo "claude: no profiles found in ~/.claude-*" >&2
        return
    end
    echo "claude: pick one with CLAUDE_PROFILE=<name>, or run its launcher:" >&2
    for p in $profiles
        printf '  %-12s %s\n' $p "claude-$p" >&2
    end
end

function claude --wraps 'command claude' --description 'Run Claude Code in the configured profile'
    if set -q CLAUDE_CONFIG_DIR
        command claude $argv
        return
    end

    if not set -q CLAUDE_PROFILE[1]; or test -z "$CLAUDE_PROFILE"
        __claude_show_profiles
        return 64
    end

    CLAUDE_PROFILE=$CLAUDE_PROFILE command claude-profile $argv
end
