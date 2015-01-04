//
//  YoutubePopUpTableViewController.h
//  TubeIPadApp
//
//  Created by djzhang on 11/21/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface YoutubePopUpViewControllerBase : UIViewController


- (void)showPopupDialog:(UIBarButtonItem *)item;
- (void)hidePopup;

- (void)cleanUpContent;
- (void)reloadContent:(NSArray *)array;
@end
