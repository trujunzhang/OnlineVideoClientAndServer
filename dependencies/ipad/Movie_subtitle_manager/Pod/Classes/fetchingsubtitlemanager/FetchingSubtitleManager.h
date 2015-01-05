//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYoutubeHelper.h"


@interface FetchingSubtitleManager : NSObject


+ (void)fetchSubtitleForVideoUrl:(NSString *)thumbnails subtitleResponseBlock:(SubtitleResponseBlock)subtitleResponseBlock;
+ (NSString *)convertVideoUrlToSubtitleUrl:(NSString *)url;
@end