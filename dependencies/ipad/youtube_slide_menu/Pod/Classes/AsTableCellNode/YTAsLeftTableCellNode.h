//
//  YTAsLeftTableCellNode.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AsyncDisplayKit.h"


@interface YTAsLeftTableCellNode : ASCellNode


- (instancetype)initWithNodeCellSize:(CGSize)nodeCellSize lineTitle:(NSString *)lineTitle lineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage;


@end
