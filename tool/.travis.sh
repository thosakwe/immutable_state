#!/usr/bin/env bash
set -e

# Test package:immutable_state
cd immutable_state
pub get
pub run test
cd ..

# Test package:flutter_immutable_state
cd flutter_immutable_state
git clone https://github.com/flutter/flutter.git -b beta --depth 1
FLUTTER_BIN="`pwd`/flutter/bin"
export PATH="$FLUTTER_BIN:$PATH"
flutter doctor
flutter packages get
flutter test
cd ..