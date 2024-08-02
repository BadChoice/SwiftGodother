#!/bin/sh

cd TMRSwift
# xcodebuild -scheme TMRSwift -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 12,OS=16.0' build
xcodebuild -scheme TMRSwift -sdk iphoneos -destination 'generic/platform=iOS' build
cd ..
# TODO: Find the .xcframeworks automatically
cp -R /Users/jordipuigdellivol/Library/Developer/Xcode/DerivedData/TMRSwift-czzbxvfbnjtqlidblkgveglrrhul/Build/Products/Debug-iphoneos/PackageFrameworks/* ./godot/bin/ios


