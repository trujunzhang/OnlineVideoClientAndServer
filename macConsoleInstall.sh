#!/bin/bash

#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/dependencies/layers/Business-Logic-Layer/AppResource

appPath=`pwd`;

AppResource="${appPath}/dependencies/server/media_logical_layer/AppResource"

echo "the current working directory is:${appPath}"

echo "AppCode path is:${_AppCode_app}"

echo "AppCode path is:${AppResource}"

_cleanup() {
    rm -rf ${appPath}/OnlineVideoClientConsole
    unzip  ${appPath}/OnlineVideoClientConsole.zip

    cp ${AppResource}/Podfile          ${appPath}/OnlineVideoClientConsole
    cp ${AppResource}/main.m  ${appPath}/OnlineVideoClientConsole/OnlineVideoClientConsole
}

_cocoapodsInstall() {
    cd OnlineVideoClientConsole
    pod install  --verbose  --no-repo-update
}

_runProject(){
     open -a ${_AppCode_app} ${appPath}/OnlineVideoClientConsole/OnlineVideoClientConsole.xcworkspace
}

#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/mxAsTubeiPad/mxAsTubeiPad.xcworkspace
#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/mxAsTubeiPad/mxAsTubeiPad.xcworkspace

(_cleanup;_cocoapodsInstall;_runProject)

