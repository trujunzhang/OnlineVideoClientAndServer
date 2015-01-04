//
//  YTLeftRowTableViewCellNode.h
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncDisplayKit.h"
#import "YoutubeConstants.h"


@interface YTLeftRowTableViewCellNode : ASDisplayNode

@property(nonatomic) CGSize const nodeCellSize;

@property(nonatomic, strong) NSString * lineTitle;
@property(nonatomic, strong) NSString * lineIconUrl;
@property(nonatomic) BOOL isRemoteImage;

- (instancetype)initWithNodeCellSize:(struct CGSize const)nodeCellSize lineTitle:(NSString *)lineTitle lineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage;



@end
