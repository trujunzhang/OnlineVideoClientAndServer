#!/bin/bash

logFile='deploy.txt'

appName='onlineServerConsole'
appPath='OnlineVideoManagerClient/OnlineVideoServerConsole'

profileDir="/Volumes/Home/djzhang/Desktop/$appName"
projectPath="$profileDir/$appPath"
projectFile="$projectPath/OnlineVideoServerConsole.xcworkspace"

echo " *** profileDir is $profileDir"     >> "$logFile"
echo " *** projectDir is $projectPath"    >> "$logFile"
echo " *** projectFile is $projectFile"   >> "$logFile"

function initBuilder(){
	rm -rf "$profileDir"   >> "$logFile"
	mkdir "$profileDir"    >> "$logFile"
}

function cloneFromGithub(){
	parentFold=`pwd`;
	echo " * cloneFromGithub path is $parentFold"   >> "$logFile"

	git clone https://github.com/wanghaogithub720/OnlineVideoManagerClient   >> "$logFile"
}


function cocoapodForServerConsole(){
	parentFold=`pwd`;
	echo " * cocoapodForServerConsole path is $parentFold"   >> "$logFile"

    pod install  --verbose  --no-repo-update   >> "$logFile"
}

function openProjectByDefaultApp(){
    open -a Xcode ${projectFile}
}

(initBuilder; cd "$profileDir" ;cloneFromGithub; cd "$projectPath"; cocoapodForServerConsole; openProjectByDefaultApp)