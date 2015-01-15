//
//  LeftMenuTableHeaderView.m
//  STCollapseTableViewDemo
//
//  Created by djzhang on 11/3/14.
//  Copyright (c) 2014 iSofTom. All rights reserved.
//

#import "LeftMenuTableHeaderView.h"


@implementation LeftMenuTableHeaderView

- (void)setupUI:(NSString *)title {
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    self.titleLabel.text = title;
}

@end
