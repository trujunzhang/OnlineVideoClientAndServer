//
// Created by djzhang on 1/1/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GenerateThumbnailTask : NSObject
+ (void)executeGenerateThumbnailTaskFrom:(NSString *)fileAbstractPath to:(NSString *)destinateFilePath;
+ (void)executeGenerateThumbnailTask:(NSString *)name from:(NSString *)in to:(NSString *)to;
@end