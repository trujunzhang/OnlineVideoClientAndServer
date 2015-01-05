//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dispatch/queue.h>


@protocol FetchingOnlineInfoViewControllerDelegate<NSObject>
@optional
- (void)fetchingOnlineClientCompletion;
@end


@interface FetchingOnlineInfoViewController : UIViewController
@property(nonatomic, weak) id<FetchingOnlineInfoViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<FetchingOnlineInfoViewControllerDelegate>)delegate;

@end