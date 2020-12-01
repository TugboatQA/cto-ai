#!/bin/bash
set -euxo pipefail

tugboat_token=$(sdk secret get TUGBOAT_TOKEN)

repos=$(tugboat -t $tugboat_token ls repos -j | jq -r '.[] | "\(.name) (\(.id))"')

tugboat_repo=$(ux prompt list \
    "$repos" \
	--message "Which Repo would you like to associate with this CTO.ai team?" \
	--name "tugboat_repo")

tugboat_repo_id=$(echo $tugboat_repo | grep -Eo '\([a-z0-9]+\)$' | grep -Eo '[a-z0-9]+')

sdk config set --key tugboat_repo_id --value "$tugboat_repo_id"
