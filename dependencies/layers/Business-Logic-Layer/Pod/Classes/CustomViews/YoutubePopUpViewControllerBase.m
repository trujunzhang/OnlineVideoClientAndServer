//
//  YoutubePopUpViewControllerBase.m
//  TubeIPadApp
//
//  Created by djzhang on 11/21/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "YoutubePopUpViewControllerBase.h"
#import "YoutubePopUpTableViewController.h"


@interface YoutubePopUpViewControllerBase ()<UIPopoverControllerDelegate, YoutubePopUpTableViewDelegate> {
   YoutubePopUpTableViewController * _popUpTableViewController;
   UIPopoverController * _popover;
}


@end


@implementation YoutubePopUpViewControllerBase



- (void)viewDidLoad {
   [super viewDidLoad];

   _popUpTableViewController = [[YoutubePopUpTableViewController alloc] init];
   _popUpTableViewController.popupDelegate = self;
}


#pragma mark -
#pragma mark


- (void)hidePopup {
   if (_popover) {
      [_popover dismissPopoverAnimated:YES];
      _popover = nil;
   }

}


- (void)showPopupDialog:(UIBarButtonItem *)item {
   if (_popover)
      return;

   _popover = [[UIPopoverController alloc] initWithContentViewController:_popUpTableViewController];
   _popover.delegate = self;

   [_popover presentPopoverFromBarButtonItem:item
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
}


#pragma mark -
#pragma mark


- (void)cleanUpContent {
   [_popUpTableViewController empty];
}


- (void)reloadContent:(NSArray *)array {
   [_popUpTableViewController resetTableSource:array];
}


#pragma mark - Popover Controller Delegate


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
   _popover = nil;
}


@end
