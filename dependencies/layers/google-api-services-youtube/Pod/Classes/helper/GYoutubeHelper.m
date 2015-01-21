//
//  Search.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//



#import "GYoutubeHelper.h"

#import "Online_Request.h"
#import "OnlineServerInfo.h"
#import "ParseHelper.h"
#import "ParseLocalStore.h"
#import "SqliteDatabaseConstant.h"
#import "SSZipArchive.h"

static GYoutubeHelper *instance = nil;


@interface GYoutubeHelper () {

}

@end


@implementation GYoutubeHelper


#pragma mark -
#pragma mark GYoutubeHelper Static instance


+ (GYoutubeHelper *)getInstance {
    @synchronized (self) {
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return (instance);
}


- (void)initOnlineClient:(SqliteResponseBlock)downloadCompletionBlock checkVersion:(BOOL)checkVersion {
    [self.delegate showStepInfo:@"Fetching OnlineVideoInfo frome parse.com !"];

    ParseHelperResultBlock parseHelperResultBlock = ^(OnlineServerInfo *object, NSError *error) {
        self.onlineServerInfo = object;
        if(error) {
            [self.delegate showStepInfo:@"Fetching failure?"];
        } else {
            [self fetchingRemoteSqliteFile:downloadCompletionBlock];
        }
    };

    if(hasLocalSqliteFile) {
        parseHelperResultBlock([OnlineServerInfo localServerInfo], nil);
    } else {
        [[ParseHelper sharedParseHelper] readOnlineVideoInfo:parseHelperResultBlock];
    }
}

- (void)fetchingSubtitle:(SubtitleResponseBlock)subtitleResponseBlock withUrl:(NSString *)subtitleUrl {
    // 1. remove last srt file.
    NSURL *removeUrl = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                               inDomain:NSUserDomainMask
                                                      appropriateForURL:nil
                                                                 create:NO
                                                                  error:nil] URLByAppendingPathComponent:subtitleTempName];
    [[NSFileManager defaultManager] removeItemAtURL:removeUrl error:nil];
    // 2. fetching new srt.
    void (^downloadCompletion)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse *response, NSURL *url, NSError *error) {
        subtitleResponseBlock(removeUrl, error);
    };
    [Online_Request fetchingSubtitle:subtitleUrl downloadCompletionBlock:downloadCompletion];
}


- (void)fetchingRemoteSqliteFile:(SqliteResponseBlock)downloadCompletionBlock {
    NSString *remoteSqliteUrl = [self.onlineServerInfo getRemoteSqliteDatabase];

    [self.delegate showStepInfo:[NSString stringWithFormat:@"Downloading sqlite file from %@", remoteSqliteUrl]];

    NSProgress *progress;

    RemoteSqliteResponseBlock downloadCompletion = ^(NSString *localPath, NSError *error) {
        if(error) {
            id objectForKey = [[error userInfo] objectForKey:@"NSErrorFailingURLKey"];

            [self.delegate showStepInfo:[NSString stringWithFormat:@"Downloaded %@ failure?",
                                                                   [[objectForKey absoluteURL] absoluteString]]];
        } else {
            [self unzippingDatabase:localPath];
            downloadCompletionBlock(nil);
        }
    };
    [Online_Request downloadSqliteFile:remoteSqliteUrl downloadCompletionBlock:downloadCompletion progressBlock:&progress downloadFileName:dataBaseZipName];

}

- (void)unzippingDatabase:(NSString *)zipPath {
    // Unzipping
    NSString *destinationPath = [Online_Request getDownloadCachePath];
    [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
}


//   [[ParseHelper sharedParseHelper] saveOnlineVideoInfo:[OnlineServerInfo standardServerInfo]];// test
- (BOOL)checkValidateLocalSqlite:(NSString *)version {
    if(hasLocalSqliteFile) {
        return NO;
    }

    NSString *lastVersion = [ParseLocalStore readSqliteVersion];
    if([ParseLocalStore checkLocalCacheSqliteExist] == YES) {// exist
        if([lastVersion isEqualToString:version] == YES) { // the same
            return YES;
        }
    }


    return NO;
}


- (NSString *)getCurrentDomainUrl {
    return [self.onlineServerInfo getCurrentDomainUrl];
}


- (NSString *)getHtdocs {
    return [self.onlineServerInfo htdocs];
}


- (NSString *)getServerCacheDirectory {
    return [self.onlineServerInfo cacheThumbmail];
}


- (instancetype)init {
    self = [super init];
    if(self) {

    }

    return self;
}


@end
