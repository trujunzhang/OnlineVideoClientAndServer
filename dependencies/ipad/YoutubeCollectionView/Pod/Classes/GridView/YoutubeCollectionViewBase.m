//
//  YoutubeCollectionViewBase.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/15/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "YTVideoDetailViewController.h"
#import "GYoutubeHelper.h"
#import "HexColor.h"
#import "YoutubeCollectionViewBase.h"
#import "YTAsRowNode.h"
#import "ClientUIHelper.h"
#import "MxTabBarManager.h"
#import "SqliteManager.h"


@interface YoutubeCollectionViewBase () {
   BOOL isFirstRequest;
   GYoutubeRequestInfo * _youtubeRequestInfo;
   NSMutableArray * _projectListArray;
}

@property(nonatomic, strong) UIRefreshControl * refreshControl;
@property(strong, nonatomic) UICollectionView * baseCollectionView;

@property(nonatomic, strong) NSMutableDictionary * cellSizeDictionary;


@end


@implementation YoutubeCollectionViewBase

- (instancetype)initWithNextPageDelegate:(id<YoutubeCollectionNextPageDelegate>)nextPageDelegate withTitle:(NSString *)title withProjectListArray:(NSMutableArray *)projectListArray {
   self = [super init];
   if (self) {
      self.nextPageDelegate = nextPageDelegate;
      self.title = title;
      _projectListArray = projectListArray;
   }

   return self;
}


- (GYoutubeRequestInfo *)getYoutubeRequestInfo {
   if (_youtubeRequestInfo == nil) {
      _youtubeRequestInfo = [[GYoutubeRequestInfo alloc] init];
   }
   return _youtubeRequestInfo;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view.
   NSAssert(self.baseCollectionView, @"not set UICollectionVier instance!");
   NSAssert(self.nextPageDelegate, @"not found YoutubeCollectionNextPageDelegate!");
   NSAssert(self.numbersPerLineArray, @"not found numbersPerLineArray!");

   isFirstRequest = NO;
   self.cellSizeDictionary = [[NSMutableDictionary alloc] init];
   [self setupRefresh];
}


- (void)viewWillAppear:(BOOL)animated {
   [super viewDidAppear:animated];


   if (isFirstRequest == NO) {
      isFirstRequest = YES;
      [self tableWillAppear];
   }
}


- (void)dealloc {
   _youtubeRequestInfo = nil;
}


- (void)setUICollectionView:(UICollectionView *)collectionView {
   self.baseCollectionView = collectionView;

   self.baseCollectionView.backgroundView = [ClientUIHelper mainUIBackgroundView:self.view.bounds];
   [self.view addSubview:self.baseCollectionView];

   self.baseCollectionView.showsVerticalScrollIndicator = NO;
   self.baseCollectionView.directionalLockEnabled = YES;
}


#pragma mark -
#pragma mark all refresh methods


- (void)setupRefresh {
   self.refreshControl = [[UIRefreshControl alloc] init];
   self.refreshControl.tintColor = [UIColor redColor];
   [self.refreshControl addTarget:self
                           action:@selector(refreshControlAction)
                 forControlEvents:UIControlEventValueChanged];

   [self.baseCollectionView addSubview:self.refreshControl];
}


- (void)showTopRefreshing {
   [self.refreshControl beginRefreshing];
}


- (void)hideTopRefreshing {
   [self.refreshControl endRefreshing];
}


- (void)refreshControlAction {
   // Enter your code for request you are creating here when you pull the collectionView. When the request is completed then the collectionView go to its original position.
   [self performSelector:@selector(executeRefreshPerformEvent) withObject:(self) afterDelay:(4.0)];
}


