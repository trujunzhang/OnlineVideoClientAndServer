//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+PJR.h"


@interface ABSqliteObject : NSObject

@property(assign) int sqliteObjectID;
@property(copy) NSString * sqliteObjectName;
@property(copy) NSString * projectFullPath;
- (instancetype)initWithSqliteObjectID:(int)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath;

@property(strong) NSMutableArray * lastsubDirectoryListsArray;

- (NSMutableDictionary *)getUpdateDictionary;
- (NSMutableDictionary *)getInsertDictionary;

- (NSString *)sqlStringSerializationForUpdate;
- (NSString *)sqlStringSerializationForInsert;

+ (NSString *)getSqlStringSerializationForFilter:(NSMutableDictionary *)filterDictionary;

- (void)updateSqliteObject:(ABSqliteObject *)object;


- (id)checkExistInSubDirectoryWithObjectName:(NSString *)sqliteObjectName;

@end