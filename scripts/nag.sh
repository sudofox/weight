#!/bin/bash

(
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  TODAY=$(printf '%(%Y-%m-%d)T\n' -1)
  COLOR_RED="\e[31m"
  COLOR_RESET="\e[0m"

  JOURNAL_FILE="$DIR/../data/weight.csv"
  # csv is in format date,pounds,kilograms,delta_pounds,delta_kilograms

  # if the journal doesn't contain today's date, print a nag in red text to stderr
  if ! grep -q "$TODAY" "$JOURNAL_FILE"; then
    echo -e "${COLOR_RED}Please enter your weight for today${COLOR_RESET}" >&2
    echo -e "${COLOR_RED}$DIR/weight.sh <weight in lbs>${COLOR_RESET}" >&2
  fi
)

# Add this to your .bashrc to enable the daily nag
# PROMPT_COMMAND="~/git/weight/scripts/nag.sh ; $PROMPT_COMMAND"
