//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "MobileThumbnailCacheDirectoryHelper.h"
#import "UserCacheFolderHelper.h"
#import "MobileThumbnail.h"


@implementation MobileThumbnailCacheDirectoryHelper {

}


+ (MobileThumbnail *)getMobileThumbnailDBInstance {
   return [MobileThumbnail dbInstance:[UserCacheFolderHelper RealProjectDirectory]];
}


@end