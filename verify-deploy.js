const fs = require('fs');
const path = require('path');

const requiredFiles = [
    // Root files
    'index.html',
    'v0.html',
    'v1.html',
    'v2.html',
    'death1.mp3',
    'NEWSONG.txt',
    'README.md',
    
    // Assets
    'assets/css/style.css',
    'assets/js/main.js',
    'assets/images/favicon.ico',
    
    // Folk version
    'folk/version1.mp3',
    'folk/version2.mp3',
    'folk/NEWSONG.txt',
    'folk/NEWSONG2.txt',
    
    // Indie version
    'indie/reggae.mp3',
    'indie/chill.mp3',
    'indie/slow.mp3',
    'indie/bass.mp3',
    'indie/reggae.txt',
    'indie/chill.txt',
    'indie/slow.txt',
    'indie/bass.txt',
    
    // GWAR version
    'gwarenergetic/battle.mp3',
    'gwarenergetic/war.mp3',
    'gwarenergetic/chaos.mp3',
    'gwarenergetic/battle.txt',
    'gwarenergetic/war.txt',
    'gwarenergetic/chaos.txt',
    'gwarenergetic/prompt.txt'
];

const checkFiles = (baseDir) => {
    const missing = [];
    
    requiredFiles.forEach(file => {
        const fullPath = path.join(baseDir, file);
        if (!fs.existsSync(fullPath)) {
            missing.push(file);
        }
    });
    
    return missing;
};

const missingFiles = checkFiles('./dist');

if (missingFiles.length > 0) {
    console.error('Missing files:');
    missingFiles.forEach(file => console.error(`- ${file}`));
    process.exit(1);
} else {
    console.log('All required files present!');
} 