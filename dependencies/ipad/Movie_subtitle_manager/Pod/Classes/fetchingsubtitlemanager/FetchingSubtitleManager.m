//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "FetchingSubtitleManager.h"
#import "GYoutubeHelper.h"


@implementation FetchingSubtitleManager {

}

///Volumes/Thunder/SharedThunder/TubeDownload/@Software Tutorials/@@Jetbrains/Webstorm/Node.js Development Workflow in WebStorm.MP4
///Volumes/Thunder/SharedThunder/TubeDownload/@Software Tutorials/@@Jetbrains/Webstorm/Node.js Development Workflow in WebStorm.srt
+ (void)fetchSubtitleForVideoUrl:(NSString *)videoUrl {
   NSString * subtitleUrl = [FetchingSubtitleManager convertVideoUrlToSubtitleUrl:videoUrl];
//   [GYoutubeHelper ]

}


+ (NSString *)convertVideoUrlToSubtitleUrl:(NSString *)url {

   return url;
}
@end