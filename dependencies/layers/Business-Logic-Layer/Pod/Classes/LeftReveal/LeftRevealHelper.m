//
//  LeftRevealHelper.m
//  IOSTemplate
//
//  Created by djzhang on 11/4/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//


#import "LeftRevealHelper.h"
#import "YoutubeConstants.h"

#import "SWRevealViewController.h"

LeftRevealHelper *instance;


@interface LeftRevealHelper () {
    SWRevealViewController *_revealController;

}
@end


@implementation LeftRevealHelper

+ (LeftRevealHelper *)sharedLeftRevealHelper {
    if(instance == nil) {
        instance = [[LeftRevealHelper alloc] init];
    }
    return instance;
}


#pragma mark -
#pragma mark -


- (void)registerRevealController:(SWRevealViewController *)controller {
    // 1
    _revealController = controller;

    // 2
    if(hasShowLeftMenu) {
//      self.isRearOpen = YES; // used
//      [self openLeftMenu];   // used
    }
}


#pragma mark -
#pragma mark -


- (void)toggleReveal {
    if(self.isRearOpen) {
        [self closeLeftMenu];
    } else {
        [self openLeftMenu];
    }
    self.isRearOpen = !self.isRearOpen;
}


- (void)closeLeftMenu {
    [_revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}


- (void)closeLeftMenuAndNoRearOpen {
    [self closeLeftMenu];
    self.isRearOpen = NO;
}


- (void)openLeftMenuAndRearOpen {
    [self openLeftMenu];
    self.isRearOpen = YES;
}


- (void)openLeftMenu {
    [_revealController setFrontViewPosition:FrontViewPositionRight animated:YES];
}


#pragma mark -
#pragma mark - 


- (void)beginTabBarToggleWithSelectedIndex:(NSUInteger)selectedIndex withViewCount:(NSUInteger)count {
    self.lastTabBarSelectedIndex = selectedIndex;
    self.isLastTabBarSelectedInRoot = (count == 1);
}


- (void)endTabBarToggleWithSelectedIndex:(NSUInteger)selectedIndex {
    if(selectedIndex != 0) {
        [self closeLeftMenu];
        return;
    }

    if(selectedIndex != self.lastTabBarSelectedIndex) {
        if(selectedIndex == 0) {
            if(self.isRearOpen) {
                [self openLeftMenu];
            }
        }
        return;
    }
    if(!self.isLastTabBarSelectedInRoot)
        return;

    if(selectedIndex == 0 && self.isLastTabBarSelectedInRoot && self.isRearOpen) {
        [self closeLeftMenuAndNoRearOpen];
        return;
    }

    [self toggleReveal];
}

@end
