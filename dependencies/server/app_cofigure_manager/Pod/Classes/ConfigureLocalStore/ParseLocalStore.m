//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ParseLocalStore.h"


@implementation ParseLocalStore {

}

+ (void)saveSqliteVersion:(NSString *)version {
   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:version forKey:@"sqlite_version"];
   [defaults synchronize];
}


+ (NSString *)readSqliteVersion {
   NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
   if ([defaults objectForKey:@"sqlite_version"]) {
      return [defaults objectForKey:@"sqlite_version"];
   }

   return @"";
}


+ (BOOL)checkLocalCacheSqliteExist {
   NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
   NSURL * sqlitePathUrl = [documentsDirectoryURL URLByAppendingPathComponent:@"VideoTrainingDB.db"];
   NSString * filePathName = [sqlitePathUrl path];

   BOOL myPathIsDir;
   BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathName isDirectory:&myPathIsDir];

   return fileExists;
}


@end