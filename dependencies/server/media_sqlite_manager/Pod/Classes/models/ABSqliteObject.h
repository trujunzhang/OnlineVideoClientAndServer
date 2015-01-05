//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+PJR.h"


@interface ABSqliteObject : NSObject

@property(assign) int sqliteObjectID;
@property(copy) NSString * sqliteObjectName;

@property(copy) NSString * objectName;
@property(nonatomic, strong) id parentObject;
@property(nonatomic) BOOL hasParent;


- (NSMutableDictionary *)getUpdateDictionary;
- (NSMutableDictionary *)getInsertDictionary;

- (NSString *)sqlStringSerializationForUpdate;
- (NSString *)sqlStringSerializationForInsert;

- (void)updateSqliteObject:(ABSqliteObject *)object;

- (NSNumber *)getSortNumber;

@end