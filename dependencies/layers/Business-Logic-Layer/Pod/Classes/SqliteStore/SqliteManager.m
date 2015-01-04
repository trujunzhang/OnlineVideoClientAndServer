//
// Created by djzhang on 12/27/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "SqliteManager.h"
#import "MobileDB.h"
#import "YoutubeConstants.h"
#import "AnimatedContentsDisplayLayer.h"
#import "ABOnlineVideoType.h"
#import "MultipleTypeHelper.h"
#import "SqliteArraySortHelper.h"

NSMutableDictionary * _videoDictionary;
NSMutableDictionary * _onlineVideoTypePathDictionary;
NSMutableArray * _onlineVideoTypeArray;


@implementation SqliteManager {

}

+ (SqliteManager *)sharedSqliteManager {
   static SqliteManager * sqliteManager;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       sqliteManager = [[SqliteManager alloc] init];
       [sqliteManager resetOnlineVideoTypeArray];
   });

   return sqliteManager;
}


- (NSMutableArray *)getOnlineVideoTypesArray {
   return _onlineVideoTypeArray;
}


+ (NSString *)getCurrentOnlineVideoTypePath:(NSString *)navigationIndex {
   NSString * onlineVideoTypePath = [_onlineVideoTypePathDictionary objectForKey:navigationIndex];

   return onlineVideoTypePath;
}


- (void)resetOnlineVideoTypeArray {
   NSMutableArray * mutableArray = [[MobileDB dbInstance] readOnlineVideoTypes];

   _onlineVideoTypePathDictionary = [MultipleTypeHelper getOnlineVideoTypePathDictionary:mutableArray];
   _onlineVideoTypeArray = [MultipleTypeHelper getSingleOnlineVideoTypesArray:mutableArray];
}


- (NSArray *)getCurrentOnlineVideoDictionary:(NSInteger)selectedIndex {
   ABOnlineVideoType * onlineVideoType = _onlineVideoTypeArray[selectedIndex];

   return onlineVideoType.onlineTypeDictionary.allValues;
}


- (NSMutableDictionary *)getOnlineVideoDictionary {
   return _videoDictionary;
}


- (NSArray *)getProjectTypeArray {
   NSMutableDictionary * dictionary = [self getOnlineVideoDictionary];

   return dictionary.allValues;
}


/**
* Sort object Array by  ABProjectList.sqliteObjectName
*
* @return The object `ABProjectList` array
*
*/
- (NSMutableArray *)getProjectListArray:(NSString *)projectNameId {

   NSMutableArray * projectLists = [[NSMutableArray alloc] init];
   [[MobileDB dbInstance] readProjectNameLists:[projectNameId intValue] withArray:projectLists isReadArray:YES];

   projectLists = [SqliteArraySortHelper sortForABProjectList:projectLists];
   return projectLists;
}


/**
* Sort object Array by  ABProjectFileInfo.sqliteObjectName
*
* @return The object `ABProjectList.projectFileInfos` array
*
*/
- (void)sortForFileInfoArrayIn:(ABProjectList *)projectList {
   projectList.projectFileInfos = [SqliteArraySortHelper sortForABProjectList:projectList.projectFileInfos];
}


// Array type is YTYouTubePlayList
- (NSMutableArray *)getAllFileInfoListFromProjectList:(NSMutableArray *)projectLists {
   NSMutableArray * allFileInfoArray = [[NSMutableArray alloc] init];

   for (YTYouTubePlayList * playList in projectLists) {
      for (YTYouTubeVideoCache * videoCache in playList.projectFileInfos) {
         [allFileInfoArray addObject:videoCache];
      }
   }


   return allFileInfoArray;
}


- (NSMutableArray *)getProgressionProjectList:(NSMutableArray *)projectLists {
   return projectLists;
}


@end