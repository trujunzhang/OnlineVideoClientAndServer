//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSqliteObject.h"
@class ABProjectType;


@interface ABOnlineVideoType : ABSqliteObject

@property(strong) NSMutableDictionary * onlineTypeDictionary;

- (instancetype)initWithOnlineTypeName:(NSString *)onlineTypeName projectFullPath:(NSString *)projectFullPath withDictionary:(NSMutableDictionary *)dictionary;

- (void)appendProjectTypeDictionary:(NSMutableDictionary *)dictionary;
- (void)appendProjectType:(ABProjectType *)projectType;
@end