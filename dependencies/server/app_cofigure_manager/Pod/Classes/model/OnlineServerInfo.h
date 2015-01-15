//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OnlineServerInfo : NSObject


@property (nonatomic, strong) NSString *domainHost;
@property (nonatomic, strong) NSString *domainPort;
@property (nonatomic, strong) NSString *cacheThumbmail;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, copy) NSString *htdocs;

+ (OnlineServerInfo *)standardServerInfo;

+ (OnlineServerInfo *)localServerInfo;

- (NSString *)getCurrentDomainUrl;

- (NSString *)getRemoteSqliteDatabase;
@end