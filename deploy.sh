#!/bin/bash

# Configuration
FTP_HOST="hesadoghesacow.com"
FTP_USER="apollo1@hesadoghesacow.com"
FTP_PASS='^a=lY%TLk?Ie'
TARGET_PATH="/home/chipmillerme/public_html/hesadoghesacow.com"

echo "Starting deployment..."

# Function to upload a file
upload_file() {
    local local_file=$1
    local remote_file=$2
    if [ -f "$local_file" ]; then
        echo "Uploading $local_file..."
        curl -k -T "$local_file" "ftp://$FTP_HOST$remote_file" \
            --user "$FTP_USER:$FTP_PASS" \
            --ftp-create-dirs
    else
        echo "Warning: $local_file not found"
    fi
}

# Upload HTML files
upload_file "index.html" "$TARGET_PATH/index.html"
upload_file "v0.html" "$TARGET_PATH/v0.html"
upload_file "v1.html" "$TARGET_PATH/v1.html"
upload_file "v2.html" "$TARGET_PATH/v2.html"

# Upload assets
upload_file "assets/css/style.css" "$TARGET_PATH/assets/css/style.css"
upload_file "assets/js/main.js" "$TARGET_PATH/assets/js/main.js"

# Upload audio files
upload_file "death1.mp3" "$TARGET_PATH/death1.mp3"

# Upload folk versions
upload_file "folk/version1.mp3" "$TARGET_PATH/folk/version1.mp3"
upload_file "folk/version2.mp3" "$TARGET_PATH/folk/version2.mp3"
upload_file "folk/version1.mp4" "$TARGET_PATH/folk/version1.mp4"
upload_file "folk/version2.mp4" "$TARGET_PATH/folk/version2.mp4"

# Upload indie versions
upload_file "indie/reggae.mp3" "$TARGET_PATH/indie/reggae.mp3"
upload_file "indie/chill.mp3" "$TARGET_PATH/indie/chill.mp3"
upload_file "indie/slow.mp3" "$TARGET_PATH/indie/slow.mp3"
upload_file "indie/bass.mp3" "$TARGET_PATH/indie/bass.mp3"
upload_file "indie/reggae.mp4" "$TARGET_PATH/indie/reggae.mp4"
upload_file "indie/chill.mp4" "$TARGET_PATH/indie/chill.mp4"
upload_file "indie/slow.mp4" "$TARGET_PATH/indie/slow.mp4"
upload_file "indie/bass.mp4" "$TARGET_PATH/indie/bass.mp4"

# Upload GWAR versions
upload_file "gwarenergetic/battle.mp3" "$TARGET_PATH/gwarenergetic/battle.mp3"
upload_file "gwarenergetic/war.mp3" "$TARGET_PATH/gwarenergetic/war.mp3"
upload_file "gwarenergetic/chaos.mp3" "$TARGET_PATH/gwarenergetic/chaos.mp3"
upload_file "gwarenergetic/battle.mp4" "$TARGET_PATH/gwarenergetic/battle.mp4"
upload_file "gwarenergetic/war.mp4" "$TARGET_PATH/gwarenergetic/war.mp4"
upload_file "gwarenergetic/chaos.mp4" "$TARGET_PATH/gwarenergetic/chaos.mp4"
upload_file "gwarenergetic/prompt.txt" "$TARGET_PATH/gwarenergetic/prompt.txt"

echo "Deployment completed!" 