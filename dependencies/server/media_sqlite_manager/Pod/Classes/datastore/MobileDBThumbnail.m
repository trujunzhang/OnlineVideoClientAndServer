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

static MobileDBThumbnail * _dbInstance;


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

   _dbInstance = self;

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
   db = [[ABSQLiteDB alloc] init];

   if (![db connect:filePathName]) {
      return nil;
   }

   if (!fileExists) {
      if (!backupDbPath || !copiedBackupDb)
         [self makeForMobileDBThumbnail];
   }

   [self checkSchemaForMobileDBThumbnail]; // always check schema because updates are done here

   return self;
}


+ (MobileDBThumbnail *)dbInstance:(NSString *)path {
   if (!_dbInstance) {
      NSString * dbFilePath = [path stringByAppendingPathComponent:dataBaseName];
      MobileDBThumbnail * mobileThumbnail = [[MobileDBThumbnail alloc] initWithFile:dbFilePath];
   }

   return _dbInstance;
}


- (void)close {
   [db close];
}


- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(int)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   NSMutableArray * mutableArray = [[NSMutableArray alloc] init];

   NSString * sql = [NSString stringWithFormat:@"select * from ThumbnailInfo where %@",
                                               [ABSqliteObject getSqlStringSerializationForFilter:
                                                @{
                                                 @"fileInforName" : sqliteObjectName,
                                                 @"objectFullPath" : fullPath,
                                                }]];

   id<ABRecordset> results = [db sqlSelect:sql];
   while (![results eof]) {
      SOThumbnailInfo * sqliteObject = [[SOThumbnailInfo alloc] init];

      sqliteObject.sqliteObjectID = [[results fieldWithName:@"projectTypeID"] intValue];
      sqliteObject.fileInfoID = [[results fieldWithName:@"fileInfoID"] intValue];
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
@end
