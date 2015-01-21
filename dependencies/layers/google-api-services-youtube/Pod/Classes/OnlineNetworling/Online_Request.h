//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const subtitleTempName = @"temp.srt";

typedef void (^RemoteSqliteResponseBlock)(NSString *localPath, NSError *error);

@interface Online_Request : NSObject
+ (void)downloadSqliteFile:(NSString *)remoteSqliteUrl downloadCompletionBlock:(RemoteSqliteResponseBlock)downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock downloadFileName:(NSString *)downloadFileName;

+ (NSString *)getDownloadCachePath;

+ (void)fetchingSubtitle:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock;
@end