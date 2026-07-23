const fs = require('fs');
const path = require('path');

const baseDir = __dirname;
const srcDir = path.join(baseDir, 'package', 'prebuilds');
const destDir = path.join(baseDir, '..', 'native-metrics-v13.1.0', 'prebuilds');

// Ensure destination directory exists
fs.mkdirSync(destDir, { recursive: true });

// Walk srcDir and move all files to destDir, renaming .node files
function movePrebuilds(src, dest) {
  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      fs.mkdirSync(destPath, { recursive: true });
      movePrebuilds(srcPath, destPath);
    } else {
      let finalDestPath = destPath;
      if (entry.name.endsWith('.node')) {
        // Replace @newrelic+native-metrics with @ohos-npm-ports+native-metrics
        const newName = entry.name.replace('@newrelic+native-metrics', '@ohos-npm-ports+native-metrics');
        finalDestPath = path.join(dest, newName);
        console.log(`Renaming: ${entry.name} -> ${newName}`);
      }
      fs.renameSync(srcPath, finalDestPath);
    }
  }
}

movePrebuilds(srcDir, destDir);
console.log('Done moving prebuilds.');
