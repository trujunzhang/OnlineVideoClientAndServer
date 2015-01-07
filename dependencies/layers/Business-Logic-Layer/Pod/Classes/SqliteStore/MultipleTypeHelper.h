//
// Created by djzhang on 1/1/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ABOnlineVideoType;


@interface MultipleTypeHelper : NSObject

+ (NSMutableArray *)getSingleOnlineVideoTypesArray:(NSMutableArray *)array;

+ (void)copyOnlineVideoTypeDictionary:(NSMutableArray *)onlineTypeDictionary toLastProjectTypeDictionary:(ABOnlineVideoType *)to;
@end