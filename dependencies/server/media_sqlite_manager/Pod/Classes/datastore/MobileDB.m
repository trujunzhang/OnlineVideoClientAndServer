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
         [self makeDB];
   }

   [self checkSchema]; // always check schema because updates are done here

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
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select onlineVideoTypeID from OnlineVideoType where onlineVideoTypeName ='%@'",
                                    onlineVideoType.sqliteObjectName];

   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [onlineVideoType sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update OnlineVideoType set %@ where onlineVideoTypeID = %i",
       sqlStringSerializationForUpdate,
       onlineVideoType.onlineVideoTypeID];
   } else {
      NSArray * sqlStringSerializationForInsert = [onlineVideoType sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into OnlineVideoType(onlineVideoTypeID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       onlineVideoType.onlineVideoTypeID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];

   [self saveOnlineVideoTypeProjectTypesArray:onlineVideoType.onlineVideoTypeID
                               withDictionary:onlineVideoType.onlineTypeDictionary];
}


- (void)saveOnlineVideoTypeProjectTypesArray:(int)onlineVideoTypeID withDictionary:(NSMutableDictionary *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectType * abProjectType in mutableArray.allValues) {
         sql = [NSString stringWithFormat:@"select projectTypeID from OnlineVideoTypeProjectTypes where onlineVideoTypeID = %i and projectTypeID = %i",
                                          onlineVideoTypeID,
                                          abProjectType.projectTypeID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into OnlineVideoTypeProjectTypes(onlineVideoTypeID,projectTypeID) values(%i,%i);",
                                             onlineVideoTypeID,
                                             abProjectType.projectTypeID];
            [db sqlExecute:sql];
         }
      }
   }
}


- (NSMutableArray *)readOnlineVideoTypes:(ABOnlineVideoType *)onlineVideoType {
   NSMutableArray * onlineVideoTypeArray = [[NSMutableArray alloc] init];

   NSString * sql = @"select * from OnlineVideoType";
   if (onlineVideoType) {
      sql = [NSString stringWithFormat:@"select * from OnlineVideoType where onlineVideoTypeName ='%@'",
                                       onlineVideoType.sqliteObjectName];
   }

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABOnlineVideoType * onlineVideoType = [[ABOnlineVideoType alloc] init];

      onlineVideoType.onlineVideoTypeID = [[results fieldWithName:@"onlineVideoTypeID"] intValue];
      onlineVideoType.sqliteObjectName = [[results fieldWithName:@"onlineVideoTypeName"] stringValue];
      onlineVideoType.onlineVideoTypePath = [[results fieldWithName:@"onlineVideoTypePath"] stringValue];

      [onlineVideoTypeArray addObject:onlineVideoType];

      [self readOnlineTypeArray:onlineVideoType.onlineVideoTypeID
                      withArray:onlineVideoType.onlineTypeDictionary
                    isReadArray:NO];

      [results moveNext];
   }


   return onlineVideoTypeArray;

}


- (NSMutableArray *)readOnlineVideoTypes {
   return [self readOnlineVideoTypes:nil];
}


- (void)readOnlineTypeArray:(int)onlineVideoTypeID withArray:(NSMutableDictionary *)dictionary isReadArray:(BOOL)isReadArray {
   NSString * sql;
   sql = [NSString stringWithFormat:@"select ProjectTypeID from OnlineVideoTypeProjectTypes where onlineVideoTypeID = '%i'",
                                    onlineVideoTypeID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      int ProjectTypeID = [[results fieldWithName:@"ProjectTypeID"] intValue];

      [self readDictionaryForProjectTypeWithProjectTypeId:ProjectTypeID toDictionary:dictionary hasAllList:NO];

      [self addOnlineVideoInfo:onlineVideoTypeID toProjectTypeDictionary:dictionary];

      [results moveNext];
   }

}


- (void)addOnlineVideoInfo:(int)onlineVideoTypeID toProjectTypeDictionary:(NSMutableDictionary *)dictionary {
   for (ABProjectType * projectType in dictionary.allValues) {
      projectType.onlineVideoTypeID = onlineVideoTypeID;
   }
}


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
       projectType.projectTypeID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectType sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectType(projectTypeID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectType.projectTypeID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];

   [self saveProjectTypeNamesArray:projectType.projectTypeID withArray:projectType.ProjectNameArray];
}


- (void)saveProjectTypeNamesArray:(int)projectTypeID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectName * projectName in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectNameID from ProjectTypeNames where projectTypeID = %i and projectNameID = %i",
                                          projectTypeID,
                                          projectName.projectNameID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectTypeNames(projectTypeID,projectNameID) values(%i,%i);",
                                             projectTypeID,
                                             projectName.projectNameID];
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
                [self readProjectNameLists:projectName.projectNameID
                                 withArray:projectName.projectLists
                               isReadArray:YES];
          }
      };
      [self readProjectNameListWithResults:locationsBlock withprojectNameID:projectNameID];

      [results moveNext];
   }

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
       projectName.projectNameID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectName sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectName(projectNameID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectName.projectNameID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectNameListsArray:projectName.projectNameID withArray:projectName.projectLists];
}


- (void)saveProjectNameListsArray:(int)projectNameID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectList * projectList in mutableArray) {
         sql = [NSString stringWithFormat:@"select projectListID from ProjectNameLists where projectNameID = %i and projectListID = %i",
                                          projectNameID,
                                          projectList.projectListID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectNameLists(projectNameID,projectListID) values(%i,%i);",
                                             projectNameID,
                                             projectList.projectListID];
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
                [self readProjectListFileInfos:projectList.projectListID withArray:projectList.projectFileInfos];
          }
      };
      [self readProjectListsWithResults:locationsBlock withProjectListID:projectListID];

      [results moveNext];
   }

}


