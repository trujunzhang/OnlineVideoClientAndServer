//
//  Search.m
//  IOSTemplate
//
//  Created by djzhang on 9/25/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import <google-api-services-youtube/GYoutubeHelper.h>
#import "GYoutubeHelper.h"
#import "Online_Request.h"
#import "OnlineServerInfo.h"
#import "ParseHelper.h"
#import "ParseLocalStore.h"
#import "TCBlobDownloadManager.h"


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
            [self fetchingSqliteFileFromRemote:downloadCompletionBlock];
        }
    };

    if(hasLocalSqliteFile) {
        parseHelperResultBlock([OnlineServerInfo localServerInfo], nil);
    } else {
        [[ParseHelper sharedParseHelper] readOnlineVideoInfo:parseHelperResultBlock];
    }
}

- (void)fetchingSubtitle123:(SubtitleResponseBlock)subtitleResponseBlock withUrl:(NSString *)subtitleUrl {
    // Blocks
    [[TCBlobDownloadManager sharedInstance] startDownloadWithURL:[NSURL URLWithString:subtitleUrl]
                                                      customPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"example"]]
                                                   firstResponse:NULL
                                                        progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
                                                            if(remainingTime != -1) {
                                                            }
                                                        }
                                                           error:^(NSError *error) {
                                                               NSLog(@"%@", error);
                                                           }
                                                        complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                            // Read both back into new NSArray and NSDictionary object
                                                            if([[NSFileManager defaultManager] fileExistsAtPath:pathToFile]) {
                                                                //File exists
                                                                NSData *file1 = [[NSData alloc] initWithContentsOfFile:pathToFile];
                                                                if(file1) {
                                                                    NSString *newStr = [[NSString alloc] initWithData:file1
                                                                                                             encoding:NSUTF8StringEncoding];

                                                                    NSArray *array = [newStr componentsSeparatedByString:@"\n"];
                                                                    NSString *debug = @"debug";
                                                                }
                                                            }
                                                            else {
                                                                NSLog(@"File does not exist");
                                                            }

                                                            NSString *str = downloadFinished ? @"Completed" : @"Cancelled";
                                                        }];
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


- (void)fetchingSqliteFileFromRemote:(SqliteResponseBlock)downloadCompletionBlock {
    NSString *remoteSqliteUrl = [self.onlineServerInfo getRemoteSqliteDatabase];

    [self.delegate showStepInfo:[NSString stringWithFormat:@"Downloading sqlite file from %@", remoteSqliteUrl]];

    NSProgress *progress;
    void (^downloadCompletion)(NSURLResponse *, NSURL *, NSError *) = ^(NSURLResponse *response, NSURL *url, NSError *error) {
        if(error) {
            id objectForKey = [[error userInfo] objectForKey:@"NSErrorFailingURLKey"];

            [self.delegate showStepInfo:[NSString stringWithFormat:@"Downloaded %@ failure?",
                                                                   [[objectForKey absoluteURL] absoluteString]]];
        } else {
            [ParseLocalStore saveSqliteVersion:self.onlineServerInfo.version];
            downloadCompletionBlock(nil);
        }
    };
    // 2
    [Online_Request downloadSqliteFile:remoteSqliteUrl
               downloadCompletionBlock:downloadCompletion
                         progressBlock:&progress];

    // Observe fractionCompleted using KVO
    [progress addObserver:self
               forKeyPath:@"fractionCompleted"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
//        NSLog(@"Progress is %f", progress.fractionCompleted);
    }
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


- (void)fetchSqliteRemoteFile:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock {
    [Online_Request downloadSqliteFile:[self.onlineServerInfo getRemoteSqliteDatabase]
               downloadCompletionBlock:downloadCompletionBlock
                         progressBlock:progressBlock];
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
