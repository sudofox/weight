#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
TODAY=$(printf '%(%Y-%m-%d)T\n' -1)
JOURNAL_FILE="$DIR/../data/weight.csv"

# validate the command line argument is a number
if ! [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "Usage: $0 <weight in lbs>"
  exit 1
fi

# function to convert pounds to kilograms (round to no decimal places)
function to_kg() {
  echo $(printf "%.0f" $(echo "$1 * 0.45359237" | bc -l))
}

# delta is the difference between the last weight and the current weight
function delta() {
  echo $(echo "$1 - $2" | bc -l)
}

# print the current weight in a friendly format
friendly_status() {
  LAST_WEIGHT=$(cat "$JOURNAL_FILE" | grep -v "^$" | tail -n1)
  LW_DATE=$(echo "$LAST_WEIGHT" | awk -F, '{print $1}')
  LW_POUNDS=$(echo "$LAST_WEIGHT" | awk -F, '{print $2}')
  LW_KILOGRAMS=$(echo "$LAST_WEIGHT" | awk -F, '{print $3}')
  LW_DELTA_POUNDS=$(echo "$LAST_WEIGHT" | awk -F, '{print $4}')
  LW_DELTA_KILOGRAMS=$(echo "$LAST_WEIGHT" | awk -F, '{print $5}')
  LW_DELTA_PLUS_OR_MINUS=$(echo "$LW_DELTA_POUNDS" | awk '{if ($1 < 0) print "-"; else print "+"}')
  echo "Current weight: $LW_POUNDS lbs ($LW_KILOGRAMS kg) measured on $LW_DATE ($LW_DELTA_PLUS_OR_MINUS$LW_DELTA_POUNDS lbs/$LW_DELTA_KILOGRAMS kg)"
}

# if there's already an entry for today, exit
if grep -q "$TODAY" "$JOURNAL_FILE"; then
  echo "Weight already entered for today :)"
  friendly_status
  exit 0
fi

# get the last weight from the journal and parse it
LAST_WEIGHT=$(cat "$JOURNAL_FILE" | grep -v "^$" | tail -n1)

# parse it into variables
LW_DATE=$(echo "$LAST_WEIGHT" | awk -F, '{print $1}')
LW_POUNDS=$(echo "$LAST_WEIGHT" | awk -F, '{print $2}')
LW_KILOGRAMS=$(echo "$LAST_WEIGHT" | awk -F, '{print $3}')

# if LW_DATE = "date", then this is the first entry
if [ "$LW_DATE" = "date" ]; then
  LW_POUNDS=0
  LW_KILOGRAMS=0
fi

# get the current weight from the command line
CURRENT_WEIGHT=$1

# calculate the delta
DELTA_POUNDS=$(delta "$CURRENT_WEIGHT" "$LW_POUNDS")
DELTA_KILOGRAMS=$(delta $(to_kg "$CURRENT_WEIGHT") $(to_kg "$LW_POUNDS"))
NEW_WEIGHT="$TODAY,$CURRENT_WEIGHT,$(to_kg "$CURRENT_WEIGHT"),$DELTA_POUNDS,$DELTA_KILOGRAMS"

# append the new weight to the journal
echo "$NEW_WEIGHT" >>"$JOURNAL_FILE"

# print the new weight in a friendly format
friendly_status