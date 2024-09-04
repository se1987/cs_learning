#!/bin/bash

# 対話型で整理したいディレクトリを選択
echo "整理したいディレクトリのパスを入力してください:"
read TARGET_DIR

# 対話型で指定したディレクトリが存在するか確認
if [ ! -d "$TARGET_DIR" ]; then
    echo "ディレクトリが存在しません。"
    exit 1
fi

# 画像ファイルの拡張子の配列
img_extensions=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "svg" "ico" "heic")

# 指定したディレクトリ内のファイルをループ処理
for file in "$TARGET_DIR"/*; do

    if [[ -f "$file" ]]; then

        # ファイルの拡張子を取得
        file_extension=${file##*.}

        # 拡張子を小文字に変換（Bash ver.4未満に対応）
        file_extension=$(echo "$file_extension" | tr '[:upper:]' '[:lower:]')

        # 拡張子が画像ファイルの拡張子に含まれているか確認
        if [[ " ${img_extensions[@]} " =~ " ${file_extension} " ]]; then
            # 画像ファイルの場合、imgフォルダを作成
            target_dir="$TARGET_DIR/img"
        else
            # 画像ファイル以外の場合、拡張子ごとのフォルダを作成
            target_dir="$TARGET_DIR/$file_extension"
        fi

        # 同じ名前のディレクトリの存在確認
        if [ ! -d "$target_dir" ]; then
            # ディレクトリが存在しない場合フォルダを作成
            mkdir -p "$target_dir"
        fi

        # ファイルの移動先パス
        target_file="$target_dir/$(basename "$file")"

        # 同じ名前のファイルの存在確認 (同一ファイルがあれば上書きするかどうか確認)
        if [ -e "$target_file" ]; then
            echo "ファイル '$target_file' が既に存在します。上書きしますか？（yes/no): "
            read -r overwrite_decision
            if [ "$overwrite_decision" == "yes" ]; then
                mv -f "$file" "$target_dir/"
                echo "Moved $file to $target_dir/"
            else
                # ファイルの作成日を取得（%Y-%m-%d形式の日付）
                file_date=$(date -r "$file" +%Y-%m-%d)
                # 新しいファイル名(「ファイル名_(ファイル作成日）」）を設定
                new_target_file="$target_dir/$(basename "${file%.*}")_$file_date.${file_extension}"
                mv "$file" "$new_target_file"
                echo "Moved $file to $new_target_file"
            fi
        else
            mv "$file" "$target_dir/"
            echo "Moved $file to $target_dir/"
        fi
    fi

done
