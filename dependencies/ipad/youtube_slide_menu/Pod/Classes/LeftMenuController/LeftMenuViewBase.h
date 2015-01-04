//
//  LeftMenuViewBase.h
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYoutubeRequestInfo.h"

@class LeftMenuItemTree;

//static CGFloat ROW_HEIGHT = 42;
static CGFloat ROW_HEIGHT = 48;
static const int TABLE_WIDTH = 258;


@protocol LeftMenuViewBaseDelegate<NSObject>
@optional
- (void)startToggleLeftMenuWithTitle:(NSString *)title withType:(YTPlaylistItemsType)playlistItemsType;
- (void)endToggleLeftMenuEventForChannelPageWithChannelId:(NSString *)channelId withTitle:(NSString *)title;
@end


@interface LeftMenuViewBase : UIViewController

@property(nonatomic, strong) NSArray * tableSectionArray;

@property(nonatomic, strong) NSMutableArray * headers;

- (void)setCurrentTableView:(UITableView *)tableView;

@property(nonatomic, strong) id<LeftMenuViewBaseDelegate> delegate;

- (void)togglePageViewController:(NSInteger)sectionIndex rowIndex:(NSInteger)rowIndex;
- (void)defaultRefreshForSubscriptionList;
- (void)insertSubscriptionRowsAfterFetching:(NSArray *)subscriptionList;
- (void)refreshChannelInfo;

- (void)leftMenuReloadTable;
- (void)leftMenuSignOutTable;

- (void)leftMenuUpdateSubscriptionSection:(NSArray *)subscriptionList;

@end
