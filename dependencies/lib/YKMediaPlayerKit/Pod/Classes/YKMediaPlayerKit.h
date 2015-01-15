//
//  YKMediaHelper.h
//  YKMediaHelper
//
//  Created by Yas Kuraishi on 3/8/14.
//  Copyright (c) 2014 Yas Kuraishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "YKVideo.h"
#import "YKYouTubeVideo.h"
#import "YKVimeoVideo.h"
#import "YKDirectVideo.h"
#import "YKUnKnownVideo.h"

typedef NS_ENUM(NSUInteger, YKVideoTypeOptions) {
    YKVideoTypeYouTube,
    YKVideoTypeVimeo,
    YKVideoTypeDirect,
    YKVideoTypeUnknown
};

@interface YKMediaPlayerKit : NSObject

@property (nonatomic) YKQualityOptions videoQuality;
@property (nonatomic) YKQualityOptions thumbQuality;
@property (nonatomic, strong) NSURL *contentURL;


#pragma mark - Instance Methods

/**
Initializer that takes YouTube/Vimeo/MP4/MOV detailVideo URL
*/
- (instancetype)initWithURL:(NSURL *)contentURL;

/**
Loads detailVideo info and parses direct urls to detailVideo and thumbnail images
*/
- (void)parseWithCompletion:(void (^)(YKVideoTypeOptions videoType, id<YKVideo> video, NSError *error))callback;

/**
Loads detailVideo info and plays it in modal play view controller
*/
- (void)playWithCompletion:(void (^)(YKVideoTypeOptions videoType, id<YKVideo> video, NSError *error))callback;

/**
Loads detailVideo thumbnail
*/
- (void)thumbWithCompletion:(void (^)(UIImage *thumb, NSError *error))callback;


#pragma mark - Class Methods

/**
Loads detailVideo info and parses direct urls to detailVideo and thumbnail images
*/
+ (void)parse:(NSURL *)contentURL completion:(void (^)(YKVideoTypeOptions, id<YKVideo>, NSError *))callback;

/**
Loads detailVideo info and plays it in modal play view controller
*/
+ (void)play:(NSURL *)contentURL quality:(YKQualityOptions)quality completion:(void (^)(YKVideoTypeOptions, id<YKVideo>, NSError *))callback;

/**
Loads detailVideo thumbnail
*/
+ (void)thumb:(NSURL *)contentURL quality:(YKQualityOptions)quality completion:(void (^)(UIImage *thumb, NSError *))callback;


@end
