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
   return [MobileDBImage dbInstance:[UserCacheFolderHelper RealProjectDirectory]];
}


+ (SOThumbnailInfo *)checkExistAndSaveForThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {

   [[self getMobileThumbnailDBInstance] test];

//   SOThumbnailInfo * thumbnailInfo = [[self getMobileThumbnailDBInstance] checkExistForThumbnailInfoWithFileInfoID:sqliteObjectID
//                                                                                                     fileInforName:sqliteObjectName
//                                                                                                   projectFullPath:fullPath];
//
//   if (thumbnailInfo == nil) {
//      [[self getMobileThumbnailDBInstance] saveThumbnailInfoWithFileInfoID:sqliteObjectID
//                                                             fileInforName:sqliteObjectName
//                                                           projectFullPath:fullPath
//
//      ];
//   }
//
//   return thumbnailInfo;


   return nil;
}
@end