//
//  EasySpendLogDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <media_sqlite_manager/MobileDB.h>
#import "MobileDB.h"
#import "ABSQLiteDB.h"
#import "ABProjectFileInfo.h"
#import "ABProjectType.h"
#import "ABOnlineVideoType.h"


static MobileDB * _dbInstance;


@interface MobileDB ()

@end


@implementation MobileDB {

}


#pragma mark - Base


- (id)init {
   return [self initWithFile:NULL];
}


- (id)initWithFile:(NSString *)filePathName {
   if (!(self = [super init])) return nil;

   _dbInstance = self;

   BOOL fileExists = [MobileBaseDatabase checkDBFileExist:filePathName];

   // backupDbPath allows for a pre-made database to be in the app. Good for testing
   NSString * backupDbPath = [[NSBundle mainBundle] pathForResource:@"Mobile" ofType:@"db"];

   BOOL copiedBackupDb = NO;
   if (backupDbPath != nil) {
      copiedBackupDb = [[NSFileManager defaultManager]
       copyItemAtPath:backupDbPath
               toPath:filePathName
                error:nil];
   }

   // open SQLite db file
   db = [[ABSQLiteDB alloc] init];

   if (![db connect:filePathName]) {
      return nil;
   }

   if (!fileExists) {
      if (!backupDbPath || !copiedBackupDb)
         [self makeForMobileDB];
   }

   [self checkSchemaForMobileDB]; // always check schema because updates are done here

   return self;
}


+ (MobileDB *)dbInstance {
   NSString * path = [self getSqliteFolder];

   return [MobileDB dbInstance:path];
}


+ (NSString *)getSqliteFolder {
   NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
   return searchPaths[0];
}


+ (NSString *)getDBFilePathForiOS {
   return [[MobileDB getSqliteFolder] stringByAppendingPathComponent:dataBaseName];
}


+ (MobileDB *)dbInstance:(NSString *)path {
   if (!_dbInstance) {
      NSString * dbFilePath = [path stringByAppendingPathComponent:dataBaseName];
      MobileDB * mobileDB = [[MobileDB alloc] initWithFile:dbFilePath];
   }

   return _dbInstance;
}


- (void)close {
   [db close];
}


#pragma mark -
#pragma mark ABOnlineVideoType


- (void)saveOnlineVideoType:(ABOnlineVideoType *)onlineVideoType {

   NSMutableArray * mutableArray = [self readOnlineVideoTypes:@{
     @"onlineVideoTypeName" : onlineVideoType.sqliteObjectName,
     @"objectFullPath" : onlineVideoType.objectFullPath,
    }
                                                  isReadArray:NO];
   if (mutableArray.count == 1) {
      ABOnlineVideoType * lastOnlineVideoType = mutableArray[0];
      [onlineVideoType updateSqliteObject:lastOnlineVideoType];
   } else {
      NSArray * sqlStringSerializationForInsert = [onlineVideoType sqlStringSerializationForInsert];

      NSString * sql = [NSString stringWithFormat:
       @"insert into OnlineVideoType(onlineVideoTypeID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       onlineVideoType.sqliteObjectID,
       sqlStringSerializationForInsert[1]
      ];
      [db sqlExecute:sql];
   }

   [self saveOnlineVideoTypeProjectTypesArray:onlineVideoType.sqliteObjectID
                               withDictionary:onlineVideoType.onlineTypeDictionary];
}


- (void)saveOnlineVideoTypeProjectTypesArray:(int)onlineVideoTypeID withDictionary:(NSMutableDictionary *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectType * abProjectType in mutableArray.allValues) {
         sql = [NSString stringWithFormat:@"select projectTypeID from OnlineVideoTypeProjectTypes where onlineVideoTypeID = %i and projectTypeID = %i",
                                          onlineVideoTypeID,
                                          abProjectType.sqliteObjectID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into OnlineVideoTypeProjectTypes(onlineVideoTypeID,projectTypeID) values(%i,%i);",
                                             onlineVideoTypeID,
                                             abProjectType.sqliteObjectID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (NSMutableArray *)readOnlineVideoTypes:(NSMutableDictionary *)filterDictionary isReadArray:(BOOL)isReadArray {
   NSMutableArray * onlineVideoTypeArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from OnlineVideoType where %@",
                                               [ABSqliteObject getSqlStringSerializationForFilter:filterDictionary]];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABOnlineVideoType * sqliteObject = [[ABOnlineVideoType alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"onlineVideoTypeID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"onlineVideoTypeName"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [onlineVideoTypeArray addObject:sqliteObject];

      [self readOnlineTypeArray:sqliteObject.sqliteObjectID
                      withArray:sqliteObject.onlineTypeDictionary
                    isReadArray:isReadArray];

      [results moveNext];
   }


   return onlineVideoTypeArray;

}


- (NSMutableArray *)readOnlineVideoTypes {
   return [self readOnlineVideoTypes:[[NSMutableDictionary alloc] init] isReadArray:NO];
}


- (void)readOnlineTypeArray:(int)onlineVideoTypeID withArray:(NSMutableDictionary *)dictionary isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select ProjectTypeID from OnlineVideoTypeProjectTypes where onlineVideoTypeID = '%i'",
                                    onlineVideoTypeID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int ProjectTypeID = [[results fieldWithName:@"ProjectTypeID"] intValue];

      [self readDictionaryForProjectTypeWithProjectTypeId:ProjectTypeID toDictionary:dictionary hasAllList:isReadArray];

//      [self addOnlineVideoInfo:onlineVideoTypeID toProjectTypeDictionary:dictionary];

      [results moveNext];
   }

}


