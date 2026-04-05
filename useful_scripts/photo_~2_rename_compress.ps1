# 「~2.jpg」とかだけを残す方法
Get-ChildItem *.jpg | Where-Object { $_.BaseName -notmatch '~\d+$' } | Remove-Item

# 「xxx~2.jpg」とかを「xxx.jpg」に戻して、「xxx.jpg」等の文字列配列を返す
$files = Get-ChildItem *.jpg | 
    Where-Object { $_.BaseName -match '~\d+$' } | 
    ForEach-Object {
        # 肯定先読みで「.jpg」の前にある「~2」等だけを削除する
        $newName = $_.Name -replace '~\d+(?=\.)', ''
        # "旧ネーム: $($_.Name)`n新ネーム: $newName"
        Rename-Item $_.Name $newName
        $newName
        # $_.BaseName を操作するパターン。後で拡張子を付ける
        # $newName = $_.BaseName -replace '~\d+$', ''
        # $newName += $_.Extension
        # Rename-Item $_.Name $newName -WhatIf
    }

$destPath = Split-Path -Leaf $pwd
$zipName = "$destPath.zip"
Compress-Archive -Path $files -DestinationPath $zipName -Force

Remove-Item $files