//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OnlineServerInfo;

typedef void (^ParseHelperResultBlock)(OnlineServerInfo * object, NSError * error);


@interface ParseHelper : NSObject

+ (ParseHelper *)sharedParseHelper;
- (void)saveOnlineVideoInfo:(OnlineServerInfo *)serverInfo;
- (void)readOnlineVideoInfo:(ParseHelperResultBlock)parseHelperResultBlock;

@end