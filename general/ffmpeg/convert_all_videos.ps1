# Convert every .MOV file to .mkv using AV1
# Portrait videos (rotation -90, 90, or 270) → 480x854
# Landscape or unrotated videos → 854x480

$files = Get-ChildItem -Filter *.MOV

foreach ($f in $files) {
    # Get rotation using ffprobe
    $rotation = ffprobe -v error -select_streams v:0 `
        -show_entries stream_side_data=rotation `
        -of default=noprint_wrappers=1:nokey=1 $f.FullName

    # Trim whitespace and convert to integer (default 0 if empty)
    $rotation = ($rotation | Out-String).Trim()
    if (-not $rotation) { $rotation = "0" }
    $rotation = [int]$rotation

    # Choose resolution based on rotation
    if ($rotation -eq 90 -or $rotation -eq -90 -or $rotation -eq 270) {
        $resolution = "480x854"   # portrait
    } else {
        $resolution = "854x480"   # landscape
    }

    $out = [System.IO.Path]::ChangeExtension($f.FullName, ".mkv")
    Write-Host "Converting $($f.Name) (rotation=$rotation) → $resolution → $(Split-Path $out -Leaf)"

    ffmpeg -i $f.FullName -s $resolution -r 10 -c:v libsvtav1 -preset 6 -crf 60 -c:a copy $out
}
