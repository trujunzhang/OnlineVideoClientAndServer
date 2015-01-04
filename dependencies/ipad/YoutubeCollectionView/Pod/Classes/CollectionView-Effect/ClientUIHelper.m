//
// Created by djzhang on 12/12/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ClientUIHelper.h"
#import "HexColor.h"


@implementation ClientUIHelper {

}

+ (UIColor *)mainUIBackgroundColor {
   return [UIColor colorWithHexString:@"ebebeb"];
}


+ (UIView *)mainUIBackgroundView:(CGRect)containRect {
   UIImage * backgroundImage = [[UIImage imageNamed:@"background.png"] stretchableImageWithLeftCapWidth:1
                                                                                           topCapHeight:0];

   UIView * backgroundView = [[UIView alloc] initWithFrame:containRect];
   [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];

   return backgroundView;
}

@end