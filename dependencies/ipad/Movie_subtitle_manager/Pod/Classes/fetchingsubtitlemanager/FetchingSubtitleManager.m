//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "FetchingSubtitleManager.h"
#import "GYoutubeHelper.h"


@implementation FetchingSubtitleManager {

}

///Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@123/10. Creating Menus in Muse/WebStorm - Node.js Debugging.srt
//http://192.168.1.200:8040/macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@123/10. Creating Menus in Muse/WebStorm - Node.js Debugging.srt
+ (void)fetchSubtitleForVideoUrl:(NSString *)videoUrl {
   videoUrl = @"http://192.168.1.200:8040/macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@123/10. Creating Menus in Muse/WebStorm - Node.js Debugging.srt";
//   videoUrl = @"macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@123/10. Creating Menus in Muse/WebStorm - Node.js Debugging.srt";

   SubtitleResponseBlock subtitleResponseBlock = ^(NSString * responseString) {
       NSString * debug = @"debug";
   };
   [[GYoutubeHelper getInstance] fetchingSubtitle:subtitleResponseBlock withUrl:videoUrl];

}


+ (NSString *)convertVideoUrlToSubtitleUrl:(NSString *)url {

   return url;
}
@end