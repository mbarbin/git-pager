#!/bin/bash -e

dirs=(
    # Add new directories below:
    "bin"
    "lib/git_pager/src"
    "lib/git_pager/test"
    "lib/git_pager_cli/src"
    "lib/git_pager_cli/test"
)

for dir in "${dirs[@]}"; do
    # Apply headache to .ml files
    headache -c .headache.config -h COPYING.HEADER ${dir}/*.ml

    # Check if .mli files exist in the directory, if so apply headache
    if ls ${dir}/*.mli 1> /dev/null 2>&1; then
        headache -c .headache.config -h COPYING.HEADER ${dir}/*.mli
    fi
done

dune fmt
