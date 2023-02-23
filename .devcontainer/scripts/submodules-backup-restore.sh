#!/bin/bash

BACKUP_RESTORE=${1:-"backup"}
REPO_DIFF_SUFFIX="-diff"

echo Performs $BACKUP_RESTORE of changes from submodules. the changes are stored in a folder named "<REPO_FOLDER>-diff".

SUBMODULES=$(git submodule -q foreach pwd | xargs -n 1 basename)
if [ -z "$SUBMODULES" ]; then
    SUBMODULES=$(find . -mindepth 2 -maxdepth 2 -type d -name ".git" -exec dirname {} +)
    # SUBMODULES=$(grep -oP "(?<=\[submodule \")[\w-]+(?=\"\])" .gitmodules)
fi

function backup_changes() {
    changes=$(git -C $subMod status --short --untracked-files | awk '{print $2}')

    for change in $changes; do
        # mkdir -p $subModDiffDir
        changePath=$(realpath $subMod/$change)
        if [ -d $changePath ]; then
            echo "$change is a directory. Skipping..."
            continue
            # diffDir=${change%/} # remove trailing slash
            # diffDirParent=$(dirname $diffDir)
            # change=$diffDir
            # cp -r $subMod/$diffDir $subModDiffDir/$diffDir
        else
            diffDir=$(dirname $change)
            mkdir -p $subModDiffDir/$diffDir
            if [ ! -d $subModDiffDir/$change ] || [ -n "$(git diff --no-index $changePath $subModDiffDir/$change)" ]; then
                echo -e "\tcp ...$change \t ->  $subModDiffDir/$diffDir/"
                cp $changePath $subModDiffDir/$diffDir/
            fi
        fi
        # echo -e "$diffDir \t\t $change \t\t $(realpath $subMod/$change)"
    done


    # List ignored changes which haven't been backed up

    # git -C rpki-rs status -s --ignored -z || # grep -zPo '^\!\!.*$'
    # ignoredChanges=$(git -C $subMod status -s --ignored -z)
    # ignoredChanges=$(git -C $subMod status -s --ignored -z | xargs -0 grep -zPo '^\!\!.*$')
    ignoredChanges=($(git -C $subMod status -s --ignored | grep -Po '^!!.*$' | sed 's/\!! /\n/g'))
    # ignoredChanges=$(git -C $subMod status -s --ignored -z | grep -zPo '^!!.*$' | sed 's/\!! /\n/g')

    # IFS='\n' read -r -a ignoredChanges <<< "$ignoredChanges"
    # IFS=$'\x00' read -r -a ignoredChanges <<< "$ignoredChanges"
    # IFS=' ' read -r -a ignoredChanges <<< "$ignoredChanges"
    # IFS=$'\x00' read -r -d '\x00' -a ignoredChanges <<< $ignoredChanges
    # IFS= read -r -d '\x0' -a ignoredChanges <<< $ignoredChanges
    # IFS= read -r -a ignoredChanges <<< $ignoredChanges


    # # while IFS='\x00' read -r -d $'\0' var; do
    # # while IFS= read -r -d $'\0' var; do
    # # echo $ignoredChanges | while IFS= read -r -d $'\0' var; do
    # # echo $ignoredChanges | while IFS="" read -r -d "" var; do
    # # while read -r -d "" var; do
    # while IFS= read -r -d '' var; do
    #     echo " >>> $var"
    # # done < <(git -C $subMod status -s --ignored -z)
    # done <<< "$ignoredChanges"
    # # #  done <<< "$ignoredChanges"
    # # # done <<< $(echo "$ignoredChanges")
    # # # done < <(echo "$ignoredChanges")

    # echo $ignoredChanges
    # ignoredChanges=("$(git -C $subMod status -s --ignored -z | grep -zPo '^\!\!.*$' | sed 's/\\x00 /\\n/g')")
    # replace null byte with linebreak
    # ignoredChanges="$(echo $ignoredChanges | sed 's/\\x00/ /g')"
    # ignoredChanges=($ignoredChanges)

    echo -e "~~~~~~ Ignored changes: ~~~~~~"
    # for x in $ignoredChanges; do
    for x in "${ignoredChanges[@]}"; do
        # if [ "$x" == *"!!"* ]; then
        #     echo "!!!!!!!!!!!!!!!!!!!!"
        # fi
        echo -e "\t$x"
    done
}

function restore_changes() {
    find $subMod/fuzz/ -name "Cargo.lock" -type f -delete
    find $subModDiffDir -name "Cargo.lock" -type f -delete
    cp -r --verbose $subModDiffDir/* $subMod/
}

for subMod in $SUBMODULES; do
    subMod=$(basename $subMod)
    subModDiffDir="$subMod$REPO_DIFF_SUFFIX"
    echo -e "\n|||||| Submodule: $subMod ||||||"

    case $BACKUP_RESTORE in
        "backup")
            backup_changes
            ;;
        "restore")
            restore_changes
            ;;
        *)
            echo "Unknown command: $BACKUP_RESTORE."
            echo "Usage: ./submodules-backup-restore.sh [backup|restore]"
            exit 1
            ;;
    esac

    # break
done
