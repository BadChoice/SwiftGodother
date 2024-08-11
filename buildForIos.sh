#!/bin/sh

cd TMRSwift
# xcodebuild -scheme TMRSwift -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 12,OS=16.0' build
xcodebuild -scheme TMRSwift -sdk iphoneos -destination 'generic/platform=iOS' build -derivedDataPath ./.build/ios/
cd ..
cp -R ./TMRSwift/.build/ios/Build/Products/Debug-iphoneos/PackageFrameworks/* ./godot/bin/ios/


