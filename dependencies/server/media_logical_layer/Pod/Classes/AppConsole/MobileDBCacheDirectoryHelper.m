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
    [[self getMobileDBInstance]
            saveForOnlineVideoTypeDictionary:dictionary
                                    withName:onlineTypeName
                    whithOnlineVideoTypePath:onlineVideoTypePath
    ];
}


+ (MobileDB *)getMobileDBInstance {
    return [MobileDB dbInstance:[UserCacheFolderHelper RealProjectServerDirectory]];
}


+ (BOOL)checkExistForFileInfoWithAbstractPath:(NSString *)fileAbstractPath {
    if([MobileBaseDatabase checkDBFileExist:[UserCacheFolderHelper getSqliteFilePath]] == NO)
        return NO;

    return [[self getMobileDBInstance] checkFileInfoExist:fileAbstractPath];
}


#pragma mark -
#pragma mark check sqliteobject exist in sqlite database.


+ (ABProjectType *)checkExistForProjectTypeWithProjectTypeName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
    return [[self getMobileDBInstance] checkExistForProjectTypeWithProjectTypeName:sqliteObjectName
                                                                   projectFullPath:projectFullPath];
}


+ (ABProjectName *)checkExistForProjectNameWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
    return [[self getMobileDBInstance] checkExistForProjectNameWithProjectName:sqliteObjectName
                                                               projectFullPath:projectFullPath];
}


+ (void)getFileInfoArrayForProjectList:(ABProjectList *)projectList {
    [[self getMobileDBInstance] getFileInfoArrayForProjectList:projectList];
}

@end