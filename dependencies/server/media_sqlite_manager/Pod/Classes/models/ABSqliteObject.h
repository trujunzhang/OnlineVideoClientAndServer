//
// Created by djzhang on 12/26/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+PJR.h"


@interface ABSqliteObject : NSObject

@property(copy) NSString * sqliteObjectID;
@property(copy) NSString * sqliteObjectName;
@property(copy) NSString * objectFullPath;

@property(strong) NSMutableArray * sqliteObjectArray;

- (instancetype)initWithSqliteObjectID:(NSString*)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath;
- (instancetype)initWithSqliteObjectID:(NSString *)sqliteObjectID sqliteObjectName:(NSString *)sqliteObjectName;


@property(strong) NSMutableArray * lastsubDirectoryListsArray;

- (NSMutableDictionary *)getUpdateDictionary;
- (NSMutableDictionary *)getInsertDictionary;

- (void)appendSqliteObjectToArray:(id)sqliteObject;
- (NSString *)sqlStringSerializationForUpdate;
- (NSString *)sqlStringSerializationForInsert;

+ (NSString *)getSqlStringSerializationForFilter:(NSMutableDictionary *)filterDictionary;

- (void)updateSqliteObject:(ABSqliteObject *)object;

- (NSString *)makeObjectFullPath:(NSString *)parentFullPath;

- (id)checkExistInSubDirectoryWithObjectName:(NSString *)sqliteObjectName;

@end