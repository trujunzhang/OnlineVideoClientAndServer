//
//  VITabBarController.h
//  Vinoli
//
//  Created by Nicolas Goles on 5/16/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGTabBarControllerDelegate;
@class GGTabBar;


@interface GGTabBarController : UIViewController
@property(nonatomic, strong) GGTabBar * tabBarView;
@property(nonatomic, copy) NSArray * viewControllers;
@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, weak) id<GGTabBarControllerDelegate> delegate;
@property(nonatomic, assign) BOOL debug;
- (instancetype)initWithTabBarView:(GGTabBar *)tabBarView;

@end


@protocol GGTabBarControllerDelegate<NSObject>
@optional
- (BOOL)ggTabBarController:(GGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)ggTabBarController:(GGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end
