//
// Created by djzhang on 12/29/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "Online_Request.h"

#import "AFHTTPRequestOperationManager.h"

@implementation Online_Request {

}


+ (void)downloadSqliteFile:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock progressBlock:(__autoreleasing NSProgress **)progressBlock downloadFileName:(NSString *)downloadFileName {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:remoteSqliteUrl]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:downloadFileName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        downloadCompletionBlock(path, nil, nil);
    }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        downloadCompletionBlock(nil, nil, error);
    }];

    [operation start];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
        NSLog(@"status %f", progress);
        // self.progressView.progress = progress;

    }];
}

+ (void)fetchingSubtitle:(NSString *)remoteSqliteUrl downloadCompletionBlock:(void (^)(NSURLResponse *, NSURL *, NSError *))downloadCompletionBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:remoteSqliteUrl]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:subtitleTempName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        downloadCompletionBlock(path, nil, nil);
    }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        downloadCompletionBlock(nil, nil, error);
    }];

    [operation start];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float progress = ((float)totalBytesRead) / totalBytesExpectedToRead;
        NSLog(@"status %f", progress);
        // self.progressView.progress = progress;

    }];

}


@end