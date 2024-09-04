#!/bin/bash

# 対話型で整理したいディレクトリを選択
echo "整理したいディレクトリのパスを入力してください:"
read TARGET_DIR

# 対話型で指定したディレクトリが存在するか確認
if [ ! -d "$TARGET_DIR" ]; then
    echo "ディレクトリが存在しません。"
    exit 1
fi

# フォルダ内のファイルをループ処理
for file in "$TARGET_DIR"/*; do

    if [[ -f "$file" ]]; then
        # ファイルの作成日を取得（yyyy-mm形式の年月）
        file_date=$(date -r "$file" +%Y-%m)

        # 対応する年月のフォルダを作成
        target_dir="$TARGET_DIR/$file_date"

        # 同じ名前のディレクトリの存在確認
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
        fi

        # ファイルの移動先パス
        target_file="$target_dir/$(basename "$file")"

        # 同じ名前のファイルの存在確認 (同一ファイルがあれば上書きするかどうか確認)
        if [ -e "$target_file" ]; then
            echo "ファイル '$target_file' が既に存在します。上書きしますか？（yes/no): "
            read -r overwrite_decision
            if [ "$overwrite_decision" == "yes" ]; then
                mv -f "$file" "$target_file"
                echo "Moved $file to $target_file"
            else
                echo "上書きを中止しました。"
            fi
        else
            mv "$file" "$target_file"
            echo "Moved $file to $target_file"
        fi
    fi

done

