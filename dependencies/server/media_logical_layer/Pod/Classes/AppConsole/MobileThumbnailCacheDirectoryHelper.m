//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileThumbnailCacheDirectoryHelper.h"
#import "UserCacheFolderHelper.h"
#import "MobileDBImage.h"
#import "SOThumbnailInfo.h"
#import "SOThumbnailInfo.h"


@implementation MobileThumbnailCacheDirectoryHelper {

}


+ (MobileDBImage *)getMobileThumbnailDBInstance {
   return [MobileDBImage dbInstance:[UserCacheFolderHelper RealProjectCacheDirectory]];
}


+ (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoIDProjectFullPath:(NSString *)fullPath {
   return [[self getMobileThumbnailDBInstance] checkExistForThumbnailInfoWithFileInfoIDProjectFullPath:fullPath];
}


+ (void)saveThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   [[self getMobileThumbnailDBInstance] saveThumbnailInfoWithFileInfoID:sqliteObjectID
                                                          fileInforName:sqliteObjectName
                                                        projectFullPath:fullPath

   ];
}
@end