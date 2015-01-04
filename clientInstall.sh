#!/bin/bash

#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/dependencies/layers/Business-Logic-Layer/AppResource

appPath=`pwd`;

AppResource="${appPath}/dependencies/layers/Business-Logic-Layer/AppResource"

echo "the current working directory is:${appPath}"

echo "AppCode path is:${_AppCode_app}"

echo "AppCode path is:${AppResource}"

_cleanup() {
    rm -rf ${appPath}/OnlineVideoClient
    unzip  ${appPath}/OnlineVideoClient.zip

    cp ${AppResource}/Podfile          ${appPath}/OnlineVideoClient
    cp ${AppResource}/Main.storyboard  ${appPath}/OnlineVideoClient/OnlineVideoClient/Base.lproj
}

_cocoapodsInstall() {
    cd OnlineVideoClient
    pod install  --verbose  --no-repo-update
}

_runProject(){
     open -a ${_AppCode_app} ${appPath}/OnlineVideoClient/OnlineVideoClient.xcworkspace
}

#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/mxAsTubeiPad/mxAsTubeiPad.xcworkspace
#/Volumes/Home/Developing/SketchProjects/YoutubeiPadClient/mxAsTubeiPad/mxAsTubeiPad.xcworkspace

_cleanup
_cocoapodsInstall
_runProject