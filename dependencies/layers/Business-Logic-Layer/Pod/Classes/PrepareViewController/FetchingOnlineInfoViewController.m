//
// Created by djzhang on 12/31/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "FetchingOnlineInfoViewController.h"
#import "GYoutubeHelper.h"
#import "LeftRevealHelper.h"
#import "MxTabBarManager.h"
#import "FBShimmeringView.h"

static CGFloat kTextPadding = 100.0f;


@interface FetchingOnlineInfoViewController ()<GYoutubeHelperDelegate> {
   ASTextNode * _fetchingInfo;
   ASTextNode * _shuffleNode;
}
@end


@implementation FetchingOnlineInfoViewController {

}
- (instancetype)initWithDelegate:(id<FetchingOnlineInfoViewControllerDelegate>)delegate {
   self = [super init];
   if (self) {
      self.delegate = delegate;
      [GYoutubeHelper getInstance].delegate = self;

      [self initOnlineClientInfo];

      [self setupUI];

      self.view.backgroundColor = [UIColor whiteColor];
   }

   return self;
}


- (void)makeFetchInfoNodeAndShow:(NSString *)info {
   [_fetchingInfo.view removeFromSuperview];
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       _fetchingInfo = [self makeFetchInfoNode:info];
       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{
           [self layoutForFetchInfoNode];
//           [self addEffectFor:_fetchingInfo.view withViewFrame:_fetchingInfo.frame];
           [self.view addSubview:_fetchingInfo.view];
       });
   });
}


- (void)setupUI {
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       // attribute a string
       NSDictionary * attrs = @{
        NSFontAttributeName : [UIFont systemFontOfSize:22.0f],
        NSForegroundColorAttributeName : [UIColor redColor],
       };
       NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"Reload"
                                                                     attributes:attrs];

       // create the node
       _shuffleNode = [[ASTextNode alloc] init];
       _shuffleNode.attributedString = string;

       // configure the button
       _shuffleNode.userInteractionEnabled = YES; // opt into touch handling
       [_shuffleNode addTarget:self
                        action:@selector(buttonTapped:)
              forControlEvents:ASControlNodeEventTouchUpInside];

       // size all the things
       CGRect b = self.view.bounds; // convenience
       CGSize size = [_shuffleNode measure:CGSizeMake(b.size.width, FLT_MAX)];
       CGPoint origin = CGPointMake(roundf((b.size.width - size.width) / 2.0f), roundf((b.size.height - size.height) / 2.0f));
       _shuffleNode.frame = (CGRect) { origin, size };

       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{
           [self.view addSubview:_shuffleNode.view];
       });
   });

}


- (void)addEffectFor:(UIView *)view withViewFrame:(CGRect)viewFrame {
   FBShimmeringView * shimmeringView = [[FBShimmeringView alloc] initWithFrame:viewFrame];
   [self.view addSubview:shimmeringView];

   shimmeringView.contentView = view;

   shimmeringView.shimmering = YES;

}


- (ASTextNode *)makeFetchInfoNode:(NSString *)info {
   ASTextNode * node = [[ASTextNode alloc] init];
   NSDictionary * attrsNode = @{
    NSFontAttributeName : [UIFont systemFontOfSize:32.0f],
    NSForegroundColorAttributeName : [UIColor blueColor],
   };
   node.attributedString = [[NSAttributedString alloc] initWithString:info
                                                           attributes:attrsNode];
   [node measure:CGSizeMake(self.view.frame.size.width - kTextPadding, self.view.frame.size.height)];
   node.backgroundColor = [UIColor whiteColor];
   node.contentMode = UIViewContentModeRight;

   return node;
}


- (void)buttonTapped:(id)sender {
   [self initOnlineClientInfo];
}


- (void)viewDidLayoutSubviews {
   [super viewDidLayoutSubviews];
}


- (void)layoutForFetchInfoNode {
   CGRect rect = self.view.bounds;
   CGFloat dW = rect.size.width - kTextPadding;

   CGSize textNodeSize = _fetchingInfo.calculatedSize;
   CGFloat dY = (rect.size.height / 2.0f - textNodeSize.height) - 80;
   _fetchingInfo.frame = CGRectMake(roundf((dW - textNodeSize.width) / 2.0f), dY, textNodeSize.width, textNodeSize.height);
}


- (void)initOnlineClientInfo {

   SqliteResponseBlock sqliteResponseBlock = ^(NSObject * respObject) {
       [self.delegate fetchingOnlineClientCompletion];

       [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenuAndRearOpen];
       [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion:0];
   };

   [[GYoutubeHelper getInstance] initOnlineClient:sqliteResponseBlock];
}


#pragma mark -
#pragma mark GYoutubeHelperDelegate


- (void)showStepInfo:(NSString *)string {
   [self makeFetchInfoNodeAndShow:string];
}


@end