#!/usr/bin/env bash

# Exit immediately if there is an error
set -e

# cause a pipeline (for example, curl -s http://sipb.mit.edu/ | grep foo) to produce a failure return code if any command errors not just the last command of the pipeline.
set -o pipefail

# The git branch we are on
readonly GITBRANCH="$(git symbolic-ref --short -q HEAD)"

main() {
  case "${GITBRANCH}" in
    master)
      cf api $CF_PROD_API
      cf auth $CF_PROD_USER $CF_PROD_PASSWORD
      cf target -o $CF_ORG
      cf target -s $CF_SPACE
      cf push -f manifest.yml
      ;;
    *)
      echo "I will not deploy this branch"
      exit 0
      ;;
  esac
}

main $@
