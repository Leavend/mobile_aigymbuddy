#!/bin/bash
set -euo pipefail

echo "Building for Web with Skia renderer and HTML output..."
flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true --web-renderer html