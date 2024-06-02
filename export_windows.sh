#!/bin/bash

export version=`git describe --tags --abbrev=0`
echo $version
godot --export-release "windows" "E:\OneDrive\dev\game dev\build\Knight Survivor ${version}.exe"
