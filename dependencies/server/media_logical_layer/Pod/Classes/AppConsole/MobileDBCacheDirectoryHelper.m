//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileDBCacheDirectoryHelper.h"
#import "MobileDB.h"
#import "UserCacheFolderHelper.h"
#import "ABProjectType.h"
#import "ABProjectName.h"
#import "ABProjectList.h"


@implementation MobileDBCacheDirectoryHelper {

}

+ (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath {
   [[self getServerConsoleDBInstance]
    saveForOnlineVideoTypeDictionary:dictionary
                            withName:onlineTypeName
            whithOnlineVideoTypePath:onlineVideoTypePath
   ];
}


+ (MobileDB *)getServerConsoleDBInstance {
   return [MobileDB dbInstance:[UserCacheFolderHelper RealProjectCacheDirectory]];
}


+ (BOOL)checkFileInfoExist:(NSString *)fileAbstractPath {
   if ([MobileBaseDatabase checkDBFileExist:[UserCacheFolderHelper getSqliteFilePath]] == NO)
      return NO;

   return [[self getServerConsoleDBInstance] checkFileInfoExist:fileAbstractPath];
}


#pragma mark -
#pragma mark check sqliteobject exist in sqlite database.


+ (ABProjectType *)checkExistForProjectTypeWithProjectTypeName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   return [[self getServerConsoleDBInstance] checkExistForProjectTypeWithProjectTypeName:sqliteObjectName
                                                                         projectFullPath:projectFullPath];
}


+ (ABProjectName *)checkExistForProjectNameWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   return [[self getServerConsoleDBInstance] checkExistForProjectNameWithProjectName:sqliteObjectName
                                                                     projectFullPath:projectFullPath];
}


+ (void)getFileInfoArrayForProjectList:(ABProjectList *)projectList {
   [[self getServerConsoleDBInstance] getFileInfoArrayForProjectList:projectList];
}

@end