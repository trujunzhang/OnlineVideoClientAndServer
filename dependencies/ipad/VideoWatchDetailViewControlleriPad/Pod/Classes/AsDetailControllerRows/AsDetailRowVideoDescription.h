//
//  AsDetailRowVideoDescription.h
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncDisplayKit.h"


@interface AsDetailRowVideoDescription : ASCellNode

- (instancetype)initWithVideo:(id)videoCache withTableWidth:(CGFloat)tableViewWidth;

@end
