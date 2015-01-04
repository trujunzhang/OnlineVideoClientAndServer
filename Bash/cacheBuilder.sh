#!/bin/bash

function generateThumbnail(){
   sourceFile="$dir$@"
   destinationFile="$thumbanilDir$@.jpg"

#   echo $sourceFile
#   echo $destinationFile

#1280*720
#   ffmpeg -i "/Volumes/macshare/MacPE/Lynda.com/wh/01-Welcome.mp4" -deinterlace -an -ss 1 -t 00:00:01 -r 1 -y -vcodec mjpeg -f mjpeg "/Volumes/macshare/MacPE/Lynda.com/wh/wanghao-thumbnail.png"
# used
#    ffmpeg -i "$sourceFile" -deinterlace -an -ss 1 -t 00:00:01 -s 320x180 -r 1 -y -vcodec mjpeg -f mjpeg "$destinationFile"
}

function tabs()
{
	local result=''
	for i in `seq 1 $1`; do
		result="--$result"
	done
#	echo $result
}

traverse()
{
	line=`tabs $1`
#	echo "$dir"

	parentFold=`pwd`;
#	echo "$parentFold"

	for file in *; do
		if [ -d "$file" ]; then
#		    echo "$line$parentFold/$file"
		    foldPath="$parentFold/$file"
#   			echo "$line$foldPath"
            abstractFoldPath="${foldPath/$dir/}"
            #used
#            echo "$line$abstractFoldPath"
#            echo "$line$abstractFoldPath"  >> "$cacheFile"

            thunmbailFold="$thumbanilDir$abstractFoldPath"
            echo $thunmbailFold
            mkdir "$thunmbailFold"

			(cd "$file"; traverse $((1+$1)))
		elif [ -e "$file" ]; then
#			echo "--$line$parentFold/$file"
		    filePath="$parentFold/$file"
#            echo "$line$filePath"
            abstractFilePath="${filePath/$dir/}"
            #used
#            echo "$line$abstractFilePath"
#            echo "$line$abstractFilePath"  >> "$cacheFile"

			if [ "${abstractFilePath##*.}" = "mp4" ]; then
			  generateThumbnail $abstractFilePath
			fi
			if [ "${abstractFilePath##*.}" = "mov" ]; then
			  generateThumbnail $abstractFilePath
			fi

		fi
	done
}

profileDir='/Volumes/Home/djzhang/.AOnlineTutorial'
movieDir='/Volumes/macshare/MacPE/Lynda.com'


cacheDir="$profileDir/.cache"
thumbanilDir="$cacheDir/thumbnail"
cacheFile="$cacheDir/list.txt"
#echo "$cacheDir"

function initBuilder(){
	mkdir "$profileDir"
	mkdir "$cacheDir"

	rm "$cacheFile"

	mkdir "$thumbanilDir"
}


(initBuilder ; cd "$movieDir";  traverse 0 )