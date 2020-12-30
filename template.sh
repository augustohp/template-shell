#!/usr/bin/env bash
#
# Author: Maciej Radzikowski <https://github.com/m-radzikowski>
# Taken from: https://betterdev.blog/minimal-safe-bash-script-template/

set -Eeuo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

trap cleanup SIGINT SIGTERM ERR EXIT

# Usage: display_help_and_exit
display_help_and_exit() {
	cat <<-EOF
	Usage: $(basename "$0") [-h] [-v] [-f] -p param_value arg1 [arg2...]

	Script description here.

	Available options:

	-h, --help      Print this help and exit
	-v, --verbose   Print script debug info
	-f, --flag      Some flag description
	-p, --param     Some param description
EOF
	exit 1
}

# Usage: cleanup
cleanup() {
	trap - SIGINT SIGTERM ERR EXIT
}

# Usage: setup_colors
setup_colors() {
	# shellcheck disable=SC2034
	if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
		NOCOLOR='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
	else
		NOCOLOR='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
	fi
}

# Usage: msg <message>
msg() {
	echo >&2 -e "${1-}"
}

# Usage: die <message> [exit code]
die() {
	local msg=$1
	local code=${2-1} # default exit status 1
	msg "$msg"
	exit "$code"
}

# Usage: parse_params
parse_params() {
	# default values of variables set from params
	flag=0
	param=''

	while :; do
		case "${1-}" in
		-h | --help)
			display_help_and_exit
			;;
		-v | --verbose)
			set -x
			;;
		--no-color)
			NO_COLOR=1
			;;
		-f | --flag) # example flag
			flag=1
			;;
		-p | --param) # example named parameter
			param="${2-}"
			shift
			;;
		-?*)
			die "Unknown option: $1"
			;;
		*)
			break
			;;
		esac
		shift
	done

	args=("$@")

	# check required params and arguments
	[[ -z "${param-}" ]] && die "Missing required parameter: param"
	[[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

	return 0
}

parse_params "$@"
setup_colors

# script logic here

msg "${RED}Read parameters:${NOCOLOR}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"
