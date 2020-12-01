#!/bin/bash
set -euo pipefail

# Tugboat Documentation https://api.tugboat.qa/v3#tag/Previews

tugboat_token=$(sdk secret get TUGBOAT_TOKEN)
tugboat_repo_id=$(sdk config get tugboat_repo_id)

if [[ -z "$tugboat_repo_id" ]]; then
	tugboat_repo_id=$(ux prompt input \
		--message "Please provide the Tugboat Repo ID" \
		--name "tugboat_repo_id")
	sdk config set --key tugboat_repo_id --value "$tugboat_repo_id"
fi

type_label=$(ux prompt list \
    "Pull Request" "Branch" "Tag" "Commit" \
	--message "What type of Preview will you be building?" \
	--default "Pull Request" \
	--name "type")

# Strip any spaces.
type=${type_label/\ /}
# Make lowercase.
type=$(echo "$type" | tr '[:upper:]' '[:lower:]')

if [[ "$type" = "pullrequest" ]]; then
	ref=$(ux prompt input \
		--message "What is the number of the Pull Request you would like to create a Tugboat Preview for? e.g. '1234'" \
		--name "ref")
else
	ref=$(ux prompt input \
		--message "What is the $type_label you would like to create a Tugboat Preview for?" \
		--name "ref")
fi

ux spinner start --message "Creating a Tugboat Preview for $type_label '$ref'."

set +e
json=$(tugboat create preview \
	$ref \
	-j \
	-t $tugboat_token \
	repo=$tugboat_repo_id \
	type=$type)
exit_code=$?
set -e

ux spinner stop

if [[ $exit_code -gt 0 ]]; then
	ux print ":panda_face: The build failed. Check it out at https://dashboard.tugboat.qa/$tugboat_repo_id"
else
	ux print "🚀 Your Tugboat Preview is ready!

Check it out at $(echo $json | jq -r .url)
Find logs and more at https://dashboard.tugboat.qa/$(echo $json | jq -r .id)"
fi