- (void)readProjectNameListWithResults:(LocationResultsBlock)locationsBlock withprojectNameID:(int)projectNameID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql;

   sql = [NSString stringWithFormat:@"select * from ProjectName where projectNameID = '%i'",
                                    projectNameID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectName * projectName = [[ABProjectName alloc] init];

      projectName.projectNameID = [[results fieldWithName:@"projectNameID"] intValue];
      projectName.sqliteObjectName = [[results fieldWithName:@"projectName"] stringValue];
      projectName.projectDownloadUrl = [[results fieldWithName:@"projectDownloadUrl"] stringValue];
      projectName.projectAbstractPath = [[results fieldWithName:@"projectAbstractPath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectList


- (void)saveProjectList:(ABProjectList *)projectList {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select projectListID from ProjectList where projectListID = %i",
                                    projectList.projectListID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [projectList sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectList set %@ where projectListID = %i",
       sqlStringSerializationForUpdate,
       projectList.projectListID];
   } else {
      NSArray * sqlStringSerializationForInsert = [projectList sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectList(projectListID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       projectList.projectListID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];


   [self saveProjectListFileInfosArray:projectList.projectListID withArray:projectList.projectFileInfos];
}


- (void)saveProjectListFileInfosArray:(int)projectListID withArray:(NSMutableArray *)mutableArray {
   NSString * sql;
   if ([mutableArray count] > 0) {
      for (ABProjectFileInfo * projectFileInfo in mutableArray) {
         sql = [NSString stringWithFormat:@"select fileInfoID from ProjectListFileInfos where projectListID = %i and fileInfoID = %i",
                                          projectListID,
                                          projectFileInfo.fileInfoID];
         id<ABRecordset> results = [db sqlSelect:sql];

         if ([results eof]) {
            sql = [NSString stringWithFormat:@"insert into ProjectListFileInfos(projectListID,fileInfoID) values(%i,%i);",
                                             projectListID,
                                             projectFileInfo.fileInfoID];
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


- (void)readProjectListsWithResults:(LocationResultsBlock)locationsBlock withProjectListID:(int)projectListID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ProjectList where projectListID = %i",
                                               projectListID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectList * projectName = [[ABProjectList alloc] init];

      projectName.projectListID = [[results fieldWithName:@"projectListID"] intValue];
      projectName.sqliteObjectName = [[results fieldWithName:@"projectListName"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


#pragma mark - ABProjectFileInfo


- (void)saveProjectFileInfo:(ABProjectFileInfo *)fileInfo {
   NSString * sql;
   BOOL exists = NO;

   sql = [NSString stringWithFormat:@"select fileInfoID from ProjectFileInfo where fileInfoID = %i",
                                    fileInfo.fileInfoID];
   id<ABRecordset> results = [db sqlSelect:sql];
   if (![results eof])
      exists = YES;

   if (exists) {
      NSString * sqlStringSerializationForUpdate = [fileInfo sqlStringSerializationForUpdate];

      sql = [NSString stringWithFormat:
       @"update ProjectFileInfo set %@ where fileInfoID = %i",
       sqlStringSerializationForUpdate,
       fileInfo.fileInfoID];
   } else {
      NSArray * sqlStringSerializationForInsert = [fileInfo sqlStringSerializationForInsert];

      sql = [NSString stringWithFormat:
       @"insert into ProjectFileInfo(fileInfoID,%@) values(%i,%@)",
       sqlStringSerializationForInsert[0],
       fileInfo.fileInfoID,
       sqlStringSerializationForInsert[1]
      ];
   }

   [db sqlExecute:sql];
}


- (BOOL)checkFileInfoExist:(NSString *)fileAbstractPath {
   NSString * sql = [NSString stringWithFormat:@"select * from ProjectFileInfo where abstractFilePath='%@'",
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
      ABProjectFileInfo * projectName = [[ABProjectFileInfo alloc] init];

      projectName.fileInfoID = [[results fieldWithName:@"fileInfoID"] intValue];
      projectName.sqliteObjectName = [[results fieldWithName:@"fileInforName"] stringValue];
      projectName.subtitleName = [[results fieldWithName:@"subtitleName"] stringValue];
      projectName.abstractFilePath = [[results fieldWithName:@"abstractFilePath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


- (void)readFileInfoAbstractPath:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID {
   NSMutableArray * projectNameArray = [[NSMutableArray alloc] init];
   NSString * sql = [NSString stringWithFormat:@"select abstractFilePath from ProjectFileInfo where fileInfoID=%i",
                                               fileInfoID];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      ABProjectFileInfo * projectName = [[ABProjectFileInfo alloc] init];

      projectName.abstractFilePath = [[results fieldWithName:@"abstractFilePath"] stringValue];

      [projectNameArray addObject:projectName];

      [results moveNext];
   }

   locationsBlock(projectNameArray);
}


- (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath {
   ABOnlineVideoType * onlineVideoType = [[ABOnlineVideoType alloc] initWithOnlineTypeName:onlineTypeName
                                                                       onlineVideoTypePath:onlineVideoTypePath
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
      NSMutableArray * projectLists = projectName.projectLists;
      for (ABProjectList * projectList in projectLists) {
         [self saveProjectList:projectList];

         // step04: save ABProjectFileInfo
         NSMutableArray * projectLists = projectList.projectFileInfos;
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

          [self readProjectTypeNames:projectType.projectTypeID withArray:projectType.ProjectNameArray isReadArray:NO];
       }
   };
   [self readProjectTypeListWithResults:LocationResultsBlock WithProjectTypeId:projectTypeId hasAllList:isAllList];

}


@end
