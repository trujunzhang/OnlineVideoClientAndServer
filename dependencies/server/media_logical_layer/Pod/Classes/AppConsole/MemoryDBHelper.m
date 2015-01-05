//
// Created by djzhang on 1/5/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MemoryDBHelper.h"
#import "MobileDB.h"
#import "MobileDBCacheDirectoryHelper.h"

static MemoryDBHelper * _dbInstance;
static NSString * _onlineVideoTypePath;


@implementation MemoryDBHelper {

}

- (instancetype)init {
   self = [super init];
   if (self) {
      NSMutableArray * mutableArray =
       [[MobileDBCacheDirectoryHelper getServerConsoleDBInstance] readOnlineVideoTypes:
        @{ @"onlineVideoTypePath" : _onlineVideoTypePath }];
      int projectTypeId = 0;
//      NSMutableDictionary * dictionary = [[MobileDBCacheDirectoryHelper getServerConsoleDBInstance]
//       readDictionaryForProjectTypeWithProjectTypeId:projectTypeId
//                                          hasAllList:YES];
   }

   return self;
}


+ (MemoryDBHelper *)sharedInstance:(NSString *)onlineVideoTypePath {
   if ([_onlineVideoTypePath isEqualToString:onlineVideoTypePath] == NO) {
      _onlineVideoTypePath = onlineVideoTypePath;
      _dbInstance = nil;
   }

   if (!_dbInstance) {
      _dbInstance = [[MemoryDBHelper alloc] init];

   }

   return _dbInstance;
}


- (void)cleanup {

}
@end