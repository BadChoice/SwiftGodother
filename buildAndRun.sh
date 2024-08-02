#!/bin/sh
cd TMRSwift
swift build
cd ..
cp ./TMRSwift/.build/$(uname -m)-apple-macosx/debug/*.dylib ./godot/bin/macos/$(uname -m)-apple-macosx
~/Downloads/Godot.app/Contents/MacOS/Godot --path ./godot


# Build library for iOS
# xcodebuild -scheme TMRSwift -destination 'platform=iOS,OS=16.0,name=iPhone 11 Pro'
# swift build --configuration debug --destination destination.json