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


+ (SOThumbnailInfo *)checkExistAndSaveForThumbnailInfoWithFileInfoID:(NSString*)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath {
   SOThumbnailInfo * thumbnailInfo = [[self getMobileThumbnailDBInstance] checkExistForThumbnailInfoWithFileInfoID:sqliteObjectID
                                                                                                     fileInforName:sqliteObjectName
                                                                                                   projectFullPath:fullPath];

   if (thumbnailInfo == nil) {
      [[self getMobileThumbnailDBInstance] saveThumbnailInfoWithFileInfoID:sqliteObjectID
                                                             fileInforName:sqliteObjectName
                                                           projectFullPath:fullPath

      ];
   }

   return thumbnailInfo;
}
@end