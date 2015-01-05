//
// Created by djzhang on 1/4/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import <media_sqlite_manager/MobileDB.h>
#import <media_logical_layer/OnlineVideoStatisticsHelper.h>
#import <online_video_manager_config/ServerVideoConfigure.h>
#import <media_logical_layer/UserCacheFolderHelper.h>
#import "VideoGenerateSqliteHelper.h"
#import "MemoryDBHelper.h"
#import "MobileDBCacheDirectoryHelper.h"
#import "MemoryDBHelper.h"

static MemoryDBHelper * _currentMemoryDBHelper;


@implementation VideoGenerateSqliteHelper {

}
+ (void)generateSqliteFromSourceWithTypeName:(NSString *)onlineTypeName withLocalPath:(NSString *)onlineVideoTypePath withScanFolder:(NSString *)videoScanFold saveSqlitTo:(NSString *)dbDirectory {
   _currentMemoryDBHelper = [MemoryDBHelper sharedInstanceWithTypeName:onlineTypeName
                                                         withLocalPath:onlineVideoTypePath];

   // 1
   OnlineVideoStatisticsHelper * onlineVideoStatisticsHelper = [[OnlineVideoStatisticsHelper alloc] initWithOnlinePath:videoScanFold
                                                                                                    withCacheDirectory:dbDirectory];

   // 2
   [MobileDBCacheDirectoryHelper saveForOnlineVideoTypeDictionary:onlineVideoStatisticsHelper.projectTypesDictionary
                                                         withName:onlineTypeName
                                         whithOnlineVideoTypePath:onlineVideoTypePath
   ];
}


+ (void)generateSqliteAndThumbnail {

   NSMutableDictionary * onlineTypeDictionary = @{
    @"Youtube.com" : [ServerVideoConfigure youtubeArray],
    @"Lynda.com" : [ServerVideoConfigure lyndaArray],
   };

   for (NSString * onlineTypeName in onlineTypeDictionary.allKeys) {
      NSArray * typePathArray = [onlineTypeDictionary valueForKey:onlineTypeName];

      for (NSString * videoScanFold in typePathArray) {
         [VideoGenerateSqliteHelper generateSqliteFromSourceWithTypeName:onlineTypeName// Youtube.com
                                                           withLocalPath:[videoScanFold replaceCharcter:htdocs
                                                                                           withCharcter:@""]// local path: "/macshare/MacPE/youtubes"
                                                          withScanFolder:videoScanFold// "/Volumes/macshare/MacPE/youtubes"
                                                             saveSqlitTo:[UserCacheFolderHelper RealProjectCacheDirectory]// "/Volumes/Home/djzhang/.AOnlineTutorial/.cache"+"xxx.db"
         ];

      }
   }


}
@end