//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MobileDB;
@class ABProjectType;
@class ABProjectName;
@class ABProjectList;


@interface MobileDBCacheDirectoryHelper : NSObject
+ (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath;
+ (MobileDB *)getServerConsoleDBInstance;
+ (BOOL)checkExistForFileInfoWithAbstractPath:(NSString *)path;

+ (ABProjectType *)checkExistForProjectTypeWithProjectTypeName:(NSString *)path projectFullPath:(NSString *)path1;
+ (ABProjectName *)checkExistForProjectNameWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath;
+ (void)getFileInfoArrayForProjectList:(ABProjectList *)projectList;

@end