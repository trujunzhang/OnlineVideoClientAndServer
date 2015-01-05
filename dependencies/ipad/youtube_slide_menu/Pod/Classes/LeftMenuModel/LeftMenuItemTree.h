//
//  LeftMenuItemTree.h
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <google-api-services-youtube/GYoutubeRequestInfo.h>

typedef NS_ENUM (NSUInteger, LeftMenuItemTreeType) {
   // Playlist pop-up menu item tags.
    LMenuTreeUser = 0,
   LMenuTreeSubscriptions = 1,
   LMenuTreeCategories = 2,
};


@interface LeftMenuItemTree : NSObject

@property(nonatomic, copy) NSString * title;
@property(nonatomic, assign) LeftMenuItemTreeType itemType;
@property(nonatomic, strong) NSMutableArray * rowsArray;

@property(nonatomic) BOOL hideTitle;
@property(nonatomic) BOOL isRemoteImage;
@property(nonatomic, copy) NSString * cellIdentifier;


- (instancetype)initWithTitle:(NSString *)title itemType:(LeftMenuItemTreeType)type rowsArray:(NSMutableArray *)rowsArray hideTitle:(BOOL)hideTitle remoteImage:(BOOL)remoteImage;

+ (instancetype)getCategoriesMenuItemTree;

+ (instancetype)getSignInMenuItemTree;
+ (instancetype)getEmptySubscriptionsMenuItemTree;
+ (NSArray *)getSignOutMenuItemTreeArray;
+ (NSArray *)getSignInMenuItemTreeArray;
+ (NSArray *)cellIdentifierArray;
+ (NSArray *)defaultCategories;
+ (NSArray *)signUserCategories;

+ (NSString *)getTitleInRow:(id)line;
+ (NSString *)getThumbnailUrlInRow:(NSArray *)array;
+ (NSString *)getChannelIdUrlInRow:(NSArray *)array;
+ (YTPlaylistItemsType)getTypeInRow:(NSArray *)array;

+ (void)reloadSubscriptionItemTree:(NSArray *)subscriptionList inSectionArray:(NSArray *)sectionArray;
@end
