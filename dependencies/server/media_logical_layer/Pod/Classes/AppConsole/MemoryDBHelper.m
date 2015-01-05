//
// Created by djzhang on 1/5/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MemoryDBHelper.h"
#import "MobileDB.h"
#import "MobileDBCacheDirectoryHelper.h"
#import "ABOnlineVideoType.h"

static MemoryDBHelper * _dbInstance;

static NSString * _onlineTypeName;
static NSString * _onlineVideoTypePath;


@interface MemoryDBHelper () {
   ABOnlineVideoType * _onlineVideoType;
}
@end


@implementation MemoryDBHelper {

}

- (instancetype)init {
   self = [super init];
   if (self) {

      NSDictionary * dictionary = @{
       @"onlineVideoTypeName" : _onlineTypeName,
       @"onlineVideoTypePath" : _onlineVideoTypePath,
      };

      NSMutableArray * mutableArray =
       [[MobileDBCacheDirectoryHelper getServerConsoleDBInstance] readOnlineVideoTypes:dictionary
                                                                           isReadArray:YES];

      if (mutableArray.count == 1) {
         _onlineVideoType = mutableArray[0];
      } else {
         _onlineVideoType = [[ABOnlineVideoType alloc] initWithOnlineTypeName:_onlineTypeName
                                                              projectFullPath:_onlineVideoTypePath
                                                               withDictionary:[[NSMutableDictionary alloc] init]];
      }
   }

   return self;
}


+ (MemoryDBHelper *)sharedInstanceWithTypeName:(NSString *)onlineTypeName withLocalPath:(NSString *)onlineVideoTypePath {
   if (
    (![_onlineVideoTypePath isEqualToString:onlineVideoTypePath]) ||
     (![_onlineTypeName isEqualToString:onlineTypeName])
    ) {
      _onlineTypeName = onlineTypeName;
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