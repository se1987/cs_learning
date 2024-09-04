#!/bin/bash

findFile() {
    local searchString="$1"
    grep -rl "$searchString" ./
    if [ $? -ne 0 ]; then
        echo "該当のファイルは見つかりませんでした。"
    fi
}

echo "検索する文字列を入力してください:"
read searchString

findFile "$searchString"
