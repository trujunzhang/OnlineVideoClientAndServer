#import "YTVideoDetailViewController.h"

#import "YKYouTubeVideo.h"
#include "YoutubeParser.h"
#import "YTAsVideoDetailViewController.h"
#import "GGTabBarController.h"
#import "GGLayoutStringTabBar.h"
#import "CollectionConstant.h"
#import "YKDirectVideo.h"


@interface YTVideoDetailViewController ()<YoutubeCollectionNextPageDelegate, GGTabBarControllerDelegate> {
   NSArray * _lastControllerArray;
   YTYouTubeVideoCache * _detailVideo;

   YKDirectVideo * _directVideo;

   YTAsVideoDetailViewController * _videoHorizontalDetailController;
   YTAsVideoDetailViewController * _videoVerticalDetailController;
}

@property(strong, nonatomic) IBOutlet UIView * videoPlayViewContainer;
@property(strong, nonatomic) IBOutlet UIView * detailViewContainer;
@property(strong, nonatomic) IBOutlet UIView * tabBarViewContainer;


@property(nonatomic, strong) UIViewController * selectedController;


@property(nonatomic, strong) GGTabBarController * videoTabBarController;

@property(nonatomic, strong) UIViewController * firstViewController;
@property(nonatomic, strong) UIViewController * secondViewController;
@property(nonatomic, strong) YTCollectionViewController * thirdViewController;

@end


@implementation YTVideoDetailViewController

#pragma mark -
#pragma mark - UIView cycle


- (instancetype)initWithVideo:(id)video {
   self = [super init];
   if (self) {
      _detailVideo = video;
   }

   return self;
}


- (void)viewDidLoad {
   [super viewDidLoad];

   // Do any additional setup after loading the view, typically from a nib.
   [self initViewControllers];

//   if (debugCollectionViewToDetail == NO)
   [self setupPlayer:self.videoPlayViewContainer];  //used

   self.title = [YoutubeParser getVideoSnippetTitle:_detailVideo];

//   [self executeRefreshTask];// test
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.

}


- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];


}


- (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];

   // Beware, viewWillDisappear: is called when the player view enters full screen on iOS 6+
//   if ([self isMovingFromParentViewController])
//      [_directVideo stop];
}


#pragma mark -
#pragma mark - setup UIView


- (void)initViewControllers {
   // 1
   self.firstViewController = [[UIViewController alloc] init];
   self.firstViewController.title = @"Comments";

   self.secondViewController = [[UIViewController alloc] init];
   self.secondViewController.title = @"More From";

   self.thirdViewController = [[YTCollectionViewController alloc] initWithNextPageDelegate:self
                                                                                 withTitle:@"Suggestions"
                                                                      withProjectListArray:nil];
   self.thirdViewController.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"2", nil];

//   [self.thirdViewController fetchSuggestionListByVideoId:[YoutubeParser getWatchVideoId:_detailVideo]];

   // 2
   _videoHorizontalDetailController = [[YTAsVideoDetailViewController alloc] initWithVideo:_detailVideo];
   _videoVerticalDetailController = [[YTAsVideoDetailViewController alloc] initWithVideo:_detailVideo];
}


- (void)cleanupContainer:(UIView *)parentView {
   NSArray * array = [parentView subviews];
   for (UIView * childView in array) {
      [childView removeFromSuperview];
   }
}


- (void)makeTabBarController:(UIView *)parentView withControllerArray:(NSArray *)controllerArray {
   [self cleanupContainer:parentView];

   GGTabBar * topTabBar = [[GGLayoutStringTabBar alloc] initWithFrame:CGRectZero
                                                      viewControllers:controllerArray
                                                                inTop:YES
                                                        selectedIndex:controllerArray.count - 1
//                                                        selectedIndex:0
                                                          tabBarWidth:0];

   GGTabBarController * tabBarController = [[GGTabBarController alloc] initWithTabBarView:topTabBar];
   tabBarController.delegate = self;

   CGRect rect = parentView.bounds;
   tabBarController.view.frame = rect;// used

   // 3
   self.videoTabBarController = tabBarController;
   [parentView addSubview:self.videoTabBarController.view];
}


