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
#import "SqliteDatabaseConstant.h"
#import "SSZipArchive.h"

@implementation UserCacheFolderHelper {

}

#pragma mark -
#pragma mark


+ (NSString *)RealHomeDirectory {
    struct passwd *pw = getpwuid(getuid());
    assert(pw);
    return [NSString stringWithUTF8String:pw->pw_dir];
}


///Volumes/Home/djzhang/.AOnlineTutorial/.server
+ (NSString *)RealProjectServerDirectory {
    return [NSString stringWithFormat:@"%@/%@/%@",
                                      [UserCacheFolderHelper RealHomeDirectory],
                                      appProfile,
                                      appSubDirectory];
}


///Volumes/Home/djzhang/.AOnlineTutorial/.server/VideoTrainingDB.db
+ (NSString *)RealVideoTrainingDBAbstractPath {
    return [NSString stringWithFormat:@"%@/%@",
                                      [UserCacheFolderHelper RealProjectServerDirectory],
                                      dataBaseName];
}

+ (NSString *)RealVideoTrainingZipDBAbstractPath {
    return [NSString stringWithFormat:@"%@/%@",
                                      [UserCacheFolderHelper RealProjectServerDirectory],
                                      dataBaseZipName];
}


///Volumes/Home/djzhang/.AOnlineTutorial/.server/.cache
+ (NSString *)RealProjectCacheDirectory {
    return [NSString stringWithFormat:@"%@/%@", [UserCacheFolderHelper RealProjectServerDirectory], appCacheDirectory];
}


+ (NSString *)getThumbnailDirectory {
    return [NSString stringWithFormat:@"%@/%@",
                                      [UserCacheFolderHelper RealProjectCacheDirectory],
                                      thumbnailFolder];
}


+ (NSString *)getThumbnailDirectory:(NSString *)dbDirectory {
    return [NSString stringWithFormat:@"%@/%@",
                                      dbDirectory,
                                      thumbnailFolder];
}


#pragma mark -
#pragma mark


+ (void)createDirectoryForCache:(NSFileManager *)filemgr withCacheDirectory:(NSString *)cacheDirectory withThumbnailDirectory:(NSString *)thumbnailDirectory {
    NSError *error = nil;
    if(![filemgr createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
        // An error has occurred, do something to handle it
        NSLog(@"Failed to create directory \"%@\". Error: %@", cacheDirectory, error);
    }


    if(![filemgr createDirectoryAtPath:thumbnailDirectory
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error]) {
        // An error has occurred, do something to handle it
        NSLog(@"Failed to create directory \"%@\". Error: %@", thumbnailDirectory, error);
    }
}


#pragma mark -
#pragma mark


+ (void)emptyCacheThumbnailDirectory:(NSFileManager *)filemgr forDir:(NSString *)dirToEmpty {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [manager contentsOfDirectoryAtPath:dirToEmpty
                                                  error:&error];

    if(error) {
        //deal with error and bail.
        return;
    }

    for (NSString *file in files) {
        [manager removeItemAtPath:[dirToEmpty stringByAppendingPathComponent:file]
                            error:&error];
        if(error) {
            //an error occurred...
        }
    }
}


+ (BOOL)cleanupCache:(NSString *)cacheDirectory {
    NSFileManager *filemgr = [NSFileManager defaultManager];

    NSString *dbFilePath = [cacheDirectory stringByAppendingPathComponent:dataBaseName];

    NSString *thumbnailDirectory = [self getThumbnailDirectory:cacheDirectory];

    BOOL fileExists = [MobileBaseDatabase checkDBFileExist:dbFilePath];
    if(fileExists == NO) {
        [UserCacheFolderHelper createDirectoryForCache:filemgr
                                    withCacheDirectory:cacheDirectory
                                withThumbnailDirectory:thumbnailDirectory];
        return YES;
    }

    [UserCacheFolderHelper emptyCacheThumbnailDirectory:filemgr forDir:thumbnailDirectory];

    if([filemgr removeItemAtPath:dbFilePath error:NULL] == YES) {
        return YES;
    }
    else {
        NSLog(@"Remove failed");
    }

    return NO;
}


#pragma mark -
#pragma mark


+ (void)checkUserProjectDirectoryExistAndMake {
    [UserCacheFolderHelper createDirectoryForCache:[NSFileManager defaultManager]
                                withCacheDirectory:[UserCacheFolderHelper RealProjectCacheDirectory]
                            withThumbnailDirectory:[self getThumbnailDirectory]];
}


+ (BOOL)cleanupCache {
    NSString *dbDirectory = [UserCacheFolderHelper RealProjectCacheDirectory];

    if([UserCacheFolderHelper cleanupCache:dbDirectory] == NO) {
        NSLog(@"Remove failed");
        return NO;
    }

    return YES;
}


+ (void)removeFilesForVideoTrainingDB {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self RealVideoTrainingDBAbstractPath] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[self RealVideoTrainingZipDBAbstractPath] error:&error];
}

#pragma mark -
#pragma mark zip database

+ (void)zipFileForDatabase {
    // Zipping
    NSString *zippedPath = [self RealVideoTrainingZipDBAbstractPath];
    NSArray *inputPaths = @[[self RealVideoTrainingDBAbstractPath]];
    [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];
}
@end