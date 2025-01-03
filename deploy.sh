#!/bin/bash

# Create necessary directories
mkdir -p dist/assets/{css,js,images}
mkdir -p dist/{folk,indie,gwarenergetic}

# Copy root files
cp index.html v*.html death1.mp3 NEWSONG.txt README.md dist/

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

# Verify deployment
echo "Verifying deployment..."
find dist -type f

# Optional: Create zip archive
zip -r apollo-site.zip dist/*

echo "Deployment package created!" 