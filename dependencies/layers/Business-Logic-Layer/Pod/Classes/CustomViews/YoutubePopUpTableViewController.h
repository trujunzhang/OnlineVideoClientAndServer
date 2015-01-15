//
//  YoutubePopUpTableViewController.h
//  TubeIPadApp
//
//  Created by djzhang on 11/21/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YoutubePopUpTableViewDelegate<NSObject>

@required
- (void)didSelectRowWithValue:(NSString *)value;

@end


@interface YoutubePopUpTableViewController : UIViewController

@property (nonatomic, strong) id<YoutubePopUpTableViewDelegate> popupDelegate;

- (void)resetTableSource:(NSMutableArray *)array;

- (void)empty;
@end
