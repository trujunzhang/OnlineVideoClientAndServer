//
//  YoutubePopUpTableViewController.m
//  TubeIPadApp
//
//  Created by djzhang on 11/21/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YoutubePopUpTableViewController.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface YoutubePopUpTableViewController ()<ASTableViewDataSource, ASTableViewDelegate> {
   ASTableView * _tableView;
}
@property(strong, nonatomic) NSMutableArray * ParsingArray;
@end


@implementation YoutubePopUpTableViewController


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view.
   _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
   _tableView.asyncDataSource = self;
   _tableView.asyncDelegate = self;
   [self.view addSubview:_tableView];
}


- (void)viewWillLayoutSubviews {
   _tableView.frame = self.view.bounds;
}


- (void)resetTableSource:(NSMutableArray *)array {
   self.ParsingArray = array;
   [_tableView reloadData];
}


- (void)empty {
   [self resetTableSource:[[NSMutableArray alloc] init]];
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.ParsingArray.count;
}


- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
   ASTextCellNode * node = [[ASTextCellNode alloc] init];
   node.text = self.ParsingArray[indexPath.row];
   node.backgroundColor = [UIColor whiteColor];

   return node;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString * value = self.ParsingArray[indexPath.row];
   [self.popupDelegate didSelectRowWithValue:value];
}


@end
