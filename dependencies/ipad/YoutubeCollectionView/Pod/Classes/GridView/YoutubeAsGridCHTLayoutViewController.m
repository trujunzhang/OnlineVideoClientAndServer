//
//  YoutubeAsGridCHTLayoutViewController.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YoutubeAsGridCHTLayoutViewController.h"
#import "YTAsCollectionVideoCellNode.h"
#import "YTAsCollectionChannelCellNode.h"



//#define ASGRIDROWCELL YTGridVideoCellNode
//#define ASGRIDROWCELL YTAsCollectionVideoCellNode
//#define ASGRIDROWCELL YTAsGridVideoCellNode

@interface YoutubeAsGridCHTLayoutViewController ()<ASCollectionViewDataSource, ASCollectionViewDelegate>
@property(strong, nonatomic) ASCollectionView * collectionView;
@end


@implementation YoutubeAsGridCHTLayoutViewController

- (void)viewDidLoad {
   [self makeCollectionView];
   [self setUICollectionView:self.collectionView];

   [self.collectionView reloadData];
   [super viewDidLoad];
}


#pragma mark -
#pragma mark reload table


- (void)reloadTableView:(NSArray *)array withLastRowCount:(NSUInteger)lastRowCount {
   int newCount = array.count;
   NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
   for (int i = 0; i < newCount; i++) {
      NSIndexPath * indexPath = [NSIndexPath indexPathForItem:(lastRowCount + i) inSection:0];
      [indexPaths addObject:indexPath];
   }

//   [self.collectionView appendNodesWithIndexPaths:indexPaths];
}


- (void)tableWillAppear { // used
   [self showTopRefreshing];
   [self.nextPageDelegate executeNextPageTask];
}


#pragma mark -
#pragma mark


- (void)makeCollectionView {
   if (!self.collectionView) {
      self.layout = [[UICollectionViewFlowLayout alloc] init];

      self.layout.sectionInset = [self getUIEdgeInsetsForLayout];
//      self.layout.footerHeight = DEFAULT_LOADING_MORE_HEIGHT;
//      self.layout.minimumColumnSpacing = LAYOUT_MINIMUMCOLUMNSPACING;
      self.layout.minimumInteritemSpacing = 10;
//      self.layout.delegate = self;

      self.collectionView = [[ASCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
      self.collectionView.asyncDataSource = self;
      self.collectionView.asyncDelegate = self;

      self.collectionView.allowsSelection = YES;
   }
}


#pragma mark - Life Cycle


- (void)dealloc {
   self.collectionView.asyncDataSource = nil;
   self.collectionView.asyncDelegate = nil;
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   CGRect rect = self.view.bounds;
   self.collectionView.frame = rect;
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return [self getYoutubeRequestInfo].videoList.count;
}


- (ASCellNode *)collectionView:(ASCollectionView *)collectionView nodeForItemAtIndexPath:(NSIndexPath *)indexPath {
   ASCellNode * node = [self getCellNodeAtIndexPath:indexPath];

   return node;
}


- (ASCellNode *)getCellNodeAtIndexPath:(NSIndexPath *)indexPath {

   ASCellNode * node;

   YTSegmentItemType itemType = [self getYoutubeRequestInfo].itemType;

   switch (itemType) {
      case YTSegmentItemList:  //YTYouTubePlayList
         node = [[YTAsCollectionChannelCellNode alloc]
          initWithCellNodeOfSize:[self cellSize]
                       withVideo:[[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row]];
         break;
      case YTSegmentItemVideos:
         node = [[YTAsCollectionVideoCellNode alloc]
          initWithCellNodeOfSize:[self cellSize]
                       withVideo:[[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row]];
         break;
      case YTSegmentItemProgression:
         node = [[YTAsCollectionChannelCellNode alloc]
          initWithCellNodeOfSize:[self cellSize]
                       withVideo:[[self getYoutubeRequestInfo].videoList objectAtIndex:indexPath.row]];
         break;
   }


   return node;
}


#pragma mark -
#pragma mark  UICollectionViewDelegate


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//   NSString * debug = @"debug";
//}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout


- (CGSize)collectionWaterfallView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return [self cellSize];
}


@end