//- (void)addOnlineVideoInfo:(int)onlineVideoTypeID toProjectTypeDictionary:(NSMutableDictionary *)dictionary {
//   for (ABProjectType * projectType in dictionary.allValues) {
//      projectType.onlineVideoTypeID = onlineVideoTypeID;
//   }
//}


#pragma mark - ABProjectType


- (void)saveProjectType:(ABProjectType *)projectType {
   NSString * sql;
   BOOL exists = NO;

   //select projectTypeName from ProjectType where projectTypeName ='@Muse'
   sql = [NSString stringWithFormat:@"select projectTypeName from ProjectType where projectTypeName ='%@'",
                                    projectType.sqliteObjectName];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectType sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectType set %@ where projectTypeID = %i",
       sqlStringSerializationForUpdate,
       projectType.sqliteObjectID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectType sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectType(projectTypeID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectType.sqliteObjectID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];

   [self saveProjectTypeNamesArray:projectType.sqliteObjectID withArray:projectType.ProjectNameArray];
}


- (void)saveProjectTypeNamesArray:(int)projectTypeID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectName * projectName in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectNameID from ProjectTypeNames where projectTypeID = %i and projectNameID = %i",
                                          projectTypeID,
                                          projectName.sqliteObjectID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectTypeNames(projectTypeID,projectNameID) values(%i,%i);",
                                             projectTypeID,
                                             projectName.sqliteObjectID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (void)readProjectTypeNames:(int)projectTypeID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select projectNameID from ProjectTypeNames where projectTypeID = '%i'",
                                    projectTypeID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectNameID = [[results fieldWithName:@"projectNameID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectName * projectName = locations[0];
             [mutableArray addObject:projectName];

             if (isReadArray)
                [self readProjectNameLists:projectName.sqliteObjectID
                                 withArray:projectName.projectListsArray
                               isReadArray:isReadArray];
          }
      };
      [self readProjectNameListWithResults:locationsBlock withProjectNameID:projectNameID];

      [results moveNext];
   }

}


- (ABProjectType *)checkExistForProjectTypeWithProjectTypeName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   NSMutableArray * mutableArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ProjectType where %@",
                                               [ABSqliteObject getSqlStringSerializationForFilter:
                                                @{
                                                 @"projectTypeName" : sqliteObjectName,
                                                 @"objectFullPath" : projectFullPath,
                                                }]];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectType * sqliteObject = [[ABProjectType alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"projectTypeID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"projectTypeName"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [mutableArray addObject:sqliteObject];

      [results moveNext];
   }

   if (mutableArray.count == 1) {
      return mutableArray[0];
   }

   return nil;
}


- (void)readProjectTypeListWithResults:(LocationResultsBlock)locationsBlock WithProjectTypeId:(int)projectTypeId hasAllList:(BOOL)isAllList {
   NSMutableArray * projectTypeArray = [[NSMutableArray alloc] init];
   NSString * sql = @"select * from ProjectType";
   if (isAllList == NO) {
      sql = [NSString stringWithFormat:@"select * from ProjectType where projectTypeId = '%i'",
                                       projectTypeId];
   }

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectTypeID = [[results fieldWithName:@"projectTypeID"] intValue];
      NSString * projectTypeName = [[results fieldWithName:@"projectTypeName"] stringValue];

      [projectTypeArray addObject:[[ABProjectType alloc] initWithProjectTypeID:projectTypeID
                                                               projectTypeName:projectTypeName]];

      [results moveNext];
   }

   locationsBlock(projectTypeArray);
}


#pragma mark - ABProjectName


- (void)saveProjectName:(ABProjectName *)projectName {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select projectName from ProjectName where projectName = '%@'",
                                    projectName.sqliteObjectName];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectName sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectName set %@ where projectNameID = %i",
       sqlStringSerializationForUpdate,
       projectName.sqliteObjectID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectName sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectName(projectNameID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectName.sqliteObjectID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectNameListsArray:projectName.sqliteObjectID withArray:projectName.projectListsArray];
}


