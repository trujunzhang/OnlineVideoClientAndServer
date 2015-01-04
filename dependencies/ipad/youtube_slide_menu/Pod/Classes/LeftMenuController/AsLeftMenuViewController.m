//
//  AsLeftMenuViewController.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//


#import "AsLeftMenuViewController.h"

#import "LeftMenuItemTree.h"
#import "YTAsLeftTableCellNode.h"
#import "YoutubeParser.h"
#import "AsTableViewHeaderNode.h"


@interface AsLeftMenuViewController ()<ASTableViewDataSource, ASTableViewDelegate>
@property(nonatomic, strong) ASTableView * tableView;


@end


@implementation AsLeftMenuViewController


- (instancetype)init {
   if (!(self = [super init]))
      return nil;

   self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
   self.tableView.asyncDataSource = self;
   self.tableView.asyncDelegate = self;

   self.tableView.allowsSelection = YES;

   return self;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1 + [self.headers count];
}


- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
   if (indexPath.section == 0 && indexPath.row == 0) {
      AsTableViewHeaderNode * node = [[AsTableViewHeaderNode alloc] init];
      return node;
   }

   LeftMenuItemTree * menuItemTree = self.tableSectionArray[indexPath.section - 1];

   YTYouTubeChannel * line = menuItemTree.rowsArray[indexPath.row];

   YTAsLeftTableCellNode * node =
    [[YTAsLeftTableCellNode alloc]
     initWithNodeCellSize:CGSizeMake(250, ROW_HEIGHT)
                lineTitle:[LeftMenuItemTree getTitleInRow:line]
              lineIconUrl:@"Autos"
            isRemoteImage:menuItemTree.isRemoteImage];

   return node;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if (section == 0) {
      return 1;
   }
   LeftMenuItemTree * menuItemTree = self.tableSectionArray[section - 1];

   return menuItemTree.rowsArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (section == 0) {
      return 0;
   }

   return 42;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   if (section > self.headers.count)
      return nil;
   if (section == 0) {
      return nil;
   }
   return [self.headers objectAtIndex:section - 1];
}


#pragma mark -
#pragma mark UITableViewDelegate


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
   return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSInteger sectionIndex = indexPath.section - 1;
   NSInteger rowIndex = indexPath.row;

   [self togglePageViewController:sectionIndex rowIndex:rowIndex];
}


#pragma mark -
#pragma mark


- (void)viewDidLoad {
   [self setCurrentTableView:self.tableView];
//   [self defaultRefreshForSubscriptionList];

   [super viewDidLoad];
}


- (void)viewWillLayoutSubviews {
   [super viewWillLayoutSubviews];

   _tableView.frame = self.view.bounds;
}


#pragma mark -
#pragma mark Overrides


- (void)leftMenuReloadTable {
   [_tableView reloadData];
}


- (void)leftMenuSignOutTable {

}


- (void)leftMenuUpdateSubscriptionSection:(NSArray *)subscriptionList {

}


@end
