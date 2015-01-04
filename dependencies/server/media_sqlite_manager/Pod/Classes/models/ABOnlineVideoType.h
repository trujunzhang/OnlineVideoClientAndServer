//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSqliteObject.h"
@class ABProjectType;


@interface ABOnlineVideoType : ABSqliteObject

@property(assign) int onlineVideoTypeID;
@property(copy) NSString * onlineVideoTypePath;

@property(strong) NSMutableDictionary * onlineTypeDictionary;

- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName OnlineVideoTypePath:(NSString *)OnlineVideoTypePath;

- (void)appendProjectTypeDictionary:(NSMutableDictionary *)dictionary;
- (void)appendProjectType:(ABProjectType *)projectType;
@end