- (void)saveProjectNameListsArray:(int)projectNameID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectList * projectList in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectListID from ProjectNameLists where projectNameID = %i and projectListID = %i",
                                          projectNameID,
                                          projectList.sqliteObjectID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectNameLists(projectNameID,projectListID) values(%i,%i);",
                                             projectNameID,
                                             projectList.sqliteObjectID];
            [db sqlExecute:sql];
         }
      }
   }
}


/**
* Sort Array
*
* @param mutableArray The current `ABProjectList`
*
*/
- (void)readProjectNameLists:(int)projectNameID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select projectListID from ProjectNameLists where projectNameID = '%i'",
                                    projectNameID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int projectListID = [[results fieldWithName:@"projectListID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectList * projectList = locations[0];
             [mutableArray addObject:projectList];

             if (isReadArray)
                [self readProjectListFileInfos:projectList.sqliteObjectID withArray:projectList.projectFileInfoArray];
          }
      };
      [self readProjectListsWithResults:locationsBlock withProjectListID:projectListID];

      [results moveNext];
   }

}


- (ABProjectName *)checkExistForProjectNameWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath {
   NSMutableArray * mutableArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ProjectName where %@",
                                               [ABSqliteObject getSqlStringSerializationForFilter:
                                                @{
                                                 @"ProjectName" : sqliteObjectName,
                                                 @"objectFullPath" : projectFullPath,
                                                }]];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectName * sqliteObject = [[ABProjectName alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"projectNameID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"ProjectName"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [mutableArray addObject:sqliteObject];

      [results moveNext];
   }

   if (mutableArray.count == 1) {
      ABProjectName * sqliteObject = mutableArray[0];
      [self readProjectNameLists:sqliteObject.sqliteObjectID
                       withArray:sqliteObject.lastsubDirectoryListsArray
                     isReadArray:NO];
      return sqliteObject;
   }

   return nil;
}


