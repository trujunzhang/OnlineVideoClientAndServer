//
// Created by djzhang on 12/27/14.
//


#import <online_video_manager_config/ServerVideoConfigure.h>
#import "OnlineVideoProjectListHelper.h"
#import "ABProjectType.h"
#import "ABProjectName.h"
#import "ABProjectList.h"
#import "ABProjectFileInfo.h"
#import "MobileBaseDatabase.h"
#import "GenerateThumbnailTask.h"
#import "MobileDBCacheDirectoryHelper.h"


@implementation OnlineVideoProjectListHelper {

}

- (instancetype)initWithOnlinePath:(NSString *)onlinePath withCacheDirectory:(NSString *)cacheDirectory {
   self = [super init];
   if (self) {
      self.onlinePath = onlinePath;
      self.cacheDirectory = cacheDirectory;
   }

   return self;
}


- (void)makeProjectList:(NSString *)aPath withFullPath:(NSString *)fullPath to:(ABProjectType *)projectType {
   // *** online-step-{ABProjectName} ***
   ABProjectName * projectName = [MobileDBCacheDirectoryHelper checkExistForProjectNameWithProjectName:aPath
                                                                                       projectFullPath:fullPath];
   if (projectName == nil)
      projectName = [[ABProjectName alloc] initWithProjectName:aPath withProjectFullPath:fullPath];

   [projectType appendProjectName:projectName];

   [self analysisProjectList:fullPath to:projectName];
}


- (void)analysisProjectList:(NSString *)appDocDir to:(ABProjectName *)projectName {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
            if ([self checkIgnoureProjectType:aPath] == NO) {
               // *** online-step-{ABProjectList} ***
               ABProjectList * projectList = [projectName checkExistInSubDirectoryWithObjectName:aPath];
               if (projectList) {
                  [MobileDBCacheDirectoryHelper getFileInfoArrayForProjectList:projectList];
               } else {
                  projectList = [[ABProjectList alloc] initWithProjectListName:aPath];
               }

               [projectName appendProjectList:projectList];
               [self analysisProjectNames:fullPath to:projectList];
            }
         }
      }
   }
}


- (BOOL)checkIgnoureProjectType:(NSString *)sqliteObjectName {
   NSArray * ignoreProjectTypeNameArray = @[
    @"Exercise Files",
    @"Exercise File",
   ];

   for (NSString * ignoreName in ignoreProjectTypeNameArray) {
      if ([sqliteObjectName isEqualToString:ignoreName]) {
         return YES;
      }
   }

   return NO;
}


- (void)analysisProjectNames:(NSString *)appDocDir to:(ABProjectList *)projectList {
   NSArray * contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
   for (NSString * aPath in contentOfFolder) {
      NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
      BOOL isDir = NO;
      if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
         if (isDir == YES) {
         } else {
            if ([self checkIsMovieFile:aPath]) {
               // *** online-step-{ABProjectFileInfo} ***
               ABProjectFileInfo * projectFileInfo = [projectList checkExistInSubDirectoryWithObjectName:aPath];
               if (projectFileInfo == nil) {
                  projectFileInfo = [[ABProjectFileInfo alloc] initWithFileInforName:aPath];
                  [projectList appendFileInfo:projectFileInfo];
               }

               [self checkExistAndGenerateThumbnail:projectFileInfo.sqliteObjectID
                                            forFile:[NSString stringWithFormat:@"%@/%@", appDocDir, aPath]];

            }
         }
      }
   }
}


- (void)checkExistAndGenerateThumbnail:(int)fileInfoID forFile:(NSString *)fileAbstractPath {
   if (needGenerateThumbnail == NO)
      return;

   NSObject * thumbnailName = [MobileBaseDatabase getThumbnailName:fileInfoID];
   NSObject * cacheDirectory = [NSString stringWithFormat:@"%@/%@", self.cacheDirectory, thumbnailFolder];
   NSString * destinateThumbnailPath = [NSString stringWithFormat:@"%@/%@", cacheDirectory, thumbnailName];
   [MobileDBCacheDirectoryHelper checkExistForFileInfoWithAbstractPath:destinateThumbnailPath];

   [GenerateThumbnailTask executeGenerateThumbnailTaskFrom:fileAbstractPath to:destinateThumbnailPath];
}


- (NSString *)getFileAbstractPath:(NSString *)appDocDir withPath:(NSString *)aPath {
   NSString * string = [NSString stringWithFormat:@"%@/%@", appDocDir, aPath];
   return [string replaceCharcter:self.onlinePath withCharcter:@""];
}


- (BOOL)checkIsMovieFile:(NSString *)path {
   NSArray * movieSupportedType = @[ @".mp4", @".mov" ];

   path = [path lowercaseString];
   for (NSString * type in movieSupportedType) {
      if ([path containsString:type]) {
         return YES;
      }
   }

   return NO;
}


@end