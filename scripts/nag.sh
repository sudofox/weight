#!/bin/bash

(
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

  TODAY=$(printf '%(%Y-%m-%d)T\n' -1)

  JOURNAL_FILE="$DIR/../data/weight.csv"
  # csv is in format date,pounds,kilograms,delta_pounds,delta_kilograms

  # if the journal doesn't contain today's date, print a nag in red text to stderr
  if ! grep -q "$TODAY" "$JOURNAL_FILE"; then
    echo -e "\e[31mPlease enter your weight for today\e[0m" >&2
    echo -e "\e[31m$DIR/weight.sh <weight in lbs>\e[0m" >&2
  fi
)

export PROMPT_COMMAND="~/git/weight/scripts/nag.sh ; $PROMPT_COMMAND"
