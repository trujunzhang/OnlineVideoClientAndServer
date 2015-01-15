//
//  YTLeftRowTableViewCell.m
//  Popping
//
//  Created by djzhang on 11/30/14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "YTLeftRowTableViewCell.h"
#import "AsyncDisplayKit.h"
#import "ASControlNode+Subclasses.h"
#import "ASDisplayNode+Subclasses.h"
#import "YTLeftRowTableViewCellNode.h"


@implementation YTLeftRowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


//MARK: Cell Reuse
- (void)prepareForReuse {
    [super prepareForReuse];

    NSOperation *operation = _nodeConstructionOperation;
    if(operation)
        [operation cancel];

    [_containerNode setDisplaySuspended:YES];
    [_contentLayer removeFromSuperlayer];
    _contentLayer = nil;
    _containerNode = nil;
}


- (void)bind:(NSString *)lineTitle withLineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage cellSize:(CGSize)cellSize nodeConstructionQueue:(NSOperationQueue *)nodeConstructionQueue {
    self.featureImageSizeOptional = cellSize;
    NSOperation *oldNodeConstructionOperation = _nodeConstructionOperation;
    if(oldNodeConstructionOperation)
        [oldNodeConstructionOperation cancel];


    NSOperation *newNodeConstructionOperation = [self nodeConstructionOperation:lineTitle
                                                                withLineIconUrl:lineIconUrl
                                                                  isRemoteImage:isRemoteImage];


    _nodeConstructionOperation = newNodeConstructionOperation;
    [nodeConstructionQueue addOperation:newNodeConstructionOperation];
}


- (NSOperation *)nodeConstructionOperation:(NSString *)lineTitle withLineIconUrl:(NSString *)lineIconUrl isRemoteImage:(BOOL)isRemoteImage {
    NSBlockOperation *nodeConstructionOperation = [[NSBlockOperation alloc] init];

    __weak __typeof__(self) weakSelf = self;
    void (^cellExecutionBlock)() = ^{
        if(nodeConstructionOperation.cancelled)
            return;

        __typeof__(self) strongSelf = weakSelf;
        if(strongSelf == nil) {
            return;
        }
        {

            YTLeftRowTableViewCellNode *containerNode =
                    [[YTLeftRowTableViewCellNode alloc]
                            initWithNodeCellSize:self.featureImageSizeOptional
                                       lineTitle:lineTitle
                                     lineIconUrl:lineIconUrl
                                   isRemoteImage:isRemoteImage];

            if(nodeConstructionOperation.cancelled)
                return;

            dispatch_async(dispatch_get_main_queue(), ^{
                NSBlockOperation *strongNodeConstructionOperation = strongSelf.nodeConstructionOperation;
                if(strongNodeConstructionOperation.cancelled)
                    return;

                if(strongSelf.nodeConstructionOperation != strongNodeConstructionOperation)
                    return;

                if(containerNode.displaySuspended)
                    return;

                //MARK: Node Layer and Wrap Up Section
                [strongSelf.contentView.layer addSublayer:containerNode.layer];
                [containerNode setNeedsDisplay];
                strongSelf.contentLayer = containerNode.layer;
                strongSelf.containerNode = containerNode;
            });
        }
    };

    [nodeConstructionOperation addExecutionBlock:cellExecutionBlock];
    [nodeConstructionOperation start];

    return nodeConstructionOperation;
}


@end
