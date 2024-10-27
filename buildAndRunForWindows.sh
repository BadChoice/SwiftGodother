#!/bin/sh

cd TMRSwift
swift build \
&& cd .. \
&& cp ./TMRSwift/.build/x86_64-unknown-windows-msvc/debug/*.dll ./godot/bin/x86_64-windows \
&& ~/Downloads/Downloads/Godot_v4.2.2-stable_win64.exe --path ./godot
