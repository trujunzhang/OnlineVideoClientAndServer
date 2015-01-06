//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SOThumbnailInfo;


@interface MobileThumbnailCacheDirectoryHelper : NSObject

+ (SOThumbnailInfo *)checkExistAndSaveForThumbnailInfoWithFileInfoID:(NSString*)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;

@end