#!/bin/bash

# Exit on error
set -e

echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl unzip xz-utils zip libglu1-mesa wget

# Set Flutter channel and version
FLUTTER_CHANNEL="stable"
FLUTTER_VERSION="3.29.0"

# Construct the Flutter SDK filename
FLUTTER_SDK="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"

echo "Downloading Flutter SDK..."
# Download the Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${FLUTTER_SDK}

echo "Extracting Flutter SDK..."
# Extract the Flutter SDK
tar xf ${FLUTTER_SDK}

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

echo "Verifying Flutter installation..."
# Verify Flutter installation
flutter --version

echo "Configuring Flutter..."
flutter config --no-analytics
flutter doctor -v

echo "Getting dependencies..."
flutter pub get

echo "Building web app..."
# Run Flutter web build
flutter build web

echo "Build completed!" 