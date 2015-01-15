//
//  VideoDetailViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YTAsVideoDetailViewController.h"

#import "AsDetailRowVideoDescription.h"
#import "AsDetailRowChannelInfo.h"

static const NSInteger kLitterSize = 3;


@interface YTAsVideoDetailViewController ()<ASTableViewDataSource, ASTableViewDelegate> {
    ASTableView *_tableView;
    YTYouTubeVideoCache *_video;
}

@end


@implementation YTAsVideoDetailViewController


#pragma mark -
#pragma mark UIViewController.


- (instancetype)initWithVideo:(YTYouTubeVideoCache *)video {
    if(!(self = [super init]))
        return nil;

    _video = video;

    _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // KittenNode has its own separator
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.directionalLockEnabled = YES;

    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;

    self.title = @"info";

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:_tableView];
}


- (void)viewWillLayoutSubviews {

    CGRect rect = self.view.bounds;
    _tableView.frame = rect;
    [_tableView setNeedsLayout];
}


#pragma mark -
#pragma mark Kittens.


- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node;
    // special-case the first row
    switch (indexPath.row) {
        case 0:
            node = [[AsDetailRowChannelInfo alloc] initWithVideo:_video withTableWidth:self.view.frame.size.width];
            break;
        case 2:
            node = [[AsDetailRowVideoDescription alloc] initWithVideo:_video withTableWidth:self.view.frame.size.width];
            break;
    }

    return node;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kLitterSize;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // disable row selection
    return NO;
}


@end
