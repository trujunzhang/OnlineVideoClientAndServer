//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MobileDB;


@interface MobileDBCacheDirectoryHelper : NSObject
+ (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath;
+ (MobileDB *)getServerConsoleDBInstance;
+ (BOOL)checkFileInfoExist:(NSString *)path;

+ (ABProjectType *)checkExistForProjectTypeWithProjectName:(NSString *)path projectFullPath:(NSString *)path1;
@end