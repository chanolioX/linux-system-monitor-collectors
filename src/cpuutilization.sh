#!/usr/bin/env bash

# -- ABOUT THIS PROGRAM: ------------------------------------------------------
#
# Author:       
# Version:      1.0.0
# Description:  
# Source:       
#
# -- INSTRUCTIONS: ------------------------------------------------------------
#
# Execute:
#   $ chmod u+x myscript.sh && ./myscript.sh
#
# Options:
#   -h, --help      output program instructions
#   -v, --version   output program version
#
#
# Important:
#   some important note goes here
#
# -- CHANGELOG: ---------------------------------------------------------------
#
#   DESCRIPTION:    First release
#   VERSION:        1.0.0
#   DATE:           xx/xx/xxxx
#   AUTHOR:         
#
# -- TODO & FIXES: ------------------------------------------------------------
#
#
# -----------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# | VARIABLES                                                                  |
	# ------------------------------------------------------------------------------

VERSION="1.0.0"
PROGRAM="DataCollector"

PRINT=$(type -P printf)
ECHO=$(type -P echo)
SED=$(type -P sed)
GREP=$(type -P grep)
TR=$(type -P tr)
AWK=$(type -P awk)
CAT=$(type -P cat)
HEAD=$(type -P head)
CUT=$(type -P cut)
PS=$(type -P ps)

# ------------------------------------------------------------------------------
# | UTILS                                                                      |
# ------------------------------------------------------------------------------

# Header logging
e_header() {
	printf "$(tput setaf 38)→ %s$(tput sgr0)\n" "$@"
}

# Success logging
e_success() {
	printf "$(tput setaf 76)✔ %s$(tput sgr0)\n" "$@"
}

# Error logging
e_error() {
	printf "$(tput setaf 1)✖ %s$(tput sgr0)\n" "$@"
}

# Warning logging
e_warning() {
	printf "$(tput setaf 3)! %s$(tput sgr0)\n" "$@"
}

# ------------------------------------------------------------------------------
# | MAIN FUNCTIONS                                                             |
# ------------------------------------------------------------------------------


# by Paul Colby (http://colby.id.au), no rights reserved ;)
cpu_utilization() {

	PREV_TOTAL=0
	PREV_IDLE=0
	iteration=0

	while [[ iteration -lt 2 ]]; do
		# Get the total CPU statistics, discarding the 'cpu ' prefix.
		CPU=(`$SED -n 's/^cpu\s//p' /proc/stat`)
		IDLE=${CPU[3]} # Just the idle CPU time.

		# Calculate the total CPU time.
		TOTAL=0
		for VALUE in ${CPU[@]}; do
			let "TOTAL=$TOTAL+$VALUE"
		done

		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000 * ($DIFF_TOTAL-$DIFF_IDLE) / $DIFF_TOTAL+5) / 10"
		#echo -en "\rCPU: $DIFF_USAGE%  \b\b"

		# Remember the total and idle CPU times for the next check.
		PREV_TOTAL=$TOTAL
		PREV_IDLE=$IDLE

		# Wait before checking again.
		sleep 1
		iteration=$iteration+1
	done
	$PRINT '{"cpuutilization":"%d"}\n' $DIFF_USAGE
}

# My Script Version
myscript_version() {
	echo "$PROGRAM: v$VERSION"
}

# My Script Start
myscript_start() {
		cpu_utilization
}


# ------------------------------------------------------------------------------
# | INITIALIZE PROGRAM                                                         |
# ------------------------------------------------------------------------------

main() {

	if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
		myscript_help ${1}
		exit
	elif [[ "${1}" == "-v" || "${1}" == "--version" ]]; then
		myscript_version ${1}
		exit
	else
		myscript_start
	fi

}

# Initialize
main $*


