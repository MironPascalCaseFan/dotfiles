#!/usr/bin/env bash

set -e
trap 'echo "ERROR at line $LINENO"; exit 1' ERR

AUTHOR_NAME="Family"
CAMERA_MAKE="Canon"

# ===== Ctrl+C cleanup =====
cleanup() {
    if [[ -n "$abs_dst" && -f "$abs_dst" ]]; then
        echo "Interrupted! Removing incomplete file: $abs_dst"
        rm -f "$abs_dst"
    fi
    exit 1
}
trap cleanup SIGINT SIGTERM

# ===== Gather files (sorted, deterministic) =====
mapfile -t files < <(find . -type f -iname "*.mts" | sort)
total=${#files[@]}
count=0

echo "Found $total .mts files"
echo

for src in "${files[@]}"; do
    echo "Progress: [$((count + 1))/$total]"

    abs_src=$(realpath "$src")
    abs_dst=$(realpath --canonicalize-missing "${src%.*}.mp4")

    # Skip if final MP4 exists
    if [[ -f "$abs_dst" ]]; then
        ((++count))
        echo "Skipping: $abs_dst"
        echo
        continue
    fi

    src_size_mb=$(du -m "$abs_src" | cut -f1)
    echo "Source: $abs_src"
    echo "Size:   ${src_size_mb} MB"

    # ===== FFmpeg (errors only) =====
    ffmpeg -hide_banner -loglevel error -y \
        -i "$abs_src" \
        -map 0:v:0 -map 0:a? \
        -c:v libx264 -crf 21 -preset medium -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        -movflags +faststart \
        "$abs_dst"

    # ===== ExifTool pass 1: Movie-level metadata =====
    set +e
    exiftool -tagsFromFile "$abs_src" -ee3 -api QuickTimeUTC -api RequestAll=3 -n -m -P \
        "-QuickTime:CreateDate<DateTimeOriginal" \
        "-QuickTime:ModifyDate<DateTimeOriginal" \
        "-Keys:Author=$AUTHOR_NAME" "-Keys:Artist=$AUTHOR_NAME" \
        "-Keys:Make=$CAMERA_MAKE" "-UserData:Make=$CAMERA_MAKE" \
        "-Keys:Model<Model" \
        "-XMP:FNumber<FNumber" "-XMP:ExposureTime<ExposureTime" \
        "-XMP:ShutterSpeedValue<ShutterSpeed" "-XMP:WhiteBalance<WhiteBalance" \
        -overwrite_original "$abs_dst"
    et_code=$?
    set -e

    if [[ $et_code -gt 1 ]]; then
        echo "ExifTool failed (pass 1), exit code $et_code"
        exit $et_code
    fi

    # ===== ExifTool pass 2: Track / Media dates =====
    set +e
    exiftool -api QuickTimeUTC -m -P \
        "-TrackCreateDate<CreateDate" \
        "-TrackModifyDate<ModifyDate" \
        "-MediaCreateDate<CreateDate" \
        "-MediaModifyDate<ModifyDate" \
        -overwrite_original "$abs_dst"
    et_code=$?
    set -e

    if [[ $et_code -gt 1 ]]; then
        echo "ExifTool failed (pass 2), exit code $et_code"
        exit $et_code
    fi

    dst_size_mb=$(du -m "$abs_dst" | cut -f1)
    echo "Result: $abs_dst"
    echo "Size:   ${dst_size_mb} MB"

    ((++count))
    echo
done

echo "Done. Processed $count files out of $total."
