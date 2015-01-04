//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <media_logical_layer/UserCacheFolderHelper.h>
#import "MobileDBCacheDirectoryHelper.h"
#import "MobileDB.h"


@implementation MobileDBCacheDirectoryHelper {

}

+ (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath {
   [[MobileDB dbInstance:[UserCacheFolderHelper RealProjectCacheDirectory]] saveForOnlineVideoTypeDictionary:dictionary
                                                                                                    withName:onlineTypeName
                                                                                    whithOnlineVideoTypePath:onlineVideoTypePath
   ];
}


+ (BOOL)checkFileInfoExist:(NSString *)fileAbstractPath {
   return [[MobileDB dbInstance:[UserCacheFolderHelper RealProjectCacheDirectory]] checkFileInfoExist:fileAbstractPath];
}
@end