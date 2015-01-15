//
// Created by djzhang on 1/2/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "ABObjectSortExample.h"
#import "ABProjectList.h"


@implementation ABObjectSortExample {

}

+ (NSMutableArray *)getABProjectListSortArray:(NSArray *)projectListNamesArray {

    NSMutableArray *abProjectListSortArray = [[NSMutableArray alloc] init];

    for (NSString *name in projectListNamesArray) {
        ABProjectList *projectList = [[ABProjectList alloc] init];
        projectList.sqliteObjectName = name;

        [abProjectListSortArray addObject:projectList];
    }

    return abProjectListSortArray;
}


+ (NSArray *)getABProjectNameArray {
    return @[
            @"03 Course Piano Lessons",
            @"10 Course Piano Lessons",
            @"01 Course Piano Lessons",
            @"11 Course Piano Lessons",
            @"02 Course Piano Lessons",
    ];
}
@end