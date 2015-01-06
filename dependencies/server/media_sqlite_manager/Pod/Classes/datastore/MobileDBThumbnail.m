//
//  EasySpendLogDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "MobileDBThumbnail.h"
#import "ABSQLiteDB.h"
#import "SOThumbnailInfo.h"

static MobileDBThumbnail * _dbThumbnailInstance;
id<ABDatabase> thumbnailDataBase;


@interface MobileDBThumbnail ()

@end


@implementation MobileDBThumbnail {

}


#pragma mark - Base


- (id)init {
   return [self initWithFile:NULL];
}


- (id)initWithFile:(NSString *)filePathName {
   if (!(self = [super init])) return nil;

   _dbThumbnailInstance = self;

   BOOL fileExists = [MobileBaseDatabase checkDBFileExist:filePathName];

   // backupDbPath allows for a pre-made database to be in the app. Good for testing
   NSString * backupDbPath = [[NSBundle mainBundle] pathForResource:@"MobileDBThumbnail" ofType:@"db"];

   BOOL copiedBackupDb = NO;
   if (backupDbPath != nil) {
      copiedBackupDb = [[NSFileManager defaultManager]
       copyItemAtPath:backupDbPath
               toPath:filePathName
                error:nil];
   }

   // open SQLite db file
   thumbnailDataBase = [[ABSQLiteDB alloc] init];

   if (![thumbnailDataBase connect:filePathName]) {
      return nil;
   }

   if (!fileExists) {
      if (!backupDbPath || !copiedBackupDb)
         [self makeForMobileDBThumbnail:thumbnailDataBase];
   }

   [self checkSchemaForMobileDBThumbnail:thumbnailDataBase]; // always check schema because updates are done here

   return self;
}


+ (MobileDBThumbnail *)dbInstance:(NSString *)path {
   if (!_dbThumbnailInstance) {
      NSString * dbFilePath = [path stringByAppendingPathComponent:thumbnailDataBaseName];
      MobileDBThumbnail * mobileThumbnail = [[MobileDBThumbnail alloc] initWithFile:dbFilePath];
   }

   return _dbThumbnailInstance;
}


- (void)close {
   [thumbnailDataBase close];
}


#pragma mark - for MobileDBThumbnail


#pragma mark - Preferences


- (NSString *)escapeText:(NSString *)text {
   NSString * newValue = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
   return newValue;
}


- (NSString *)preferenceForKey:(NSString *)key forDatabase:(id<ABDatabase>)db {
   NSString * preferenceValue = @"";

   NSString * sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

   id<ABRecordset> results;
   results = [db sqlSelect:sql];

   if (![results eof]) {
      preferenceValue = [[results fieldWithName:@"value"] stringValue];
   }

   return preferenceValue;
}


- (void)setPreference:(NSString *)value forKey:(NSString *)key forDatabase:(id<ABDatabase>)db {
   if (!value) {
      return;
   }

   NSString * sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

   id<ABRecordset> results;
   results = [db sqlSelect:sql];
   if ([results eof]) {
      sql = [NSString stringWithFormat:@"insert into preferences(property,value) values('%@','%@');",
                                       key,
                                       [self escapeText:value]];
   }
   else {
      sql = [NSString stringWithFormat:@"update preferences set value = '%@' where property = '%@';",
                                       [self escapeText:value],
                                       key];
   }

   [db sqlExecute:sql];
}


- (void)makeForMobileDBThumbnail:(id<ABDatabase>)db {
   // OnlineVideoType
   [db sqlExecute:@"create table ThumbnailInfo(thumbnailInfoID text, fileInfoID text, fileInforName text, objectFullPath text, primary key(thumbnailInfoID));"];

   // Internal
   [db sqlExecute:@"create table Preferences(property text, value text, primary key(property));"];
}


- (void)checkSchemaForMobileDBThumbnail:(id<ABDatabase>)db {
   NSString * schemaVersion = [self preferenceForKey:@"SchemaVersion" forDatabase:db];

   if ([schemaVersion isEqualToString:@"1"]) {
      // OnlineVideoType
      [db sqlExecute:@"create index idx_thumbnailinfos_thumbnailinfoid on ThumbnailInfo(thumbnailInfoID);"];

      schemaVersion = @"2";
   }

   [db sqlExecute:@"ANALYZE"];

   [self setPreference:schemaVersion forKey:@"SchemaVersion" forDatabase:nil];
}


#pragma mark -
#pragma mark


- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   NSMutableArray * mutableArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ThumbnailInfo where %@",
                                               [ABSqliteObject getSqlStringSerializationForFilter:
                                                @{
                                                 @"fileInforName" : sqliteObjectName,
                                                 @"objectFullPath" : fullPath,
                                                }]];

   id<ABRecordset> results = [thumbnailDataBase sqlSelect:sql];
   while (![results eof]) {
      SOThumbnailInfo * sqliteObject = [[SOThumbnailInfo alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"thumbnailInfoID"] stringValue];
      sqliteObject.fileInfoID = [[results fieldWithName:@"fileInfoID"] stringValue];
      sqliteObject.sqliteObjectName = [[results fieldWithName:@"fileInforName"] stringValue];
      sqliteObject.objectFullPath = [[results fieldWithName:@"objectFullPath"] stringValue];

      [mutableArray addObject:sqliteObject];

      [results moveNext];
   }

   if (mutableArray.count == 1) {
      return mutableArray[0];
   }

   return nil;
}


#pragma mark -
#pragma mark SOThumbnailInfo


- (void)saveThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   SOThumbnailInfo * sqliteObject = [[SOThumbnailInfo alloc] init];

   sqliteObject.sqliteObjectID = [MobileBaseDatabase uniqueID];
   sqliteObject.fileInfoID = sqliteObjectID;
   sqliteObject.sqliteObjectName = sqliteObjectName;
   sqliteObject.objectFullPath = fullPath;

   NSArray * sqlStringSerializationForInsert = [sqliteObject sqlStringSerializationForInsert];

   NSString * sql = [NSString stringWithFormat:
    @"insert into ThumbnailInfo(thumbnailInfoID,%@) values('%@',%@)",
    sqlStringSerializationForInsert[0],
    sqliteObject.sqliteObjectID,
    sqlStringSerializationForInsert[1]
   ];
   [thumbnailDataBase sqlExecute:sql];


}


- (void)test {

}
@end
