//
//  LeftRevealHelper.h
//  IOSTemplate
//
//  Created by djzhang on 11/4/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

@class SWRevealViewController;


@interface LeftRevealHelper : NSObject

@property (nonatomic) BOOL isRearOpen;
@property (nonatomic) NSUInteger lastTabBarSelectedIndex;
@property (nonatomic) BOOL isLastTabBarSelectedInRoot;


+ (LeftRevealHelper *)sharedLeftRevealHelper;

- (void)toggleReveal;

- (void)closeLeftMenu;

- (void)closeLeftMenuAndNoRearOpen;

- (void)openLeftMenuAndRearOpen;

- (void)openLeftMenu;

- (void)registerRevealController:(SWRevealViewController *)controller;

- (void)beginTabBarToggleWithSelectedIndex:(NSUInteger)selectedIndex withViewCount:(NSUInteger)count;

- (void)endTabBarToggleWithSelectedIndex:(NSUInteger)selectedIndex;
@end
