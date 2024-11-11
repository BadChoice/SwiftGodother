#!/bin/sh


#~/Downloads/Godot.app/Contents/MacOS/Godot --import --path ./godot

cd TMRSwift
swift build \
&& cd .. \
&& cp ./TMRSwift/.build/$(uname -m)-apple-macosx/debug/*.dylib ./godot/bin/$(uname -m)-apple-macosx \
&& ~/Downloads/Godot.app/Contents/MacOS/Godot --path ./godot
