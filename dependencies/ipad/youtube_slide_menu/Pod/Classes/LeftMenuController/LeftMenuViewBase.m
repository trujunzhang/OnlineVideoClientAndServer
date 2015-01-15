//
//  LeftMenuViewBase.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LeftMenuViewBase.h"
#import "UserInfoView.h"
#import "LeftMenuItemTree.h"
#import "LeftMenuTableHeaderView.h"
#import "YoutubeParser.h"
#import "MxTabBarManager.h"


@interface LeftMenuViewBase ()<UserInfoViewSigningOutDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) ASImageNode *imageNode;

@end


@implementation LeftMenuViewBase


- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(self.baseTableView, @"not found uitableview instance!");

    _imageNode = [[ASImageNode alloc] init];
    _imageNode.image = [UIImage imageNamed:@"mt_side_menu_bg"];

    _imageNode.frame = self.view.frame;// used
    _imageNode.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;


    [self.view addSubview:_imageNode.view];
    [self.view addSubview:self.baseTableView];
}


- (void)setCurrentTableView:(UITableView *)tableView {
    self.baseTableView = tableView;

    self.baseTableView.backgroundColor = [UIColor clearColor];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.showsVerticalScrollIndicator = NO;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//   [self togglePageViewController:0 rowIndex:0];   // test
}


- (void)viewWillLayoutSubviews {

}


#pragma mark -
#pragma mark setup


- (void)makeDefaultTableSections { // initialize once
    // 1  make section array
    self.tableSectionArray = [LeftMenuItemTree getSignOutMenuItemTreeArray];

    // 2 section header titles
    self.headers = [[NSMutableArray alloc] init];
    for (int i = 0;i < [self.tableSectionArray count];i++) {
        LeftMenuItemTree *menuItemTree = self.tableSectionArray[i];

        LeftMenuTableHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableHeaderView"
                                                                         owner:nil
                                                                       options:nil] lastObject];
        [header setupUI:menuItemTree.title];
        [self.headers addObject:header];
    }

}


- (void)togglePageViewController:(NSInteger)sectionIndex rowIndex:(NSInteger)rowIndex {
    LeftMenuItemTree *menuItemTree = self.tableSectionArray[sectionIndex];
    YTYouTubeChannel *line = menuItemTree.rowsArray[rowIndex];

    [self.delegate endToggleLeftMenuEventForChannelPageWithChannelId:[YoutubeParser getChannelSnippetId:line]
                                                           withTitle:[YoutubeParser getChannelSnippetTitle:line]
                                                     projectFullPath:[YoutubeParser getChannelProjectFullPath:line]];
}


#pragma mark -
#pragma mark Async refresh Table View


- (void)defaultRefreshForSubscriptionList {
    [self makeDefaultTableSections];

    [self leftMenuReloadTable];
}


- (void)insertSubscriptionRowsAfterFetching:(NSArray *)subscriptionList {
    [LeftMenuItemTree reloadSubscriptionItemTree:subscriptionList inSectionArray:self.tableSectionArray];

    [self leftMenuUpdateSubscriptionSection:subscriptionList];
}


- (void)refreshChannelInfo {
    [self defaultRefreshForSubscriptionList];
}


@end
