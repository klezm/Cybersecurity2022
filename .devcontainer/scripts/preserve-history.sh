#!/bin/bash

TERM_HIST_PATH=/home/vscode/.zsh_history
TERM_HIST_PATH=/root/.zsh_history
TERM_HIST_PATH=~/.zsh_history

# ([ -f $TERM_HIST_PATH ] && [ 0 -lt $(wc -l <$TERM_HIST_PATH) ]) && echo -e "\n$(git diff --no-index .zsh_history $TERM_HIST_PATH | grep -oP '(?<=^\\+):.*$')" >> .zsh_history || cp .zsh_history $TERM_HIST_PATH
if [ -f $TERM_HIST_PATH ] && [ 0 -lt $(wc -l <$TERM_HIST_PATH) ]; then
    echo "  ----- Merging history -----"
    # echo -e "\n$(git diff --no-index .zsh_history $TERM_HIST_PATH | grep -oP '(?<=^\+):.*$')" >> .zsh_history
    # Only copy the last block of changes.
    # git diff --no-index .zsh_history $TERM_HIST_PATH | grep -zoP '(\n\+.*)+\s*\z' | grep -zoP '(?<=\+):.*\n' | sed 's/\x0//g' >> .zsh_history
    hist_diff=$(git diff --no-index .zsh_history $TERM_HIST_PATH |
                grep -zoP '(\n\+.*)+\s*\z' | # Get the last block of lines starting with a +
                grep -zoP '(?<=\+):.*\n' | # Remove the + at the beginning of each line
                sed 's/\x0//g') # Remove the null bytes
    if [ -n "$hist_diff" ]; then
        echo "" >> .zsh_history # Add a newline
        echo "$hist_diff" >> .zsh_history
    fi
else
    echo "  ----- Copying history -----"
    cp .zsh_history $TERM_HIST_PATH
fi
