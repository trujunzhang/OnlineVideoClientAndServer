//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineServerInfo.h"
#import "NSString+PJR.h"
#import "SqliteDatabaseConstant.h"


@interface OnlineServerInfo () {

}

@property (nonatomic, strong) NSString *domainUrl;
@end


@implementation OnlineServerInfo {

}

+ (OnlineServerInfo *)standardServerInfo {
    OnlineServerInfo *serverInfo = [[OnlineServerInfo alloc] init];

    serverInfo.domainHost = @"http://192.168.1.200";
    serverInfo.domainPort = @"8040";
    serverInfo.cacheThumbmail = @"Home/djzhang/.AOnlineTutorial/.cache";
    serverInfo.version = @"1.0";
    serverInfo.htdocs = @"/Volumes";

    return serverInfo;
}


+ (OnlineServerInfo *)localServerInfo {
    OnlineServerInfo *serverInfo = [[OnlineServerInfo alloc] init];

    serverInfo.domainHost = @"http://192.168.1.200";
    serverInfo.domainPort = @"8040";
    serverInfo.cacheThumbmail = @"Home/djzhang/.AOnlineTutorial/.server";
    serverInfo.version = @"1.0";
    serverInfo.htdocs = @"/Volumes";

    return serverInfo;
}


- (NSString *)getCurrentDomainUrl {
    NSString *string = [NSString stringWithFormat:@"%@:%@", self.domainHost, self.domainPort];
    [string replaceCharcter:@"\n" withCharcter:@""];
    return string;
}


- (NSString *)getRemoteSqliteDatabase {
    NSString *string = [NSString stringWithFormat:@"%@/%@/%@",
                                                  [self getCurrentDomainUrl],
                                                  [self cacheThumbmail],
                                                  dataBaseZipName];

//    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return string;
}
@end