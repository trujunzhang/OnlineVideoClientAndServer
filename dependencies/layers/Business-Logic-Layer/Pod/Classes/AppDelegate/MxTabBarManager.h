#import <UIKit/UIKit.h>


@interface MxTabBarManager : NSObject

+ (MxTabBarManager *)sharedTabBarManager;

- (void)setLeftMenuControllerDelegate:(id)delegate;
- (NSInteger)getCurrentNavigationIndex;
- (UINavigationController *)currentNavigationController;
- (id)makeVideoDetailViewController:(id)video;

- (NSString *)getCurrentProjectNameIDString;
- (void)pushAndResetControllers:(NSArray *)controllers;
- (void)pushForYouTubePlayList:(id)playList withPlayListTitle:(NSString *)title;
- (void)pushWithVideo:(id)video;

- (void)callbackUpdateYoutubeChannelCompletion:(NSUInteger)index;
- (void)registerTabBarController:(id)controller withLeftViewController:(id)controller1 withTabbarControllerArray:(NSArray *)array;
- (BOOL)isSameTableBarSelectedIndex:(NSUInteger)tabBarSelectedIndex;
- (void)setCurrentOnlineVideoTypeID:(int)id;
@end
