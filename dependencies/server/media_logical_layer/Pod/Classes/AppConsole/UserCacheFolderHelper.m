//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "UserCacheFolderHelper.h"
#import "MobileBaseDatabase.h"
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <assert.h>
#import "ServerVideoConfigure.h"


@implementation UserCacheFolderHelper {

}


+ (NSString *)RealHomeDirectory {
   struct passwd * pw = getpwuid(getuid());
   assert(pw);
   return [NSString stringWithUTF8String:pw->pw_dir];
}


+ (NSString *)RealProjectCacheDirectory {
   NSString * homeDirectory = [UserCacheFolderHelper RealHomeDirectory];

   return [NSString stringWithFormat:@"%@/%@/%@", homeDirectory, appProfile, appCacheDirectory];
}


+ (void)createDirectoryForCache:(NSFileManager *)filemgr withCacheDirectory:(NSString *)cacheDirectory withThumbnailDirectory:(NSString *)thumbnailDirectory {
   NSError * error = nil;
   if (![filemgr createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
      // An error has occurred, do something to handle it
      NSLog(@"Failed to create directory \"%@\". Error: %@", cacheDirectory, error);
   }


   if (![filemgr createDirectoryAtPath:thumbnailDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error]) {
      // An error has occurred, do something to handle it
      NSLog(@"Failed to create directory \"%@\". Error: %@", thumbnailDirectory, error);
   }
}


+ (void)emptyCacheThumbnailDirectory:(NSFileManager *)filemgr forDir:(NSString *)dirToEmpty {
   NSFileManager * manager = [NSFileManager defaultManager];
   NSError * error = nil;
   NSArray * files = [manager contentsOfDirectoryAtPath:dirToEmpty
                                                  error:&error];

   if (error) {
      //deal with error and bail.
      return;
   }

   for (NSString * file in files) {
      [manager removeItemAtPath:[dirToEmpty stringByAppendingPathComponent:file]
                          error:&error];
      if (error) {
         //an error occurred...
      }
   }
}


+ (BOOL)cleanupCache:(NSString *)cacheDirectory {
   NSFileManager * filemgr = [NSFileManager defaultManager];

   NSString * dbFilePath = [cacheDirectory stringByAppendingPathComponent:dataBaseName];

   NSString * thumbnailDirectory = [NSString stringWithFormat:@"%@/%@",
                                                              cacheDirectory,
                                                              thumbnailFolder];

   BOOL fileExists = [MobileBaseDatabase checkDBFileExist:dbFilePath];
   if (fileExists == NO) {
      [UserCacheFolderHelper createDirectoryForCache:filemgr
                                  withCacheDirectory:cacheDirectory
                              withThumbnailDirectory:thumbnailDirectory];
      return YES;
   }

   [UserCacheFolderHelper emptyCacheThumbnailDirectory:filemgr forDir:thumbnailDirectory];

   if ([filemgr removeItemAtPath:dbFilePath error:NULL] == YES) {
      return YES;
   }
   else {
      NSLog(@"Remove failed");
   }

   return NO;
}


+ (BOOL)cleanupCache {
   NSString * dbDirectory = [UserCacheFolderHelper RealProjectCacheDirectory];

   if ([UserCacheFolderHelper cleanupCache:dbDirectory] == NO) {
      NSLog(@"Remove failed");
      return NO;
   }

   return YES;
}


@end