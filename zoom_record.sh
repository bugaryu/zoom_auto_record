#!/bin/bash

# Zoomミーティングに参加するためのURL（例）
ZOOM_URL="https://us06web.zoom.us/j/[zoom_url]"

# 録画を開始する時間（24時間表記、hh:MM:ss、例: 15:00）
START_TIME=$1

# 録画時間（秒数で指定、例: 1時間）
# DURATION=3600
# 3時間1分
DURATION=$((3600 * 3 + 60 * 1))
# テスト用
# DURATION=$((10))

# 録画開始までの待機時間計算
CURRENT_TIME=$(date +%H:%M)
SECONDS_UNTIL_START=$(($(date -jf %H:%M "$START_TIME" +%s) - $(date -jf %H:%M "$CURRENT_TIME" +%s)))

# 録画ファイルの保存場所とファイル名
OUT_FILE_NAME="zoom_recording_$(date +%Y%m%d_%H%M%S).mp4"
OUT_FILE_PATH="$HOME/Downloads/"
OUTPUT_FILE="${OUT_FILE_PATH}${OUT_FILE_NAME}"

echo "----------------------------------------------------"
echo "ZOOM_URL              :" $ZOOM_URL
echo "START_TIME            :" $START_TIME
echo "DURATION              :" $DURATION
echo "CURRENT_TIME          :" $CURRENT_TIME
echo "SECONDS_UNTIL_START   :" $SECONDS_UNTIL_START
echo "OUTPUT_FILE_PATH      :" $OUT_FILE_PATH
echo "----------------------------------------------------"
echo "Wait...until" $START_TIME

# 録画開始時間の3分前まで待機
STANDBY=$((60 * 3))
# STANDBY=$((5))
sleep $(( $SECONDS_UNTIL_START - $STANDBY ))

# Zoomミーティングに参加する
open "$ZOOM_URL"

# 録画開始時間まで待機
sleep $STANDBY

echo "Start recording..."

# 画面録画開始
# ffmpegの場合
# ffmpeg -video_size 1024x768 -framerate 30 -f avfoundation -i "1" -t $DURATION "$OUTPUT_FILE"

# screencaptureの場合
# screencapture -V $DURATION -J "video" -G "BGMDevice" "$OUTPUT_FILE"

# デフォルト設定のスクリーンキャプチャ
# screencapture -V $DURATION -J "video" -p

# 指定時間待機
# 録画停止のためのキー入力（ここでは 'q' を使用）
sleep $DURATION && osascript -e 'tell application "Terminal" to activate' &&
sleep 1 && osascript -e 'tell application "System Events" to keystroke "q"' &

screencapture -J "video" -G "BGMDevice" "$OUTPUT_FILE" 2>/dev/null

echo "Finish recording...saved on " $OUTPUT_FILE