- (NSArray *)getTabBarControllerArray {
   UIInterfaceOrientation toInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
   BOOL isPortrait = (toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
   if (isPortrait) {
      NSArray * array = @[
       _videoVerticalDetailController,
       self.firstViewController,
       self.secondViewController,
       self.thirdViewController,
      ];
      return array;
   } else {
      return @[
       self.firstViewController,
       self.secondViewController,
       self.thirdViewController,
      ];
   }

   return nil;
}


- (void)selectDetailViewControllerInHorizontal:(UIViewController *)viewController {
   UIView * presentedView = [self.detailViewContainer.subviews firstObject];
   if (presentedView) {
      [presentedView removeFromSuperview];
   }

   viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
   [self.detailViewContainer addSubview:viewController.view];
   [self fitView:viewController.view intoView:self.detailViewContainer];
}


- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView {
   NSDictionary * viewsDictionary = @{ @"detailView_Container" : toPresentView };

   [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[detailView_Container]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary]];

   [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailView_Container]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary]];
}


- (void)setupPlayer:(UIView *)pView {
   [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

}


#pragma mark -
#pragma mark Rotation stuff


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];

   [self updateLayout:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)updateLayout:(UIInterfaceOrientation)toInterfaceOrientation {
   BOOL isPortrait = (toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);


   if (isPortrait) {// 4
      // 1  UIView contains
      // 2  layout
      [self setupVerticalLayout];
   } else {// 3
      // 1  UIView contains
//      [self selectDetailViewControllerInHorizontal:_videoHorizontalDetailController];
      // 2 layout
      [self setupHorizontalLayout];
   }

//   NSArray * array = [self getTabBarControllerArray];
//   if (_lastControllerArray && (array.count != _lastControllerArray.count)) {
//      _lastControllerArray = nil;
//   }
//   if (_lastControllerArray == nil) {
//
//      _lastControllerArray = array;
//
//      [self makeTabBarController:self.tabBarViewContainer withControllerArray:array];
//      [self.thirdViewController.view setNeedsLayout];
//   }

}


- (void)setupHorizontalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusBarHeight = statusRect.size.height;
   CGFloat navBarHeight = 44;
   CGFloat topHeight = statusBarHeight + navBarHeight;
   CGFloat tabBarHeight = 50;

   CGFloat aHaflWidth = self.view.frame.size.width / 2;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabBarHeight;

   CGRect rect = self.videoPlayViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayViewContainer.frame = rect;

   rect = self.detailViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight / 2;
   self.detailViewContainer.frame = rect;

   rect = self.tabBarViewContainer.frame;
   rect.origin.x = aHaflWidth;
   rect.origin.y = topHeight;
   rect.size.width = aHaflWidth;
   rect.size.height = aHeight;
   self.tabBarViewContainer.frame = rect;
}


- (void)setupVerticalLayout {
   CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
   CGFloat statusbarHeight = statusRect.size.height;
   CGFloat navbarHeight = 44;
   CGFloat topHeight = statusbarHeight + navbarHeight;
   CGFloat tabbarHeight = 50;

   CGFloat aWidth = self.view.frame.size.width;
   CGFloat aHeight = self.view.frame.size.height - topHeight - tabbarHeight;

   CGRect rect = self.videoPlayViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.videoPlayViewContainer.frame = rect;

   rect = self.tabBarViewContainer.frame;
   rect.origin.x = 0;
   rect.origin.y = topHeight + aHeight / 2;
   rect.size.width = aWidth;
   rect.size.height = aHeight / 2;
   self.tabBarViewContainer.frame = rect;
}


#pragma mark -
#pragma mark GGTabBarControllerDelegate


- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
   return YES;
}


- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
   self.selectedController = viewController;
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
//   [self.thirdViewController fetchSuggestionListByVideoId:[YoutubeParser getWatchVideoId:_detailVideo]];
}


- (void)executeNextPageTask {
//   [self.thirdViewController fetchSuggestionListByPageToken];
}


@end
