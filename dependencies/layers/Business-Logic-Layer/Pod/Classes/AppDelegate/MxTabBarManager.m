#import <google-api-services-youtube/GYoutubeHelper.h>
#import "MxTabBarManager.h"
#import "YTVideoDetailViewController.h"
#import "LeftRevealHelper.h"
#import "ClientUIHelper.h"
#import "CollectionConstant.h"
#import "AsFileInfoVideoCollectionViewController.h"
#import "GGTabBarController.h"
#import "SqliteArraySortHelper.h"
#import "SqliteManager.h"


@interface MxTabBarManager () {
    GGTabBarController *_tabBarController;
    NSArray *_tabBarViewControllerArray;
    YTLeftMenuViewController *_leftViewController;

    NSMutableDictionary *_tabbarYouTubeChannelDictionary;
    NSInteger _tabBarSelectedIndex;
}


@end


@implementation MxTabBarManager

- (instancetype)init {
    self = [super init];
    if(self) {
        _tabbarYouTubeChannelDictionary = [[NSMutableDictionary alloc] init];
        [GYoutubeHelper getInstance].delegate = self;
    }

    return self;
}


+ (MxTabBarManager *)sharedTabBarManager {
    static MxTabBarManager *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[MxTabBarManager alloc] init];
    });

    return cache;
}


- (void)registerTabBarController:(GGTabBarController *)tabBarController withLeftViewController:(AsLeftMenuViewController *)leftViewController withTabbarControllerArray:(NSArray *)array {
    _tabBarController = tabBarController;
    _leftViewController = leftViewController;
    _tabBarViewControllerArray = array;
}


- (void)registerTabBarController:(UITabBarController *)tabBarController withLeftViewController:(id)leftViewController {

}


- (void)setLeftMenuControllerDelegate:(id)delegate {
    _leftViewController.delegate = delegate;
}


- (NSInteger)getCurrentNavigationIndex {
    return _tabBarSelectedIndex;
}


- (UINavigationController *)currentNavigationController {
    NSUInteger integer = _tabBarController.selectedIndex;
    return _tabBarViewControllerArray[integer];
}


- (YTVideoDetailViewController *)makeVideoDetailViewController:(id)video {
    YTVideoDetailViewController *controller = [[YTVideoDetailViewController alloc] initWithVideo:video];
    controller.view.backgroundColor = [ClientUIHelper mainUIBackgroundColor];

    return controller;
}


- (NSString *)getCurrentProjectNameIDString {
    return [NSString stringWithFormat:@"%i", 0]; // Todo djzhang
}


- (void)pushAndResetControllers:(NSArray *)controllers {
    UINavigationController *navigationController = [self currentNavigationController];

    navigationController.viewControllers = controllers;

    [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];
}


- (void)pushForYouTubePlayList:(ABProjectList *)playList withPlayListTitle:(NSString *)title {
    [[SqliteManager sharedSqliteManager] sortForFileInfoArrayIn:playList];
    NSMutableArray *projectListArray = @[playList];

    AsFileInfoVideoCollectionViewController *controller = [[AsFileInfoVideoCollectionViewController alloc] initWithTitle:title
                                                                                                    withProjectListArray:projectListArray];
    controller.numbersPerLineArray = [NSArray arrayWithObjects:@"3", @"4", nil];


    [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

    UINavigationController *navigationController = [self currentNavigationController];

    [navigationController pushViewController:controller animated:YES];
}


- (void)pushWithVideo:(id)video {
    [[LeftRevealHelper sharedLeftRevealHelper] closeLeftMenuAndNoRearOpen];

    YTVideoDetailViewController *controller = [self makeVideoDetailViewController:video];

    UINavigationController *navigationController = [self currentNavigationController];

    [navigationController pushViewController:controller animated:YES];
}


#pragma mark -
#pragma mark


- (void)callbackUpdateYoutubeChannelCompletion:(NSUInteger)tabBarSelectedIndex {
    _tabBarSelectedIndex = tabBarSelectedIndex;
    [_leftViewController refreshChannelInfo];
}


- (BOOL)isSameTableBarSelectedIndex:(NSUInteger)tabBarSelectedIndex {
    return (_tabBarSelectedIndex == tabBarSelectedIndex);
}


- (void)setCurrentOnlineVideoTypeID:(int)onlineVideoTypeID {

}
@end
