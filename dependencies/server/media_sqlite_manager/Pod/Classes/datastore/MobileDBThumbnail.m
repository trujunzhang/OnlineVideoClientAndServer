//
//  EasySpendLogDB.m
//  Easy Spend Log
//
//  Created by Aaron Bratcher on 04/25/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "MobileDBThumbnail.h"
#import "ABSQLiteDB.h"

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
         [self makeDB];
   }

   [self checkSchema]; // always check schema because updates are done here

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


@end
