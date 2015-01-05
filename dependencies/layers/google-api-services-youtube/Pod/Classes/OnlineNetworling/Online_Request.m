//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "Online_Request.h"

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "YoutubeParser.h"


@implementation Online_Request {

}


//+ (Online_Request *)sharedInstance:(NSString *)baseUrlString {
//   static Online_Request * _sharedClient = nil;
//   static dispatch_once_t onceToken;
//   dispatch_once(&onceToken, ^{
//       NSURL * baseURL = [NSURL URLWithString:baseUrlString];
//
//       NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//       [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"APIs-Google" }];
//
//       NSURLCache * cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
//                                                          diskCapacity:50 * 1024 * 1024
//                                                              diskPath:nil];
//
//       [config setURLCache:cache];
//
//       _sharedClient = [[Online_Request alloc] initWithBaseURL:baseURL
//                                          sessionConfiguration:config];
//       _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
//   });

//   return _sharedClient;
//}


+ (void)downloadSqliteFile:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock {
   NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
   AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

   //"http://192.168.1.103:8040/Home/djzhang/.AOnlineTutorial/.cache/VideoTrainingDB.db"
   NSURL * URL = [NSURL URLWithString:remoteSqliteUrl];

   NSURLRequest * request = [NSURLRequest requestWithURL:URL];

   NSURLSessionDownloadTask * downloadTask =
    [manager downloadTaskWithRequest:request
                            progress:progressBlock
                         destination:^NSURL *(NSURL * targetPath, NSURLResponse * response) {
                             NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                                                    inDomain:NSUserDomainMask
                                                                                           appropriateForURL:nil
                                                                                                      create:NO
                                                                                                       error:nil];
                             return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                         }
                   completionHandler:downloadCompletionBlock];

   [downloadTask resume];
}


+ (void)fetchingSubtitle:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock {

   NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
   AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

//   NSString * remoteSqliteUrl = @"http://192.168.1.200:8040/macshare/MacPE/Lynda.com/Adobe.com/@Muse/serials/@@123/10. Creating Menus in Muse/wh.srt";
   NSURL * URL = [NSURL URLWithString:[remoteSqliteUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

   NSURLRequest * request = [NSURLRequest requestWithURL:URL];


   NSURLSessionDownloadTask * downloadTask =
    [manager downloadTaskWithRequest:request
                            progress:nil
                         destination:^NSURL *(NSURL * targetPath, NSURLResponse * response) {
                             NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                                                    inDomain:NSUserDomainMask
                                                                                           appropriateForURL:nil
                                                                                                      create:NO
                                                                                                       error:nil];
                             return [documentsDirectoryURL URLByAppendingPathComponent:subtitleTempName];
                         }
                   completionHandler:downloadCompletionBlock];

   [downloadTask resume];
}

@end