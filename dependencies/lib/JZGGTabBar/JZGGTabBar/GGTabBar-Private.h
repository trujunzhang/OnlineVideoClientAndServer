//
//  VITabBarController-Private.h
//  Vinoli
//
//  Created by Nicolas Goles on 5/18/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "JZGGTabBar.h"

// Exposes methods for testing
@interface JZGGTabBar (Private)
- (NSString *)visualFormatConstraintStringWithButtons:(NSArray *)buttons
                                           separators:(NSArray *)separators
                                     marginSeparators:(NSArray *)marginSeparators;

- (NSDictionary *)visualFormatStringViewsDictionaryWithButtons:(NSArray *)buttons
                                                    separators:(NSArray *)separators
                                              marginSeparators:(NSArray *)marginSeparators;
@end
