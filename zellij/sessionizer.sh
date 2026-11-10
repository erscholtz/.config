#!/usr/bin/env bash
set -euo pipefail

if ! command -v zellij >/dev/null 2>&1; then
  printf 'sessionizer: zellij is required\n' >&2
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  printf 'sessionizer: fzf is required\n' >&2
  exit 1
fi

default_roots="$HOME/dev:$HOME/Documents/notes:$HOME/.config"
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

if [ -z "${ZELLIJ:-}" ]; then
  cd "$selected"
  exec zellij attach --create "$session_name"
fi

# Already inside zellij: sessions can't be switched from the CLI, so open a tab
# for the project in the current session (reuse it if one with that name exists).
if zellij action query-tab-names 2>/dev/null | grep -qxF "$session_name"; then
  zellij action go-to-tab-name "$session_name"
else
  zellij action new-tab --name "$session_name" --cwd "$selected"
fi
