//
// Created by djzhang on 1/5/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MemoryDBHelper : NSObject

+ (MemoryDBHelper *)sharedInstance:(NSString *)onlineVideoTypePath;
- (void)cleanup;
@end