param(
    [parameter(Mandatory=$True,Position=0)]
    [System.IO.DirectoryInfo]$path
)

if (-not (Test-Path $path)) {
    Write-Error "パスは存在しません"
    exit 1
}

function Export-DirectoryReport {
    param(
        [System.IO.DirectoryInfo]$dir
    )

    $files = Get-ChildItem -Path $dir.FullName -Filter *.mp4

    if ($files.Count -eq 0) {
        return
    }

    $outFile = Join-Path $dir.FullName "ファイル合計.txt"

    if (Test-Path $outFile) {
        Remove-Item $outFile
    }

    $totalSize = 0

    foreach ($file in $files) {
        
        $bytes = $file.Length
        $totalSize += $bytes

        $sizeGB = $bytes / 1GB
        $sizeMB = $bytes / 1MB

        if ($sizeGB -lt 1) {
            $displaySize = ("{0:N0} MB" -f $sizeMB)
        } else {
            $displaySize = ("{0:N2} GB" -f $sizeGB)
        }

        $line1 = $file.FullName
        $line2 = "サイズ: $displaySize"

        Add-Content -Path $outFile -Value $line1
        Add-Content -Path $outFile -Value $line2
    }

    $totalSizeGB = $totalSize / 1GB
    $totalSizeMB = $totalSize / 1MB

    if ($totalSizeGB -lt 1) {
        $totalDisplay = ("{0:N0} MB" -f $totalSizeMB)
    } else {
        $totalDisplay = ("{0:N2} GB" -f $totalSizeGB)
    }

    Add-Content -Path $outFile -Value "合計サイズ: $totalDisplay"

    Write-Host "処理完了: $($dir.FullName)"
}

function Invoke-DirectoryTraversal {
    param(
        [System.IO.DirectoryInfo]$dir
    )

    Export-DirectoryReport -dir $dir

    $subDirs = Get-ChildItem -Path $dir.FullName -Directory

    foreach ($subDir in $subDirs) {
        Invoke-DirectoryTraversal -dir $subDir
    }
}

Invoke-DirectoryTraversal -dir $path