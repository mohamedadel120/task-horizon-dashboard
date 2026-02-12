#!/usr/bin/env bash
# Build Flutter web and deploy to Firebase Hosting.
set -e
cd "$(dirname "$0")/.."
echo "Building Flutter web..."
flutter build web --no-tree-shake-icons
echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting
echo "Done. Open https://task-60403.web.app (or the URL above)."
