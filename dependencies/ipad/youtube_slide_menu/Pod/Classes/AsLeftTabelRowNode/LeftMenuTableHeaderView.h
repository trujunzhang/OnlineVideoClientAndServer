//
//  LeftMenuTableHeaderView.h
//  STCollapseTableViewDemo
//
//  Created by djzhang on 11/3/14.
//  Copyright (c) 2014 iSofTom. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LeftMenuTableHeaderView : UIView

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *expandButton;

- (void)setupUI:(NSString *)title;
@end
