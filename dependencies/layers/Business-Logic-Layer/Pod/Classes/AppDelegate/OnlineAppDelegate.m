//
//  OnlineAppDelegate.m
//  OnlineVideoClient
//
//  Created by djzhang on 12/27/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "OnlineAppDelegate.h"
#import "DebugUtils.h"


#import <SWRevealViewController/SWRevealViewController.h>

#import "LeftRevealHelper.h"
#import "CacheImageConstant.h"
#import "MxTabBarManager.h"
#import "CollectionConstant.h"
#import "GYoutubeHelper.h"
#import "GGTabBar.h"
#import "GGTabBarController.h"
#import "GGIconTabBar.h"
#import "OnlineTypeViewController.h"
#import "FetchingOnlineInfoViewController.h"
#import "SqliteManager.h"
#import "ABOnlineVideoType.h"
#import <Parse/Parse.h>

#import "NSString+PJR.h"


@interface OnlineAppDelegate ()<FetchingOnlineInfoViewControllerDelegate, GGTabBarControllerDelegate>

@end


@implementation OnlineAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    [self setupCommonTools:launchOptions];

    self.window.rootViewController = [[FetchingOnlineInfoViewController alloc] initWithDelegate:self];

    [self.window makeKeyAndVisible];

    return YES;
}


#pragma mark -
#pragma mark Setup Reveal view


- (UIViewController *)setupRevealViewController {
    // left controller
    YTLeftMenuViewController *leftViewController = [[YTLeftMenuViewController alloc] init];

    // right controller
    NSMutableArray *tabBarControllerArray = [self getTabBarControllerArray];
    GGTabBarController *ggTabBarController = [self makeTabBarControllerWithControllerArray:tabBarControllerArray];


    //6
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:leftViewController
                                                                                      frontViewController:ggTabBarController];
    revealController.delegate = self;

    [[LeftRevealHelper sharedLeftRevealHelper] registerRevealController:revealController];
    [[MxTabBarManager sharedTabBarManager] registerTabBarController:ggTabBarController
                                             withLeftViewController:leftViewController
                                          withTabbarControllerArray:tabBarControllerArray
    ];

    return revealController;
}


- (NSMutableArray *)getTabBarControllerArray {
    NSMutableArray *onlineVideoTypesArray = [[SqliteManager sharedSqliteManager] getOnlineVideoTypesArray];

    NSMutableArray *controllerArray = [[NSMutableArray alloc] init];

    for (ABOnlineVideoType *onlineVideoType in onlineVideoTypesArray) {
        OnlineTypeViewController *lyndaController = [[OnlineTypeViewController alloc] init];

        NSString *tabBarImageName = [self getTabbarImageName:onlineVideoType.sqliteObjectName];
        lyndaController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                                   image:[UIImage imageNamed:tabBarImageName]
                                                           selectedImage:[UIImage imageNamed:tabBarImageName]];

        UINavigationController *lyndaNavigationController = [[UINavigationController alloc] initWithRootViewController:lyndaController];
        [controllerArray addObject:lyndaNavigationController];
    }
    return controllerArray;
}


- (NSString *)getTabbarImageName:(NSString *)tabbarName {
    if([tabbarName containsString:@"Lynda"]) {
        return @"Lynda.png";
    } else if([tabbarName containsString:@"Youtube"]) {
        return @"youtube.png";
    }
    return @"global_normal";
}


- (GGTabBarController *)makeTabBarControllerWithControllerArray:(NSMutableArray *)controllerArray {
    GGTabBar *topTabBar = [[GGIconTabBar alloc] initWithFrame:CGRectZero
                                              viewControllers:controllerArray
                                                        inTop:NO
                                                selectedIndex:0
                                                  tabBarWidth:0];
    topTabBar.backgroundColor = [UIColor clearColor];

    GGTabBarController *tabBarController = [[GGTabBarController alloc] initWithTabBarView:topTabBar];
    tabBarController.view.backgroundColor = [UIColor whiteColor];

    tabBarController.delegate = self;

//   CGRect rect = parentView.bounds;
//   tabBarController.view.frame = rect;// used

    return tabBarController;
}


#pragma mark -
#pragma mark Setup common tools


- (void)setupCommonTools:(NSDictionary *)launchOptions {
    [self setupParse:launchOptions];
    [DebugUtils listAppHomeInfo];
    [DebugUtils setupLogFile];

    [YTCacheImplement removeAllCacheDiskObjects];
}


- (void)setupParse:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:@"8Id3t8ZCSPCD0iEtULgTk6Sq4W34rUcddIQa1UWo"
                  clientKey:@"BSOzdsLvkNpDugGQWBksKSKVLxyxJGsI5Y3Tp9gk"];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];


}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark FetchingOnlineInfoViewControllerDelegate


- (void)fetchingOnlineClientCompletion {
    self.window.rootViewController = [self setupRevealViewController];
}


#pragma mark -
#pragma mark GGTabBarControllerDelegate


- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    BOOL isSameTableBarSelectedIndex = [[MxTabBarManager sharedTabBarManager] isSameTableBarSelectedIndex:tabBarController.selectedIndex];

    if(isSameTableBarSelectedIndex) {
        [[LeftRevealHelper sharedLeftRevealHelper] toggleReveal];
    } else {
        [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenuAndRearOpen];
        [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion:tabBarController.selectedIndex];
    }

}


- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}


@end
