//
//  AnimatedContentsDisplayLayer.m
//  Layers
//
//  Created by djzhang on 11/25/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "AnimatedContentsDisplayLayer.h"


@implementation AnimatedContentsDisplayLayer


- (id<CAAction>)actionForKey:(NSString *)event {
   id<CAAction> action = [super actionForKey:event];
   if (action)
      return action;

   if ([event isEqualToString:@"contents"] && self.contents == nil) {
      CATransition * transition = [[CATransition alloc] init];
      transition.duration = 0.6;
      transition.type = kCATransitionFade;
      return transition;
   }

   return nil;
}


@end
