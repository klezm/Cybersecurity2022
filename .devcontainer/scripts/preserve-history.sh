#!/bin/bash

# ([ -f ~/.zsh_history ] && [ 0 -lt $(wc -l <~/.zsh_history) ]) && echo -e "\n$(git diff --no-index .zsh_history ~/.zsh_history | grep -oP '(?<=^\\+):.*$')" >> .zsh_history || cp .zsh_history ~/.zsh_history
if [ -f ~/.zsh_history ] && [ 0 -lt $(wc -l <~/.zsh_history) ]; then
    echo "  ----- Merging history -----"
    # echo -e "\n$(git diff --no-index .zsh_history ~/.zsh_history | grep -oP '(?<=^\+):.*$')" >> .zsh_history
    # Only copy the last block of changes.
    # git diff --no-index .zsh_history ~/.zsh_history | grep -zoP '(\n\+.*)+\s*\z' | grep -zoP '(?<=\+):.*\n' | sed 's/\x0//g' >> .zsh_history
    hist_diff=$(git diff --no-index .zsh_history ~/.zsh_history |
                grep -zoP '(\n\+.*)+\s*\z' | # Get the last block of lines starting with a +
                grep -zoP '(?<=\+):.*\n' | # Remove the + at the beginning of each line
                sed 's/\x0//g') # Remove the null bytes
    if [ -n "$hist_diff" ]; then
        echo "" >> .zsh_history # Add a newline
        echo "$hist_diff" >> .zsh_history
    fi
else
    echo "  ----- Copying history -----"
    cp .zsh_history ~/.zsh_history
fi
