//
// Created by djzhang on 1/1/15.
// Copyright (c) 2015 djzhang. All rights reserved.
//

#import "GenerateThumbnailTask.h"


@implementation GenerateThumbnailTask {

}

+ (void)executeGenerateThumbnailTaskFrom:(NSString *)fileAbstractPath to:(NSString *)destinateFilePath {
   NSString * format = [NSString stringWithFormat:
    @"ffmpeg -i \"%@\" -deinterlace -an -ss 1 -t 00:00:10 -s 320x180 -r 1 -y -vcodec mjpeg -f mjpeg \"%@\"",
    fileAbstractPath,
    destinateFilePath];
   [GenerateThumbnailTask runCommand:format];
}


+ (NSString *)runCommand:(NSString *)commandToRun {
   NSTask * task;
   task = [[NSTask alloc] init];
   [task setLaunchPath:@"/bin/sh"];

   NSArray * arguments = [NSArray arrayWithObjects:
    @"-c",
    [NSString stringWithFormat:@"%@", commandToRun],
     nil];
   [task setArguments:arguments];

   NSPipe * pipe;
   pipe = [NSPipe pipe];
   [task setStandardOutput:pipe];

   NSFileHandle * file;
   file = [pipe fileHandleForReading];

   [task launch];

   NSData * data;
   data = [file readDataToEndOfFile];

   NSString * output;
   output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

   NSLog(@"run command: %@", commandToRun);
   NSLog(@"output = %@", output);

   return output;
}


@end