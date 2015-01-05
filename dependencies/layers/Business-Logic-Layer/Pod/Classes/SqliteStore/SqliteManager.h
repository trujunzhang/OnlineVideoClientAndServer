//
// Created by djzhang on 12/27/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SqliteManager : NSObject

+ (void)saveSqliteFileAfterFetchingFromServer;


+ (SqliteManager *)sharedSqliteManager;
- (NSArray *)getCurrentOnlineVideoDictionary:(NSInteger)selectedIndex;
+ (NSString *)getCurrentOnlineVideoTypePath:(NSInteger)index;
- (NSMutableDictionary *)getOnlineVideoDictionary;

- (NSArray *)getProjectTypeArray;

- (NSMutableArray *)getOnlineVideoTypesArray;
- (void)resetOnlineVideoDictionary;

- (NSMutableArray *)getProjectListArray:(NSString *)projectNameId projectFullPath:(NSString *)projectFullPath;
- (NSMutableArray *)getAllFileInfoListFromProjectList:(NSMutableArray *)projectLists;
- (NSMutableArray *)getProgressionProjectList:(NSMutableArray *)projectLists;
- (void)sortForFileInfoArrayIn:(id)projectList;
@end