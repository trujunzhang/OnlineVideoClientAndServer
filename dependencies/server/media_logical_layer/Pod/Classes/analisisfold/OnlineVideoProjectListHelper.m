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
#import "ServerVideoConfigure.h"
#import "SOThumbnailInfo.h"
#import "MobileThumbnailCacheDirectoryHelper.h"


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
   // *** online-step-{ABProjectName-3} ***
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
               // *** online-step-{ABProjectList-4} ***
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
   for (NSString * ignoreName in [ServerVideoConfigure ignoreProjectTypeNameArray]) {
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
               // *** online-step-{ABProjectFileInfo-5} ***
               ABProjectFileInfo * projectFileInfo = [projectList checkExistInSubDirectoryWithObjectName:aPath];
               if (projectFileInfo == nil) {
                  projectFileInfo = [[ABProjectFileInfo alloc] initWithFileInforName:aPath];
                  [projectList appendFileInfo:projectFileInfo];
               }

               // *** online-step-{SOThumbnailInfo-6} ***
               SOThumbnailInfo * thumbnailInfo =
                [MobileThumbnailCacheDirectoryHelper checkExistAndSaveForThumbnailInfoWithFileInfoID:projectFileInfo.sqliteObjectID
                                                                                       fileInforName:aPath
                                                                                     projectFullPath:fullPath];

//               [self checkExistAndGenerateThumbnail:projectFileInfo.sqliteObjectID
//                                            forFile:[NSString stringWithFormat:@"%@/%@", appDocDir, aPath]];

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

   BOOL myPathIsDir;
   BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:destinateThumbnailPath isDirectory:&myPathIsDir];

   if (fileExists) {
   } else {
      [GenerateThumbnailTask executeGenerateThumbnailTaskFrom:fileAbstractPath to:destinateThumbnailPath];
   }

}


- (BOOL)checkIsMovieFile:(NSString *)path {
   NSString * extension = [[path pathExtension] lowercaseString];

   for (NSString * type in [ServerVideoConfigure movieSupportedType]) {
      if ([extension isEqualToString:type]) {
         return YES;
      }
   }

   return NO;
}


@end