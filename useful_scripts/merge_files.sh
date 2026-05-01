#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

output="merged.txt"
target_dir="$1"

if [ ! -d "${target_dir}" ]; then
    echo "Error: '${target_dir}' is not a directory"
    exit 1
fi

files=$(cd "${target_dir}" && find . -type f -regex '.*/.*\..*' | sed 's|^\./||')

if [ -z "${files}" ]; then
    echo "Error: '${target_dir}' contains no files"
    exit 1
fi

> "$output"

printf "%s\n" "${files}" | sort -t. -k2,2 -k1,1 --stable | while read -r f; do
        echo "// ${f}" >> "${output}"
        cat "${target_dir}/${f}" >> "${output}"
        echo "" >> "${output}"
        echo "" >> "${output}"
done

sed -i -E '/^[[:space:]]+\/\/.+$/d' "${output}"
sed -i -E '/^\/\/ [^ ]+\.[A-Za-z0-9_]+$/!{/^\/\//d}' "${output}"

