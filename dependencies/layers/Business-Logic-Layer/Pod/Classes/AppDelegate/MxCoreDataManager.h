//
// Created by djzhang on 12/12/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

#import "YoutubeConstants.h"


@interface MxCoreDataManager : NSObject

+ (void)saveWatchedVideoInfo:(YTYouTubeVideoCache *)videoInfo;
@end