- (void)executeRefreshPerformEvent {
   [self.nextPageDelegate executeRefreshTask];//used
//   [self.nextPageDelegate executeNextPageTask];//test
//   [self.refreshControl endRefreshing];//test
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Search events


- (void)search:(NSString *)text withItemType:(YTSegmentItemType)itemType {
   [self cleanup];

   [[self getYoutubeRequestInfo] resetRequestInfoForSearchWithItemType:itemType withQueryTeam:text];

}


- (void)searchByPageToken {

}


- (void)cleanup {
   [[self getYoutubeRequestInfo] resetInfo];
   [[self baseCollectionView] reloadData];
}


#pragma mark -
#pragma mark  Fetch Activity list by channelID


- (void)fetchActivityListByType:(YTSegmentItemType)itemType withChannelId:(NSString *)channelId {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";
   [self cleanup];

   [[self getYoutubeRequestInfo] resetRequestInfoForActivityListFromChannelWithChannelId:channelId];
}


- (void)fetchActivityListByPageToken {
   NSMutableArray * projectListArray = _projectListArray;

   [self updateAfterResponse:projectListArray];

}


- (void)updateAfterResponse:(NSArray *)array {
   [self.refreshControl endRefreshing];
   [self getYoutubeRequestInfo].isLoading = NO;

   NSUInteger lastRowCount = [self getYoutubeRequestInfo].videoList.count;
   [[self getYoutubeRequestInfo] appendNextPageData:array];

   if (lastRowCount == 0) {
      [self.baseCollectionView reloadData];
   } else {
      [self reloadTableView:array withLastRowCount:lastRowCount];
   }
}


#pragma mark -
#pragma mark  Fetch video list by channelID


- (void)fetchVideoListFromChannel {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";

   [self cleanup];

   [[self getYoutubeRequestInfo] resetRequestInfoForVideoListFromChannel];
}


- (void)fetchVideoListFromChannelByPageToken {
   NSMutableArray * projectListArray = [[SqliteManager sharedSqliteManager] getAllFileInfoListFromProjectList:_projectListArray];

   [self updateAfterResponse:projectListArray];
}


#pragma mark -
#pragma mark  Fetch playLists by channelID


- (void)fetchPlayListFromChannelWithChannelId:(NSString *)channelId {
//   channelId = @"UCl78QGX_hfK6zT8Mc-2w8GA";

   [self cleanup];

   [[self getYoutubeRequestInfo] resetRequestInfoForPlayListFromChannelWithChannelId:channelId];
}


- (void)fetchPlayListFromChannelByPageToken {
   NSMutableArray * projectListArray = [[SqliteManager sharedSqliteManager] getProgressionProjectList:_projectListArray];

   [self updateAfterResponse:projectListArray];
}


- (BOOL)checkRequest {
   if ([[self getYoutubeRequestInfo] isLoading]) {
      return YES;
   }

   if ([[self getYoutubeRequestInfo] hasNextPage]) {
      if ([[self getYoutubeRequestInfo] isLoading] == NO) {
         [self getYoutubeRequestInfo].isLoading = YES;
         return NO;
      }
   }

   return [[self getYoutubeRequestInfo] hasNextPage] == NO;
}


#pragma mark -
#pragma mark  Fetch Activity list by channelID


- (void)fetchPlayListByType:(YTPlaylistItemsType)playlistItemsType {
   [self cleanup];

//   NSLog(@" *** fetchPlayListByType = %d", [[self getYoutubeRequestInfo] hasNextPage]);
   [[self getYoutubeRequestInfo] resetRequestInfoForPlayList:playlistItemsType];
}


- (void)fetchPlayListByPageToken {

}


#pragma mark -
#pragma mark  Fetch suggestion list by videoID


- (void)fetchSuggestionListByVideoId:(NSString *)videoId {
//   videoId = @"mOQ5DzROpuo";
   [self cleanup];

   [[self getYoutubeRequestInfo] resetRequestInfoForSuggestionList:videoId];
}


- (void)fetchSuggestionListByPageToken {
   [self searchByPageToken];
}


#pragma mark - 
#pragma mark 


- (int)getCurrentColumnCount:(UIInterfaceOrientation)orientation {
   return [(self.numbersPerLineArray[UIInterfaceOrientationIsPortrait(orientation) ? 0 : 1]) intValue];
}


- (CGSize)cellSize {
   CGSize size;

   UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
   NSString * key = UIInterfaceOrientationIsPortrait(orientation) ? @"vertical" : @"horizontal";
   NSString * keyWidth = [NSString stringWithFormat:@"%@_width", key];
   NSString * keyHeight = [NSString stringWithFormat:@"%@_height", key];

   NSNumber * valueWidth = [self.cellSizeDictionary objectForKey:keyWidth];
   NSNumber * valueHeight = [self.cellSizeDictionary objectForKey:keyHeight];
   if (valueWidth && valueHeight) {
      size = CGSizeMake([valueWidth floatValue], [valueHeight floatValue]);
   } else {
      size = [self makeCellSize:orientation];
      NSNumber * aWidth = [NSNumber numberWithFloat:size.width];
      NSNumber * aHeight = [NSNumber numberWithFloat:size.height];
      [self.cellSizeDictionary setObject:aWidth forKey:keyWidth];
      [self.cellSizeDictionary setObject:aHeight forKey:keyHeight];
   }

   return size;
}


- (CGSize)makeCellSize:(UIInterfaceOrientation)orientation {
   int columnCount = [self getCurrentColumnCount:orientation];
   UICollectionViewLayout * layout = self.baseCollectionView.collectionViewLayout;

   UIEdgeInsets uiEdgeInsets = [self getUIEdgeInsetsForLayout];

   CGFloat mini_num_column_space = LAYOUT_MINIMUMCOLUMNSPACING;
//   CGFloat aFloat = layout.collectionViewContentSize.width;
   CGFloat aFloat = self.view.frame.size.width;

   CGFloat usableSpace =
    (aFloat
     - uiEdgeInsets.left - uiEdgeInsets.right
     - ((columnCount - 1) * mini_num_column_space)
    );

   CGFloat cellLength = usableSpace / columnCount;

   CGFloat cellHeight = [YTAsRowNode collectionCellHeight];

   return CGSizeMake(cellLength, cellHeight);
}


- (UIEdgeInsets)getUIEdgeInsetsForLayout {
   return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end






