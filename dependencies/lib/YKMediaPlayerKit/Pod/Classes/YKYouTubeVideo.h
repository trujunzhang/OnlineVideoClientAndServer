//
//  YKYouTubeVideo.h
//  YKMediaHelper
//
//  Created by Yas Kuraishi on 3/13/14.
//  Copyright (c) 2014 Yas Kuraishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKVideo.h"

@interface YKYouTubeVideo : NSObject<YKVideo>

/**
Vimeo detailVideo url
*/
@property (nonatomic, strong) NSURL *contentURL;

/**
Videos found for above mentioned content url.
Available after parseWithCompletion is executed.
*/
@property (nonatomic, strong) NSDictionary *videos;


@property (nonatomic, strong) NSURL *onlineVideoPlayUrl;

- (instancetype)initWithVideoId:(NSString *)videoId;

- (instancetype)initWithOnlineVideoPlayUrl:(NSURL *)onlineVideoPlayUrl;

- (void)playInView:(UIView *)pView withQualityOptions:(YKQualityOptions)quality;

- (void)stop;

@end
