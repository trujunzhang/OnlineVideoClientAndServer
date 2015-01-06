//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileThumbnailCacheDirectoryHelper.h"
#import "UserCacheFolderHelper.h"
#import "MobileDBThumbnail.h"
#import "SOThumbnailInfo.h"
#import "SOThumbnailInfo.h"


@implementation MobileThumbnailCacheDirectoryHelper {

}


+ (MobileDBThumbnail *)getMobileThumbnailDBInstance {
   return [MobileDBThumbnail dbInstance:[UserCacheFolderHelper RealProjectDirectory]];
}


+ (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(int)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   return [[self getMobileThumbnailDBInstance] checkExistForThumbnailInfoWithFileInfoID:sqliteObjectName
                                                                          fileInforName:sqliteObjectName
                                                                        projectFullPath:fullPath];

   return nil;
}
@end