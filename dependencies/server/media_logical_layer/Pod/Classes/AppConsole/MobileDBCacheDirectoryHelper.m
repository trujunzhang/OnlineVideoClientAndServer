//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileDBCacheDirectoryHelper.h"
#import "MobileDB.h"
#import "UserCacheFolderHelper.h"
#import "ABProjectType.h"


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


+ (ABProjectType *)checkExistForProjectTypeWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   return [[self getServerConsoleDBInstance] checkExistForProjectTypeWithProjectName:sqliteObjectName
                                                                     projectFullPath:projectFullPath];


}
@end