#!/bin/bash

# This file is to replace the normal mathjax delimiters ('$' and '$$') with Github favoured math delimiters in Markdown. Precisely speaking, replace "$...$" with "$`...`$" and replace "$$...$$" with the code block
# ```math
# ...
# ```

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Get the file name from the command line argument
input_file="$1"

# Extract the base name and extension
base="${input_file%.*}"
ext="${input_file##*.}"

# Add suffix
output_file="${base}_readable.${ext}"

#############
# Funtion 1 #
#############
# Use sed to replace non-overlapping pairs of single dollar signs (not double-dollar pair)
# NOTE: the dollar sign in the square bracket doesn't need to be escaped, since the characters inside square brackets are treated as a character class, where the dollar sign has no special meaning.

# The following regexs have been deemed to be wrong:
# 1. 's/\$\([^$]*\)\$/\$\`\1\`$/g': wrong because it changes unwillingly "$$" to "$``$".
# 2. 's/\$\([^$]\+\)\$/\$\`\1\`$/g': wrong because it fixed 1 but still fails to consider "$$...$$", which will be transformed unwillingly to "$$`...`$$".

##############
# Function 2 #
##############
# Replace a pair of double-dollar signs with one starting with "```math" and ending with "```". THe beginning and ending phase occupy the whole line.

sed -e 's/\([^$]*\)\(\$[`]*\)\([^`$]\+\)\([`]*\)\$\([^$]\)/\1\$\`\3\`\$\5/g' -e 's/\([ \t]*\)\$\$\([^$]*\)\$\$/\1\`\`\`math\n\1\2\n\1\`\`\`/g' "$input_file" > "$output_file"
