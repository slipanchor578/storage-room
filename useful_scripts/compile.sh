#!/usr/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: ./compile.sh <source.(c|cpp)>"
    exit 1
fi

src="$1"
shift

src_abs=$(realpath "$src")
target="${src_abs%.*}"

if [ -e "$target" ]; then
    echo "Warning: output file exists: $target"
    exit 1
fi

compile_options=(
    -Wall 
    -Wextra 
    -march=native 
    -pedantic-errors 
    -fdiagnostics-color=always 
    -O2
)

c_std="-std=c11"
cpp_std="-std=c++20"

case "$src_abs" in
    *.c)
        gcc "${compile_options[@]}" "$c_std" "$@" "${src_abs}" -o "${target}"
        ;;
    *.cpp)
        g++ "${compile_options[@]}" "$cpp_std" "$@" "${src_abs}" -o "${target}"
        ;;
    *)
        ehco "Unsupported file"
        exit 1
        ;;
esac

