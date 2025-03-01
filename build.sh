#!/bin/bash

# Set Flutter channel and version
FLUTTER_CHANNEL="stable"
FLUTTER_VERSION="3.29.0"

# Construct the Flutter SDK filename
FLUTTER_SDK="flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz"

# Download the Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/${FLUTTER_SDK}

# Extract the Flutter SDK
tar xf ${FLUTTER_SDK}

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify Flutter installation
flutter --version

# Run Flutter web build with environment variables
flutter build web --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY