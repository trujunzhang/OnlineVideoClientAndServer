//
//  YTLeftRowTableViewCell.h
//  Popping
//
//  Created by djzhang on 11/30/14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncDisplayKit.h"
#import "ASControlNode+Subclasses.h"
#import "ASDisplayNode+Subclasses.h"


@interface YTLeftRowTableViewCell : UITableViewCell
@property(nonatomic) CGSize const featureImageSizeOptional;
@property(nonatomic, strong) NSOperation * nodeConstructionOperation;
@property(nonatomic, strong) CALayer * contentLayer;
@property(nonatomic, strong) ASDisplayNode * containerNode;

- (void)bind:(NSString *)lineTitle withLineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage cellSize:(CGSize)cellSize nodeConstructionQueue:(NSOperationQueue *)nodeConstructionQueue;
@end
