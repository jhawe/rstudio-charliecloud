#!/usr/bin/env bash

# Script adjusted from https://github.com/OSC/bc_osc_rstudio_server

# Confirm username is supplied
if [[ $# -ne 1 ]]; then
  echo "Usage: auth USERNAME"
  exit 1
fi
USERNAME="${1}"

# Confirm password environment variable exists (set in start_rstudio.sh)
if [[ -z ${RSTUDIO_PASSWORD} ]]; then
  echo "The environment variable RSTUDIO_PASSWORD is not set"
  exit 1
fi

# Read in the password from user
read -s -p "Password: " PASSWORD
echo ""

if [[ ${USERNAME} == ${USER} && ${PASSWORD} == ${RSTUDIO_PASSWORD} ]]; then
  echo "Successful authentication"
  exit 0
else
  echo "Invalid authentication"
  exit 1
fi

