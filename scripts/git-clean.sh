#!/bin/bash

pwd

du -h -d 1 | sort -h

gcs="gc.aggressiveDepth gc.pruneExpire gc.worktreePruneExpire gc.reflogExpire"

for g in $gcs; do
    echo -e "$g:\t\t$(git config --get $g)"
    if [ $g == "gc.aggressiveDepth" ]; then
        git config $g 1
    else
        git config $g now # now 1.day 2.days.ago
    fi
    echo -e "$g:\t\t$(git config --get $g)"
done

SUBMODULES=$(git submodule -q foreach pwd | xargs -n 1 basename)
# SUBMODULES+=" ./"

# for subMod in "routinator "; do
for subMod in "./" $SUBMODULES; do
    echo "------------------ subMod: $subMod ------------------"
    du -s $subMod
    git gc --aggressive --prune
    # git repack -adF --depth=50 #--window=1
    # git reflog expire --expire=now --all # --dry-run
    sleep 2
    du -s $subMod
done

for g in $gcs; do
    git config --unset $g
    echo -e "$g:\t\t$(git config --get $g)"
done

du -h -d 1 | sort -h
