//
// Created by djzhang on 12/10/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsCollectionChannelCellNode.h"
#import "YoutubeConstants.h"
#import "YTAsFirstChannelRowNode.h"
#import "YTAsSecondChannelRowNode.h"
#import "YTAsThirdChannelRowNode.h"


@interface YTAsCollectionChannelCellNode () {
    CGSize _kittenSize;
    YTYouTubePlayList *_nodePlayList;

    YTAsFirstChannelRowNode *_asFirstChannelRowNode;
    YTAsSecondChannelRowNode *_asSecondChannelRowNode;
    YTAsThirdChannelRowNode *_asThirdChannelRowNode;
}
@end


@implementation YTAsCollectionChannelCellNode {

}


- (instancetype)initWithCellNodeOfSize:(CGSize)cellSize withVideo:(id)nodeVideo {
    if(!(self = [super init]))
        return nil;

    _kittenSize = cellSize;
    _nodePlayList = nodeVideo;

    CGRect cellNodeRect = CGRectMake(0, 0, _kittenSize.width, COLLECTION_CELL_FIRST_HEIGHT);
    _asFirstChannelRowNode = [[YTAsFirstChannelRowNode alloc] initWithCellNodeRect:cellNodeRect
                                                                         withVideo:nodeVideo];

    cellNodeRect = CGRectMake(0, COLLECTION_CELL_FIRST_HEIGHT, _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondChannelRowNode = [[YTAsSecondChannelRowNode alloc] initWithCellNodeRect:cellNodeRect
                                                                           withVideo:nodeVideo];

    cellNodeRect = CGRectMake(0, COLLECTION_CELL_FIRST_HEIGHT + COLLECTION_CELL_SECOND_HEIGHT, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdChannelRowNode = [[YTAsThirdChannelRowNode alloc] initWithCellNodeRect:cellNodeRect
                                                                         withVideo:nodeVideo];

    [self addSubnode:_asFirstChannelRowNode];
    [self addSubnode:_asSecondChannelRowNode];
    [self addSubnode:_asThirdChannelRowNode];


    return self;
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return _kittenSize;
}


- (void)layout {
    CGRect cellNodeRect = CGRectMake(0, 0, _kittenSize.width, COLLECTION_CELL_FIRST_HEIGHT);
    _asFirstChannelRowNode.frame = cellNodeRect;

    cellNodeRect = CGRectMake(0, COLLECTION_CELL_FIRST_HEIGHT, _kittenSize.width, COLLECTION_CELL_SECOND_HEIGHT);
    _asSecondChannelRowNode.frame = cellNodeRect;

    cellNodeRect = CGRectMake(0, COLLECTION_CELL_FIRST_HEIGHT + COLLECTION_CELL_SECOND_HEIGHT, _kittenSize.width, COLLECTION_CELL_THIRD_HEIGHT);
    _asThirdChannelRowNode.frame = cellNodeRect;
}


@end