#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob

# all202602211200.txt みたいなファイル名
output="all$(date '+%Y%m%d%H%M').txt"

# [memo1, memo2, memo3, ... memoN] のような配列を作る
mapfile -t files < <(printf "%s\n" memo* | sort -V)

# ==== memo1 ====
# 内容
# (改行)
# をoutputに追記

for f in "${files[@]}"; do
    echo "==== $f ===="
    cat "$f"
    echo
done >> "$output"

# 残ったmemo*を削除
rm -rf memo*

# set -e
# エラーが出たら即終了
# set -u
# 未定義変数を使ったらエラー
# set -o pipefail
# パイプのどこかで失敗したら終了
# IFS=$'\n\t'
# 区切り文字をタブ、改行だけにする
# shopt -s nullglob
# ワイルドカード展開に失敗した時に空文字列に展開する(結果的に処理がされない)