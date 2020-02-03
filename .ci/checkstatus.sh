#!/bin/sh

# ---------------------------------------
# | Name: checkstatus.sh                |
# | Instructions: sh checkstatus.sh     |
# | Description: Checks if all the webs |
# |	in the README.md file are up.   |
# | Author: Kike Fontán (@CosasDePuma)  |
# ---------------------------------------

# Check if a link is from HackTheirX repository
is_HackTheirX() { link=$(echo "${1}" | tr "[:upper:]" "[:lower:]") && [ -n "${link##*hack-their-x*}" ]; }

# Get the links in the file
get_links() {
	dir=$(dirname "$(readlink -f "${0}")")
	file="${dir}/../README.md"
	regex="\(https?://[^\)]+\)"
	grep -oE "${regex}" "${file}" | sed 's/^(\(.*\))$/\1/g'
}

# Check if the status code of a link is 200 (OK)
check_status() {
	status=$(curl -ILso /dev/null -w "%{http_code}" "${1}")
	[ "${status}" -eq 200 ]
}

# Entrypoint of the program
entrypoint() {
	# Iterate over the links
	links=$(get_links)
	for link in $links
	do
		# Avoid HackTheirX repository links
		if ! is_HackTheirX "${link}"
		then
			# Error exit status if a link is down
			check_status "${link}" || return 1
		fi
	done
}
entrypoint
