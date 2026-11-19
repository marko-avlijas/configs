#!/bin/sh
# Install tmux-resurrect at a commit I have reviewed. No tpm: tmux.conf
# loads it directly from this path. Re-run after changing the commit.
#
# To update: look at the new commits (git -C "$DIR" fetch && git -C "$DIR" log -p
# HEAD..origin/master), review them, then put the new commit here.
set -eu

REPO="https://github.com/tmux-plugins/tmux-resurrect"
COMMIT="cff343cf9e81983d3da0c8562b01616f12e8d548"   # 2023-03-06, reviewed 2026-11-19
DIR="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins/tmux-resurrect"

[ -d "$DIR/.git" ] || git clone --quiet "$REPO" "$DIR"
git -C "$DIR" fetch --quiet origin
git -C "$DIR" -c advice.detachedHead=false checkout --quiet "$COMMIT"
echo "tmux-resurrect at $(git -C "$DIR" rev-parse HEAD) in $DIR"
