//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileThumbnailCacheDirectoryHelper.h"
#import "UserCacheFolderHelper.h"
#import "MobileDBThumbnail.h"


@implementation MobileThumbnailCacheDirectoryHelper {

}


+ (MobileDBThumbnail *)getMobileThumbnailDBInstance {
   return [MobileDBThumbnail dbInstance:[UserCacheFolderHelper RealProjectDirectory]];
}


@end