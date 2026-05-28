#!/usr/bin/env bash
set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  printf 'sessionizer: tmux is required\n' >&2
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  printf 'sessionizer: fzf is required\n' >&2
  exit 1
fi

default_roots="$HOME/Documents/dev:$HOME/Documents/notes:$HOME/.config"
IFS=':' read -r -a search_roots <<< "${SESSIONIZER_ROOTS:-$default_roots}"

list_candidates() {
  for root in "${search_roots[@]}"; do
    [ -d "$root" ] || continue
    find "$root" \
      -mindepth 1 \
      -maxdepth 2 \
      \( -name .git -o -name target -o -name node_modules -o -name .direnv -o -name .venv -o -name .cache \) -prune \
      -o -type d -print
  done | sort -u
}

choose_candidate() {
  if [ "$#" -gt 0 ]; then
    if [ -d "$*" ]; then
      printf '%s\n' "$*"
      return
    fi

    list_candidates | fzf --query="$*" --select-1 --exit-0 --prompt='session> '
    return
  fi

  list_candidates | fzf --prompt='session> ' --height=40% --reverse
}

selected="$(choose_candidate "$@")"
[ -n "$selected" ] || exit 0

session_name="$(basename "$selected" | tr ' .:-' '____')"

if [ -z "${TMUX:-}" ]; then
  exec tmux new-session -A -s "$session_name" -c "$selected"
fi

if ! tmux has-session -t "=$session_name" 2>/dev/null; then
  tmux new-session -d -s "$session_name" -c "$selected"
fi

tmux switch-client -t "=$session_name"
