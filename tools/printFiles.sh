#!/bin/bash

# Usage: ./tools/printFiles.sh /Users/Tim.Ebner/coding/private/Pantomias/assets/images/pants

DIR="$1"

# Check if directory exists
if [[ ! -d "$DIR" ]]; then
  echo "Error: Directory not found"
  exit 1
fi

# Loop through files in the directory
for file in "$DIR"/*; do
  filename="$(basename "$file")"
  echo "- assets/images/pants/${filename}"
done