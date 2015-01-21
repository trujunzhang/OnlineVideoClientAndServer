//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineVideoStatisticsHelper.h"
#import "ABProjectName.h"
#import "ABProjectType.h"
#import "OnlineVideoProjectListHelper.h"
#import "OnlineVideoConstant.h"
#import "MobileDBCacheDirectoryHelper.h"


@implementation OnlineVideoStatisticsHelper {

}

- (instancetype)initWithOnlinePath:(NSString *)videoScanFold withCacheDirectory:(NSString *)cacheDirectory {
    self = [super init];
    if(self) {
        self.videoScanFold = videoScanFold;
        self.cacheDirectory = cacheDirectory;

        self.projectTypesDictionary = [[NSMutableDictionary alloc] init];

        [self searchProjectTypesInFolder:videoScanFold withDictionaryKey:@""];
    }

    return self;
}


#pragma mark -
#pragma mark Search Project types


- (void)searchProjectTypesInFolder:(NSString *)appDocDir withDictionaryKey:(NSString *)key {
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString *fullPath = [appDocDir stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if(isDir == YES) {
                TFOLD_TYPE type = [self checkDirType:aPath];
                switch (type) {
                    case TFOLD_CATELOGY: {
                        // *** online-step-{ABProjectType-2} ***
                        ABProjectType *projectType = [MobileDBCacheDirectoryHelper checkExistForProjectTypeWithProjectTypeName:aPath
                                                                                                               projectFullPath:fullPath];
                        if(projectType == nil) {
                            projectType = [[ABProjectType alloc] initWithProjectName:aPath
                                                                     projectFullPath:fullPath];
                        }

                        [self.projectTypesDictionary setObject:projectType forKey:aPath];
                        [self searchProjectNameListInProjectType:fullPath to:projectType];
                    };
                        break;
                    default:
                        [self searchProjectTypesInFolder:fullPath withDictionaryKey:key];
                        break;
                }
            }
        }
    }
}


- (void)searchProjectNameListInProjectType:(NSString *)appDocDir to:(ABProjectType *)projectType {
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSString *fullPath = [appDocDir stringByAppendingPathComponent:aPath];
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if(isDir == YES) {
                TFOLD_TYPE type = [self checkDirType:aPath];
                switch (type) {
                    case TFOLD_PROJECT: {
                        [self makeProjectListInProjectType:projectType aPath:aPath fullPath:fullPath];
                    };
                        break;
                    default:
                        [self searchProjectNameListInProjectType:fullPath to:projectType];
                        break;
                }
            }
        }
    }
}


#pragma mark -
#pragma mark Make Project list in Project type Folder


- (void)makeProjectListInProjectType:(ABProjectType *)projectType aPath:(NSString *)aPath fullPath:(NSString *)fullPath {
    OnlineVideoProjectListHelper *onlineVideoProjectListHelper =
            [[OnlineVideoProjectListHelper alloc] initWithOnlinePath:self.videoScanFold
                                                  withCacheDirectory:self.cacheDirectory];

    [onlineVideoProjectListHelper makeProjectList:aPath withFullPath:fullPath to:projectType];
}


- (TFOLD_TYPE)checkDirType:(NSString *)path {
    NSUInteger length = [path length];
    if(length >= 2 && [[path substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"@@"]) {
        return TFOLD_PROJECT;
    }
    else if(length >= 1 && [[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"]) {
        return TFOLD_CATELOGY;
    }

    return -1;
}


- (BOOL)checkIsFile:(NSString *)pathToFile {
    pathToFile = @"Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction";
//   pathToFile = @"Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/03-How to send feedback.mp4";

    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToFile isDirectory:&isDir] && isDir) {
        NSLog(@"Is directory");
        return NO;
    }

    return YES;
}


@end