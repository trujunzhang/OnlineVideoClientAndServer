//
// Created by djzhang on 1/21/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "ABOnlineVideoTypeStore.h"
#import "ABOnlineVideoType.h"
#import "ABProjectName.h"
#import "ABProjectType.h"


@implementation ABOnlineVideoTypeStore {

}


- (NSMutableArray *)getTheSameVideoTypeArray {
    NSMutableArray *onlineVideoTypeArray = [[NSMutableArray alloc] init];
    NSString *objectName = @"Youtube.com";

    for (int i = 0;i < 2;i++) {
        ABOnlineVideoType *sqliteObject = [[ABOnlineVideoType alloc] initWithSqliteObjectName:objectName];
        [onlineVideoTypeArray addObject:sqliteObject];

        [self readOnlineTypeArrayByVideoTypeId:sqliteObject.sqliteObjectID
                                  toDictionary:sqliteObject.onlineTypeDictionary
                                         index:i];
    }

    return onlineVideoTypeArray;
}


- (void)readOnlineTypeArrayByVideoTypeId:(NSString *)onlineVideoTypeID toDictionary:(NSMutableDictionary *)dictionary index:(int)position {
    NSArray *projectTypeNames =
            @[
                    @[@"test1", @"test2"],
                    @[@"test1", @"test3"],
            ];
    NSArray *current = projectTypeNames[position];
    for (NSString *name in current) {
        ABProjectType *projectType = [[ABProjectType alloc] initWithSqliteObjectName:name];
        [dictionary setObject:projectType forKey:projectType.sqliteObjectName];
    }
}


@end