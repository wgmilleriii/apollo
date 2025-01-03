#!/bin/bash

# Load configuration
source deploy.config

# Create necessary directories
mkdir -p dist/assets/{css,js,images}
mkdir -p dist/{folk,indie,gwarenergetic}

# Copy root files
cp index.html v*.html death1.mp3 NEWSONG.txt README.md prompt_history.txt prompts.txt dist/

# Copy asset files
cp assets/css/style.css dist/assets/css/
cp assets/js/main.js dist/assets/js/
cp assets/images/favicon.ico dist/assets/images/

# Copy folk version files
cp folk/*.{mp3,txt} dist/folk/

# Copy indie version files
cp indie/*.{mp3,txt} dist/indie/

# Copy gwarenergetic version files
cp gwarenergetic/*.{mp3,txt} dist/gwarenergetic/

# Verify local deployment
echo "Verifying local deployment..."
find dist -type f

# Create zip archive (backup)
zip -r apollo-site.zip dist/*

# Upload via FTP
echo "Uploading to FTP server..."
cd dist
find . -type f -exec curl -u "$FTP_USER:$FTP_PASS" --ftp-create-dirs -T {} ftp://$FTP_HOST$FTP_DIR/{} \;

echo "Deployment complete!" 