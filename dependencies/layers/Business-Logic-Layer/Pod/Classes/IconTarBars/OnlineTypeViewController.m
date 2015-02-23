//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineTypeViewController.h"

#import "LeftRevealHelper.h"
#import "MxTabBarManager.h"
#import "SqliteManager.h"

#import "YoutubeChannelPageViewController.h"


@interface OnlineTypeViewController ()<YoutubeCollectionNextPageDelegate, LeftMenuViewBaseDelegate> {
    YoutubeAsGridCHTLayoutViewController *_gridViewController;
    YTPlaylistItemsType _playlistItemsType;
}

@end


@implementation OnlineTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [[MxTabBarManager sharedTabBarManager] setLeftMenuControllerDelegate:self];

    self.navigationItem.leftBarButtonItem = [self getLeftBarButtonItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark LeftMenuViewBaseDelegate


- (void)startToggleLeftMenuWithTitle:(NSString *)title withType:(YTPlaylistItemsType)playlistItemsType {
    // 1
    YoutubeAsGridCHTLayoutViewController *gridViewController = [[YoutubeAsGridCHTLayoutViewController alloc] initWithNextPageDelegate:self
                                                                                                        withTitle:title
                                                                                             withProjectListArray:nil];
    gridViewController.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

    // 2
    gridViewController.navigationItem.leftBarButtonItem = [self getLeftBarButtonItem];

    // 3
    [[MxTabBarManager sharedTabBarManager] pushAndResetControllers:@[gridViewController]];

    // 4
    _playlistItemsType = playlistItemsType;
    _gridViewController = gridViewController;
    [_gridViewController fetchPlayListByType:playlistItemsType];
}


- (UIBarButtonItem *)getLeftBarButtonItem {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mt_side_tab_button"]
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(leftBarButtonItemAction:)];
    return barButtonItem;
}


- (void)endToggleLeftMenuEventForChannelPageWithChannelId:(NSString *)channelId withTitle:(NSString *)title projectFullPath:(NSString *)projectFullPath {
    // *** readRows{ABProjectList+ABProjectFileInfo-c2} with projectList.fullPath ***
    YoutubeChannelPageViewController *controller =
            [[YoutubeChannelPageViewController alloc] initWithChannelId:channelId
                                                              withTitle:title
                                                       projectListArray:[[SqliteManager sharedSqliteManager] getProjectListArray:channelId
                                                                                                                 projectFullPath:projectFullPath]];

    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mt_side_tab_button"]
                                                                                   style:UIBarButtonItemStyleBordered
                                                                                  target:self
                                                                                  action:@selector(leftBarButtonItemAction:)];

    [[MxTabBarManager sharedTabBarManager] pushAndResetControllers:@[controller]];
}


#pragma mark -
#pragma mark - Provided acction methods


- (void)leftBarButtonItemAction:(id)sender {
    [[LeftRevealHelper sharedLeftRevealHelper] toggleReveal];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
    [_gridViewController fetchPlayListByType:_playlistItemsType];
}


- (void)executeNextPageTask {
    [_gridViewController fetchPlayListByPageToken];
}

@end