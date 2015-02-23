//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncDisplayKit.h"
#import "ASControlNode+Subclasses.h"
#import "ASDisplayNode+Subclasses.h"

@interface YTAsCollectionVideoCellNode : ASCellNode


- (instancetype)initWithCellNodeOfSize:(CGSize)cellSize withVideo:(id)nodeVideo;

@end