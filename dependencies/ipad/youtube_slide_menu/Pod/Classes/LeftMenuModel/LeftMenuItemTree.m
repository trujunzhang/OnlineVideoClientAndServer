//
//  LeftMenuItemTree.m
//  STCollapseTableViewDemo
//
//  Created by Thomas Dupont on 09/08/13.
//  Copyright (c) 2013 iSofTom. All rights reserved.
//

#import "LeftMenuItemTree.h"
#import "GYoutubeRequestInfo.h"
#import "SqliteManager.h"
#import "YoutubeParser.h"
#import "MxTabBarManager.h"


@interface LeftMenuItemTree ()

@end


@implementation LeftMenuItemTree


- (instancetype)initWithTitle:(NSString *)title itemType:(LeftMenuItemTreeType)type rowsArray:(NSMutableArray *)rowsArray hideTitle:(BOOL)hideTitle remoteImage:(BOOL)remoteImage {
   self = [super init];
   if (self) {
      self.title = title;
      self.itemType = type;
      self.rowsArray = rowsArray;
      self.hideTitle = hideTitle;
      self.isRemoteImage = remoteImage;
      self.cellIdentifier = [LeftMenuItemTree cellIdentifierArray][type];
   }

   return self;
}


+ (NSMutableArray *)getSignOutMenuItemTreeArray {
   NSMutableArray * menuItemTreeArray = [[NSMutableArray alloc] init];

   NSInteger currentNavigationIndex = [[MxTabBarManager sharedTabBarManager] getCurrentNavigationIndex];
   // *** readRows{ABOnlineVideoType} ***
   NSArray * projectTypeArray = [[SqliteManager sharedSqliteManager] getCurrentOnlineVideoDictionary:currentNavigationIndex];

   for (YTYouTubeType * projectType in projectTypeArray) {
      NSString * projectTypeTitle = [YoutubeParser getYoutubeTypeTitle:projectType];

      LeftMenuItemTree * leftMenuItemTree =
       [[self alloc] initWithTitle:projectTypeTitle
                          itemType:LMenuTreeSubscriptions
                         rowsArray:projectType.ProjectNameArray
                         hideTitle:NO
                       remoteImage:NO];

      [menuItemTreeArray addObject:leftMenuItemTree];
   }


   return menuItemTreeArray;
}


#pragma mark
#pragma mark


+ (NSMutableArray *)cellIdentifierArray {
   return @[
    @"CategoriesCellIdentifier",
    @"SignUserCellIdentifier",
    @"SubscriptionsCellIdentifier",
   ];
}


#pragma mark -
#pragma mark View methods


+ (NSMutableArray *)defaultCategories {
   NSArray * array = @[
    @[ @"Autos & Vehicles", @"Autos", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Comedy", @"Comedy", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Education", @"Education", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Entertainment", @"Entertainment", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"File & Animation", @"Film", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Gaming", @"Games", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Howto & Style", @"Howto", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Music", @"Music", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"News & Politics", @"News", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Nonprofits & Activism", @"Nonprofit", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"People & Blogs", @"People", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Pets & Animals", @"Animals", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Science & Technology", @"Tech", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Sports", @"Sports", [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"Travel & Events", @"Travel", [[NSNumber alloc] initWithInt:kUploadsTag] ],
   ];

   return [array mutableCopy];
}


+ (NSMutableArray *)signUserCategories {
   NSArray * array = @[
    @[ @"Subscriptions", @"subscriptions",
     [[NSNumber alloc] initWithInt:kUploadsTag] ],
    @[ @"What to Watch", @"recommended",
     [[NSNumber alloc] initWithInt:kWatchHistoryTag] ],
    @[ @"Favorite", @"favorites",
     [[NSNumber alloc] initWithInt:kFavoritesTag] ],
    @[ @"Watch Later", @"watch_later",
     [[NSNumber alloc] initWithInt:kWatchLaterTag] ],
    @[ @"Playlists", @"playlists",
     [[NSNumber alloc] initWithInt:kUploadsTag] ],
   ];

   return [array mutableCopy];
}


+ (NSString *)getTitleInRow:(id)line {
   return [YoutubeParser getChannelSnippetTitle:line];
}


+ (NSString *)getThumbnailUrlInRow:(NSMutableArray *)array {
   return array[1];
}


+ (NSString *)getChannelIdUrlInRow:(NSMutableArray *)array {
   return array[2];
}


+ (YTPlaylistItemsType)getTypeInRow:(NSMutableArray *)array {
   return [array[2] intValue];
}


+ (void)reloadSubscriptionItemTree:(NSMutableArray *)subscriptionList inSectionArray:(NSMutableArray *)sectionArray {
   for (LeftMenuItemTree * itemTree in sectionArray) {
      if (itemTree.itemType == LMenuTreeSubscriptions) {
         itemTree.rowsArray = subscriptionList;
      }
   }

}
@end
