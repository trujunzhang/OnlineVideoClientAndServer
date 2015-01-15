//
//  Search.h
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <google-api-services-youtube/GYoutubeHelper.h>


#import "YoutubeConstants.h"
#import "GYoutubeRequestInfo.h"
#import "GYoutubeHelper.h"


@class GYoutubeRequestInfo;
@class OnlineServerInfo;

typedef void (^YoutubeResponseBlock)(NSArray *array, NSObject *respObject);

typedef void (^ErrorResponseBlock)(NSError *error);

typedef void (^SqliteResponseBlock)(NSObject *respObject);

typedef void (^SubtitleResponseBlock)(NSURL *responseString);


@protocol GYoutubeHelperDelegate<NSObject>

@optional
- (void)showStepInfo:(NSString *)string;


@end


@interface GYoutubeHelper : NSObject {

}
// Accessor for the app's single instance of the service object.
@property (nonatomic) BOOL isSignedIn;
@property (nonatomic, strong) OnlineServerInfo *onlineServerInfo;

+ (GYoutubeHelper *)getInstance;

- (NSString *)getCurrentDomainUrl;


- (NSString *)getHtdocs;

- (NSString *)getServerCacheDirectory;

@property (nonatomic, weak) id<GYoutubeHelperDelegate> delegate;

- (void)initOnlineClient:(SqliteResponseBlock)downloadCompletionBlock checkVersion:(BOOL)version;

- (void)fetchingSubtitle:(SubtitleResponseBlock)subtitleResponseBlock withUrl:(NSString *)subtitleUrl;
@end
