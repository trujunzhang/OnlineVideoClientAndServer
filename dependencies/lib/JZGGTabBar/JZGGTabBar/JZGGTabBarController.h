//
//  VITabBarController.h
//  Vinoli
//
//  Created by Nicolas Goles on 5/16/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZGGTabBarControllerDelegate;
@class JZGGTabBar;


@interface JZGGTabBarController : UIViewController
@property (nonatomic, strong) JZGGTabBar *tabBarView;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id<JZGGTabBarControllerDelegate> delegate;
@property (nonatomic, assign) BOOL debug;

- (instancetype)initWithTabBarView:(JZGGTabBar *)tabBarView;

@end


@protocol JZGGTabBarControllerDelegate<NSObject>
@optional
- (BOOL)ggTabBarController:(JZGGTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

- (void)ggTabBarController:(JZGGTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end
