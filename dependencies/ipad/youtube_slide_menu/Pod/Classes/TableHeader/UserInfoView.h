//
//  UserInfoView.h
//  NIBMultiViewsApp
//
//  Created by djzhang on 10/27/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UserInfoViewSigningOutDelegate<NSObject>

@end


@interface UserInfoView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *userHeader;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *userTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *userEmail;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *logOutImage;

//"https://yt3.ggpht.com/-NvptLtFVHnM/AAAAAAAAAAI/AAAAAAAAAAA/glOMyY45o-0/s240-c-k-no/photo.jpg"
- (UIView *)bind;

@property (nonatomic, weak) id<UserInfoViewSigningOutDelegate> delegate;

@end
