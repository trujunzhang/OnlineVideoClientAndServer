//
//  VITabBar.h
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZGGTabBarDelegate;

static const NSInteger kSeparatorOffsetTag = 7000;
static const NSInteger kMarginSeparatorOffsetTag = 8000;


static CGFloat tabBarPadding = 0.0f;
static CGFloat separatorWidth = 2.0f;


@interface JZGGTabBar : UIView

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) id<JZGGTabBarDelegate> delegate;

@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) id selectedButton;

@property (nonatomic) BOOL inTop;

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex tabBarWidth:(CGFloat)tabBarWidth tabBarItemArrays:(NSMutableArray *)tabBarItemArrays;

- (void)startDebugMode;

@end


@protocol JZGGTabBarDelegate<NSObject>
- (void)tabBar:(JZGGTabBar *)tabBar didPressButton:(id)button atIndex:(NSUInteger)tabIndex;
@end
