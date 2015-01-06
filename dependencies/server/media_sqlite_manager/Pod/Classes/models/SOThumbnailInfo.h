//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABSqliteObject.h"


/**
*   thumbnailInfoID    :sqliteObjectID
*   fileInfoID:
*   sqliteObjectName   :fileInforName
*                      :objectFullPath
*/
@interface SOThumbnailInfo : ABSqliteObject

@property(assign) int fileInfoID;

@end