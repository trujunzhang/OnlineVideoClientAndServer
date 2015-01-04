//
//  VideoDetailViewController.h
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoutubeConstants.h"

@class AsDetailRowVideoDescription;


@interface YTAsVideoDetailViewController : UIViewController

- (instancetype)initWithVideo:(YTYouTubeVideoCache *)video;

@end
