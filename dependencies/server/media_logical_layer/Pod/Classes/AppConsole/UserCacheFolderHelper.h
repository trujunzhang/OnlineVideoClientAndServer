//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserCacheFolderHelper : NSObject

+ (NSString *)RealProjectCacheDirectory;
+ (BOOL)cleanupCache:(NSString *)cacheDirectory;
+ (BOOL)checkUserCacheFolderExistAndMake;
+ (BOOL)cleanupCache;
@end