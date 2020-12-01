#!/bin/bash
set -euo pipefail

command=${1:-create}

if [[ ! -x "./${command}.sh" ]]; then
	ux print ":panda_face: The command $command was not found."
	exit 23
fi

./${command}.sh
