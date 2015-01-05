//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

static NSString * const subtitleTempName = @"temp.srt";


@interface Online_Request : AFHTTPSessionManager
+ (void)downloadSqliteFile:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock;

+ (void)fetchingSubtitle:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock;
@end