- (void)readProjectNameListWithResults:(LocationResultsBlock)locationsBlock withProjectNameID:(int)projectNameID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql;

   sql = [NSString stringWithFormat:@"select * from ProjectName where projectNameID = '%i'",
                                    projectNameID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectName * sqliteObject = [[ABProjectName alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"projectNameID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"projectName"] stringValue];
      sqliteObject.projectDownloadUrl = [[results fieldWithName:@"projectDownloadUrl"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [projectNameArray addObject:sqliteObject];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectList


- (void)saveProjectList:(ABProjectList *)projectList {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select projectListID from ProjectList where projectListID = %i",
                                    projectList.sqliteObjectID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectList sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectList set %@ where projectListID = %i",
       sqlStringSerializationForUpdate,
       projectList.sqliteObjectID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectList sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectList(projectListID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectList.sqliteObjectID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectListFileInfosArray:projectList.sqliteObjectID withArray:projectList.projectFileInfoArray];
}


- (void)saveProjectListFileInfosArray:(int)projectListID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectFileInfo * projectFileInfo in mutableArray) {
         sql = [NSString stringWithFormat:@"select fileInfoID from ProjectListFileInfos where projectListID = %i and fileInfoID = %i",
                                          projectListID,
                                          projectFileInfo.sqliteObjectID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectListFileInfos(projectListID,fileInfoID) values(%i,%i);",
                                             projectListID,
                                             projectFileInfo.sqliteObjectID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (void)readProjectListFileInfos:(int)projectListID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select fileInfoID from ProjectListFileInfos where projectListID = '%i'",
                                    projectListID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int fileInfoID = [[results fieldWithName:@"fileInfoID"] intValue];

      LocationResultsBlock locationsBlock = ^(NSArray * locations) {
          if (locations.count > 0) {
             ABProjectFileInfo * projectFileInfo = locations[0];
             [mutableArray addObject:projectFileInfo];
          }
      };
      [self readProjectFileInfoListWithResults:locationsBlock withFileInfoID:fileInfoID];

      [results moveNext];
   }
}


- (void)getFileInfoArrayForProjectList:(ABProjectList *)projectList {
   [self readProjectListFileInfos:projectList.sqliteObjectID withArray:projectList.lastsubDirectoryListsArray];
}


- (void)readProjectListsWithResults:(LocationResultsBlock)locationsBlock withProjectListID:(int)projectListID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ProjectList where projectListID = %i",
                                               projectListID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectList * sqliteObject = [[ABProjectList alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"projectListID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"projectListName"] stringValue];

      [projectNameArray addObject:sqliteObject];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectFileInfo


- (void)saveProjectFileInfo:(ABProjectFileInfo *)fileInfo {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select fileInfoID from ProjectFileInfo where fileInfoID = %i",
                                    fileInfo.sqliteObjectID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [fileInfo sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectFileInfo set %@ where fileInfoID = %i",
       sqlStringSerializationForUpdate,
       fileInfo.sqliteObjectID];
   } else {
      NSArray * sqlStringSerializationForInsert = [fileInfo sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectFileInfo(fileInfoID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       fileInfo.sqliteObjectID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];
}


- (BOOL)checkFileInfoExist:(NSString *)fileAbstractPath {
   NSString * sql = [NSString stringWithFormat:@"select * from ProjectFileInfo where objectFullPath='%@'",
                                               fileAbstractPath];

   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof]) {
      return YES;
   }

   return NO;
}


- (void)readProjectFileInfoListWithResults:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql = [NSString stringWithFormat:@"select * from ProjectFileInfo where fileInfoID=%i", fileInfoID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectFileInfo * sqliteObject = [[ABProjectFileInfo alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"fileInfoID"] intValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"fileInforName"] stringValue];
      sqliteObject.subtitleName = [[results fieldWithName:@"subtitleName"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [projectNameArray addObject:sqliteObject];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


- (void)readFileInfoAbstractPath:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql = [NSString stringWithFormat:@"select objectFullPath from ProjectFileInfo where fileInfoID=%i",
                                               fileInfoID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectFileInfo * sqliteObject = [[ABProjectFileInfo alloc] init];

      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [projectNameArray addObject:sqliteObject];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


- (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath {
   // *** online-step-{ABOnlineVideoType-1} ***
   ABOnlineVideoType * onlineVideoType = [[ABOnlineVideoType alloc] initWithOnlineTypeName:onlineTypeName
                                                                           projectFullPath:onlineVideoTypePath
                                                                            withDictionary:dictionary];

   [self saveOnlineVideoType:onlineVideoType];

   [self saveForOnlineTypeArray:onlineVideoType];
}


// step02: save ABProjectType
- (void)saveForOnlineTypeArray:(ABOnlineVideoType *)onlineVideoType {
   NSMutableDictionary * onlineTypeArray = onlineVideoType.onlineTypeDictionary;
   for (ABProjectType * projectType in onlineTypeArray.allValues) {
      [self saveProjectType:projectType];

      // step02: save ABProjectName
      [self saveForProjectTypeArray:projectType];
   }
}


- (void)saveForProjectTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName {
   NSArray * allKeys = dictionary.allKeys;

   // step01: save ABProjectType
   for (NSString * key in allKeys) {
      ABProjectType * projectType = [dictionary objectForKey:key];
      [self saveProjectType:projectType];

      // step02: save ABProjectName
      [self saveForProjectTypeArray:projectType];
   }
}


// step02: save ABProjectName
- (void)saveForProjectTypeArray:(ABProjectType *)projectType {

   NSMutableArray * projectNameArray = projectType.ProjectNameArray;
   for (ABProjectName * projectName in projectNameArray) {
      [self saveProjectName:projectName];

      // step03: save ABProjectList
      NSMutableArray * projectLists = projectName.projectListsArray;
      for (ABProjectList * projectList in projectLists) {
         [self saveProjectList:projectList];

         // step04: save ABProjectFileInfo
         NSMutableArray * projectLists = projectList.projectFileInfoArray;
         for (ABProjectFileInfo * projectFileInfo in projectLists) {
            [self saveProjectFileInfo:projectFileInfo];
         }
      }
   }
}


- (void)readDictionaryForProjectTypeWithProjectTypeId:(int)projectTypeId toDictionary:(NSMutableDictionary *)dictionary hasAllList:(BOOL)isAllList {

   LocationResultsBlock LocationResultsBlock = ^(NSArray * locations) {
       for (ABProjectType * projectType in locations) {
          [dictionary setObject:projectType forKey:projectType.sqliteObjectName];

          [self readProjectTypeNames:projectType.sqliteObjectID
                           withArray:projectType.ProjectNameArray
                         isReadArray:isAllList];
       }
   };
   [self readProjectTypeListWithResults:LocationResultsBlock WithProjectTypeId:projectTypeId hasAllList:isAllList];

}


- (void)makeObjectFullPathForProjectListArray:(NSMutableArray *)projectListArray projectFullPath:(NSString *)projectFullPath {
   for (ABProjectList * projectList in projectListArray) {
      NSString * objectFullPath = [projectList makeObjectFullPath:projectFullPath];
      for (ABProjectFileInfo * fileInfo in projectList.projectFileInfoArray) {
         [fileInfo makeObjectFullPath:objectFullPath];
      }
   }
}
@end
