//
//  YoutubeFooterView.h
//  IOSTemplate
//
//  Created by djzhang on 11/10/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeFooterView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (void)startAnimation;
- (void)stopAnimation;
@end
