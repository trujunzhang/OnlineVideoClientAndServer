//
//  YoutubeChannelPageViewController.m
//  IOSTemplate
//
//  Created by djzhang on 11/12/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <google-api-services-youtube/GYoutubeHelper.h>
#import "YoutubeChannelPageViewController.h"
#import "YTAsyncYoutubeChannelTopCellNode.h"
#import "GGTabBarController.h"
#import "GGLayoutStringTabBar.h"
#import "SqliteManager.h"


@interface YoutubeChannelPageViewController ()<YoutubeCollectionNextPageDelegate, GGTabBarControllerDelegate> {
   NSMutableArray * _projectListArray;
}

@property(strong, nonatomic) IBOutlet UIView * topBannerContainer;
@property(strong, nonatomic) IBOutlet UIView * tabbarViewsContainer;


@property(nonatomic, strong) NSString * channelId;
@property(nonatomic, strong) YTYouTubeChannel * pageChannel;

@property(nonatomic, strong) YTAsyncYoutubeChannelTopCellNode * topBanner;
@property(nonatomic, strong) GGTabBarController * videoTabBarController;

@property(nonatomic, strong) YTCollectionViewController * selectedController;
@property(nonatomic) YTSegmentItemType selectedSegmentItemType;

@end


@implementation YoutubeChannelPageViewController


- (instancetype)initWithChannelId:(NSString *)channelId withTitle:(NSString *)title projectListArray:(NSMutableArray *)projectListArray {
   self = [super init];
   if (self) {
      self.channelId = channelId;
      _projectListArray = projectListArray;
      self.title = title;

      [self makeTopBanner:self.topBannerContainer];
   }

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view from its nib.
   [self makeSegmentTabs:self.tabbarViewsContainer];

   if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
      self.automaticallyAdjustsScrollViewInsets = NO;
   }
}


- (void)makeSegmentTabs:(UIView *)parentView {
   // 1
   NSMutableArray * tabBarControllers = [[NSMutableArray alloc] init];
   for (NSString * title in [GYoutubeRequestInfo getChannelPageSegmentTitlesArray]) {
      YTCollectionViewController * controller = [[YTCollectionViewController alloc] initWithNextPageDelegate:self
                                                                                                   withTitle:title
                                                                                        withProjectListArray:_projectListArray];

      controller.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];

      [tabBarControllers addObject:controller];
   }

   // 2
   GGTabBar * topTabBar = [[GGLayoutStringTabBar alloc] initWithFrame:CGRectZero
                                                      viewControllers:tabBarControllers
                                                                inTop:YES
                                                        selectedIndex:0
                                                          tabBarWidth:0];

   GGTabBarController * tabBarController = [[GGTabBarController alloc] initWithTabBarView:topTabBar];
   tabBarController.delegate = self;

   tabBarController.view.frame = parentView.bounds;// used
   tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

   self.videoTabBarController = tabBarController;
   [parentView addSubview:self.videoTabBarController.view];
}


- (void)makeTopBanner:(UIView *)parentView {

   // Create a new private queue
   dispatch_queue_t _backgroundQueue;
   _backgroundQueue = dispatch_queue_create("com.youtube.page.topcell", NULL);

   dispatch_async(_backgroundQueue, ^{

       self.topBanner = [[YTAsyncYoutubeChannelTopCellNode alloc] initWithChannel:self.pageChannel];

       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{

           self.topBanner.frame = parentView.bounds;// used
           self.topBanner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;// used

           [parentView addSubview:self.topBanner.view];
       });
   });
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   [self.selectedController.view setNeedsLayout];
   [self.topBanner setNeedsLayout];
}


#pragma mark -
#pragma mark GGTabBarControllerDelegate


- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
   return YES;
}


- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   if (self.selectedController == viewController)
      return;

   [self fetchListWithController:viewController withType:tabBarController.selectedIndex];
}


- (void)fetchListWithController:(YTCollectionViewController *)controller withType:(YTSegmentItemType)type {
   self.selectedController = controller;
   self.selectedSegmentItemType = type;

   [self executeRefreshTask];
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
   if ([self.selectedController getYoutubeRequestInfo].hasFirstFetch)
      return;

   NSString * channelId = self.channelId;
   switch (self.selectedSegmentItemType) {
      case YTSegmentItemList:
         [self.selectedController fetchActivityListByType:self.selectedSegmentItemType
                                            withChannelId:channelId];
         break;
      case YTSegmentItemVideos:
         [self.selectedController fetchVideoListFromChannel];
         break;
      case YTSegmentItemProgression:
         [self.selectedController fetchPlayListFromChannelWithChannelId:channelId];
         break;
   }
}


- (void)executeNextPageTask {
   switch (self.selectedSegmentItemType) {
      case YTSegmentItemList:
         [self.selectedController fetchActivityListByPageToken];
         break;
      case YTSegmentItemVideos:
         [self.selectedController fetchVideoListFromChannelByPageToken];
         break;
      case YTSegmentItemProgression:
         [self.selectedController fetchPlayListFromChannelByPageToken];
         break;
   }
}


@end
