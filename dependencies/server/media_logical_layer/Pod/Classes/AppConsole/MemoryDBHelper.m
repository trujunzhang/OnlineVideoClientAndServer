//
// Created by djzhang on 1/5/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MemoryDBHelper.h"

static MemoryDBHelper * _dbInstance;
static NSString * _onlineVideoTypePath;


@implementation MemoryDBHelper {

}

+ (MemoryDBHelper *)sharedInstance:(NSString *)onlineVideoTypePath {
   if ([_onlineVideoTypePath isEqualToString:onlineVideoTypePath] == NO) {
      _dbInstance = nil;
   }
   if (!_dbInstance) {
      NSString * dbFilePath = [path stringByAppendingPathComponent:dataBaseName];
      MemoryDBHelper * MemoryDBHelper = [[MemoryDBHelper alloc] initWithFile:dbFilePath];
   }


   return _dbInstance;
}

@end