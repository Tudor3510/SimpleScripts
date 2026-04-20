#!/bin/sh

# ===== CONFIG =====
BITRATE="1500k"
# ==================

mkdir -p Output

found=0

for f in ./*.MOV; do
    [ -e "$f" ] || continue
    found=1

    filename=$(basename "$f")
    name="${filename%.*}"
    out="Output/$name.mp4"

    # Get resolution
    resolution=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=width,height \
        -of csv=p=0:s=x \
        "$f")

    # Clean resolution (remove anything unexpected, including trailing 'x')
    resolution=$(printf "%s" "$resolution" | tr -cd '0-9x')
    resolution=$(printf "%s" "$resolution" | sed 's/x$//')

    # Get rotation (default 0)
    rotation=$(ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream_side_data=rotation \
        -of default=nw=1:nk=1 \
        "$f" 2>/dev/null | head -n 1)

    rotation=$(printf "%s" "$rotation" | tr -d '[:space:]')
    [ -n "$rotation" ] || rotation=0

    # Decide output resolution
    case "$resolution" in
        640x480)
            case "$rotation" in
                90|-90|270|-270)
                    out_res="480:640"
                    ;;
                0|180|-180)
                    out_res="640:480"
                    ;;
                *)
                    echo "Skipping $filename (unknown rotation: $rotation)"
                    continue
                    ;;
            esac
            ;;
        1280x720)
            case "$rotation" in
                90|-90|270|-270)
                    out_res="720:1280"
                    ;;
                0|180|-180)
                    out_res="1280:720"
                    ;;
                *)
                    echo "Skipping $filename (unknown rotation: $rotation)"
                    continue
                    ;;
            esac
            ;;
        *)
            echo "Skipping $filename (unsupported resolution: $resolution)"
            continue
            ;;
    esac

    echo "Converting $filename (rot=$rotation, res=$resolution) → $out_res @12fps, bitrate=$BITRATE"

    ffmpeg -i "$f" \
        -vf "scale=$out_res,fps=12" \
        -c:v hevc_videotoolbox \
        -b:v "$BITRATE" \
        -tag:v hvc1 \
        -c:a copy \
        "$out"
done

if [ "$found" -eq 0 ]; then
    echo "No .MOV files found."
fi