//
//  main.m
//  OnlineVideoServerConsole
//
//  Created by djzhang on 12/29/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoGenerateSqliteHelper.h"
#import "UserCacheFolderHelper.h"


int main(int argc, const char * argv[]) {
   @autoreleasepool {
      // insert code here...
      [UserCacheFolderHelper checkUserProjectDirectoryExistAndMake];
      [UserCacheFolderHelper removeFileForVideoTrainingDB];

      [VideoGenerateSqliteHelper generateSqliteAndThumbnail];

      NSLog(@"Hello, World!");
   }
   return 0;
}


