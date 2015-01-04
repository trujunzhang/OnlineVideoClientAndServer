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
   ASTextNode * _reloadNode;
   ASTextNode * _offlineNode;

}
@end


@implementation FetchingOnlineInfoViewController {

}
- (instancetype)initWithDelegate:(id<FetchingOnlineInfoViewControllerDelegate>)delegate {
   self = [super init];
   if (self) {
      self.delegate = delegate;
      [GYoutubeHelper getInstance].delegate = self;

      [self initOnlineClientInfo:NO];

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
       _reloadNode = [self getButtonWithTitle:@"Reload" isLeft:YES];
       [_reloadNode addTarget:self
                       action:@selector(reloadButtonTapped:)
             forControlEvents:ASControlNodeEventTouchUpInside];

       _offlineNode = [self getButtonWithTitle:@"Update remote sqlite" isLeft:NO];
       [_offlineNode addTarget:self
                        action:@selector(offlineButtonTapped:)
              forControlEvents:ASControlNodeEventTouchUpInside];

       // self.view isn't a node, so we can only use it on the main thread
       dispatch_sync(dispatch_get_main_queue(), ^{
           [self.view addSubview:_reloadNode.view];
           [self.view addSubview:_offlineNode.view];
       });
   });

}


- (ASTextNode *)getButtonWithTitle:(NSString *)buttonTitle isLeft:(BOOL)isLeft {
   ASTextNode * shuffleNode = [[ASTextNode alloc] init];
   shuffleNode.attributedString = [[NSAttributedString alloc] initWithString:buttonTitle
                                                                  attributes:@{
                                                                   NSFontAttributeName : [UIFont systemFontOfSize:26.0f],
                                                                   NSForegroundColorAttributeName : [UIColor redColor],
                                                                  }];

   // configure the button
   shuffleNode.userInteractionEnabled = YES; // opt into touch handling

   // size all the things
   CGRect b = self.view.bounds; // convenience
   CGSize size = [shuffleNode measure:CGSizeMake(b.size.width, FLT_MAX)];


   CGFloat dX = b.size.width / 2.0f - size.width * 2;
   if (isLeft) {
      dX = b.size.width / 2.0f + size.width;
   }

   CGPoint origin = CGPointMake(roundf(dX), roundf((b.size.height - size.height) / 2.0f));
   shuffleNode.frame = (CGRect) { origin, size };

   return shuffleNode;
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


- (void)reloadButtonTapped:(id)sender {
   [self initOnlineClientInfo:NO];
}


- (void)offlineButtonTapped:(id)sender {
   [self initOnlineClientInfo:YES];
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


- (void)initOnlineClientInfo:(BOOL)checkVersion {

   SqliteResponseBlock sqliteResponseBlock = ^(NSObject * respObject) {
       [self.delegate fetchingOnlineClientCompletion];

       [[LeftRevealHelper sharedLeftRevealHelper] openLeftMenuAndRearOpen];
       [[MxTabBarManager sharedTabBarManager] callbackUpdateYoutubeChannelCompletion:0];
   };

   [[GYoutubeHelper getInstance] initOnlineClient:sqliteResponseBlock checkVersion:checkVersion];
}


#pragma mark -
#pragma mark GYoutubeHelperDelegate


- (void)showStepInfo:(NSString *)string {
   [self makeFetchInfoNodeAndShow:string];
}


@end