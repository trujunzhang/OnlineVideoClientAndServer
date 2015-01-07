//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserCacheFolderHelper : NSObject

+ (NSString *)RealProjectServerDirectory;
+ (NSString *)RealVideoTrainingDBAbstractPath;
+ (NSString *)RealProjectCacheDirectory;
+ (NSString *)getSqliteFilePath;
+ (BOOL)cleanupCache:(NSString *)cacheDirectory;
+ (void)checkUserProjectDirectoryExistAndMake;
+ (BOOL)cleanupCache;
+ (void)removeFileForVideoTrainingDB;
@end