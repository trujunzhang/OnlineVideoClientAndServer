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
            ABProjectList * projectList = [[ABProjectList alloc] initWithProjectListName:aPath];

            if ([self checkIgnoureProjectType:projectList] == NO) {

               NSLog(@"appDocDir = %@", appDocDir);
               NSLog(@"projectListName = %@", projectList.sqliteObjectName);

               [projectName appendProjectList:projectList];
               [self analysisProjectNames:fullPath to:projectList];
            }
         }
      }
   }
}


- (BOOL)checkIgnoureProjectType:(ABProjectList *)projectList {
   NSArray * ignoreProjectTypeNameArray = @[
    @"Exercise Files",
    @"Exercise File",
   ];

   for (NSString * ignoreName in ignoreProjectTypeNameArray) {
      if ([projectList.sqliteObjectName isEqualToString:ignoreName]) {
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
               //"/Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction"
               //"01-Welcome.mp4"
               // /Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4
               // /Volumes/macshare/MacPE/Lynda.com/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4

               NSString * fileAbstractPath = [self getFileAbstractPath:appDocDir withPath:aPath];
               //"/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4"
               //http://192.168.1.200:8040/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/0. Introduction/01-Welcome.mp4
               //http://192.168.1.200:8040/Adobe.com/01-Welcome.mp4
               //http://192.168.1.200:8040/Adobe.com/@Muse/#Muse Essential Training by Justin Seeley/01-Welcome.mp4

               if ([MobileDBCacheDirectoryHelper checkFileInfoExist:fileAbstractPath] == NO) {
                  NSLog(@"fileAbstractPath = %@", fileAbstractPath);

                  ABProjectFileInfo * projectFileInfo = [[ABProjectFileInfo alloc] initWithFileInforName:aPath];
                  [projectList appendFileInfo:projectFileInfo];
                  [self generateThumbnail:projectFileInfo.sqliteObjectID
                                  forFile:[NSString stringWithFormat:@"%@/%@", appDocDir, aPath]];
               }
            }
         }
      }
   }
}


- (void)generateThumbnail:(int)fileInfoID forFile:(NSString *)fileAbstractPath {
   if (needGenerateThumbnail == NO)
      return;

   [GenerateThumbnailTask appendGenerateThumbnailTask:[MobileBaseDatabase getThumbnailName:fileInfoID]
                                                   in:fileAbstractPath
                                                   to:[NSString stringWithFormat:@"%@/%@",
                                                                                 self.cacheDirectory,
                                                                                 thumbnailFolder]];

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