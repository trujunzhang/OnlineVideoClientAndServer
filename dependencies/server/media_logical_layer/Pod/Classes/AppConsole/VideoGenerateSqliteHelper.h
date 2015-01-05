//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemoryDBHelper;


@interface VideoGenerateSqliteHelper : NSObject


+ (void)generateSqliteFromSourceWithTypeName:(NSString *)name withLocalPath:(NSString *)path withScanFolder:(NSString *)folder saveSqlitTo:(NSString *)to;
+ (void)generateSqliteAndThumbnail;
@end