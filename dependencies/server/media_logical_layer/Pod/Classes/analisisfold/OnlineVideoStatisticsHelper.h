//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OnlineVideoStatisticsHelper : NSObject

@property(nonatomic, strong) NSString * videoScanFold;
@property(nonatomic, copy) NSString * onlineTypeName;
@property(nonatomic, copy) NSString * cacheDirectory;

@property(nonatomic, strong) NSMutableDictionary * projectTypesDictionary;


- (instancetype)initWithOnlinePath:(NSString *)onlinePath withCacheDirectory:(NSString *)directory;

@end