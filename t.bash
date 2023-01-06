#!/usr/bin/env bash

# t - https://github.com/nick-f/t
# Search your project directories and open a new Tmux session for the selected project
#
# Inspired by https://github.com/jessarcher/dotfiles/blob/master/scripts/t and by extension
# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

t_paths=${T_PATHS:-}
t_paths_delimiter=${T_PATHS_DELIMITER:- }

help_text() {
	echo -e "t - https://github.com/nick-f/t

usage: [environment_variables] $(basename "$0") [options]

Set T_PATHS in your shell profile or on a per-command basis to search additional directories.

Options
  --help, -h\tDisplay this help text

Environment variables
  T_PATHS
    List of paths to search, separated by T_PATHS_DELIMITER. These should be
    absolute paths unless you know what you're doing.
    Example: T_PATHS=\"~/Code ~\"

  T_PATHS_DELIMITER
    Delimiter used when specifying paths. Change this if you have paths
    that contain spaces in them.
    Default: <space>"
}

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
		readarray -d "$t_paths_delimiter" -t t_paths<<<"${t_paths}"

		if [[ ${#t_paths[@]} -gt 0 ]]; then
			for path in "${t_paths[@]}"; do
				candidates+=$(search_path "$path")
			done
		fi
	fi

	echo "$candidates"
}

if [[ "$1" = "--help" || "$1" = "-h" ]]; then
	help_text
	exit 0
fi

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

if [[ -z $TMUX ]]; then
	tmux attach-session -t "$dirname"
else
	tmux switch-client -t "$dirname"
fi
