#!/usr/bin/env bash

# Search your project directories and open a new Tmux session for the selected project
#
# Environment variables:
#   - T_PATHS
#       List of paths to search, separated by T_PATH_DELIMITER. These should be
#       absolute paths unless you know what you're doing.
#       Example: t_paths="~/Code ~"
#   - T_PATH_DELIMITER
#       Delimiter used when specifying paths. Change this if you have paths
#       that contain spaces in them.
#       Default: <space>

# Inspired by https://github.com/jessarcher/dotfiles/blob/master/scripts/t and by extension
# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

t_paths=${T_PATHS:-}
t_path_delimiter=${T_PATH_DELIMITER:- }

search_path() {
  local path; path=$(expand_path "$1")
  local paths; paths=$(find "$path" -maxdepth 1 -mindepth 1 -type d | sed 's#/Users/[a-zA-Z0-9]*/#~/#g' | sort --ignore-case)

  echo -e "\n$paths"
}

expand_path() {
  # Expand the path ($1) by replacing `~` with the value of `$HOME`
  echo "${1//\~/$HOME}"
}

candidate_list() {
  local candidates;
  candidates=$(echo -e "/tmp")

  if [[ -n ${t_paths} ]]; then
    readarray -d "$t_path_delimiter" -t t_paths<<<"${t_paths}"

    if [[ ${#t_paths[@]} -gt 0 ]]; then
      for path in "${t_paths[@]}"; do
        candidates+=$(search_path "$path")
      done
    fi
  fi

  echo "$candidates"
}

if [[ $# -eq 1 ]]; then
  selected="$1"
else
  candidates=$(candidate_list)

  selected=$(expand_path "$(echo "$candidates" | fzf)")
fi

dirname=$(basename "$selected" | sed 's/\./_/g')

if [[ -z "$dirname" ]]; then
  exit 1
fi

if ! tmux has-session -t="$dirname" 2> /dev/null; then
  tmux new-session -c "$selected" -ds "$dirname"
fi

tmux switch-client -t "$dirname"
