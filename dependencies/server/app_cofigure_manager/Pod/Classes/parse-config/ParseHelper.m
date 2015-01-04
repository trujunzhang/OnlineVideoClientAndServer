//
// Created by djzhang on 12/30/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "ParseHelper.h"
#import "OnlineServerInfo.h"
#import <Parse/Parse.h>
#import <Bolts/BFTask.h>


static NSString * const parseClassID = @"9RQwiYQhBS";


@implementation ParseHelper {

}

+ (ParseHelper *)sharedParseHelper {
   static ParseHelper * cache;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       cache = [[ParseHelper alloc] init];
   });

   return cache;
}


#pragma mark -
#pragma mark Saving Objects to parse Server


- (void)saveOnlineVideoInfo:(OnlineServerInfo *)serverInfo {
   PFObject * gameScore = [PFObject objectWithClassName:@"OnlineServerInfo"];

   gameScore[@"domainHost"] = serverInfo.domainHost;
   gameScore[@"domainPort"] = serverInfo.domainPort;
   gameScore[@"cacheThumbmail"] = serverInfo.cacheThumbmail;
   gameScore[@"version"] = serverInfo.version;

   [gameScore saveInBackground];
}


#pragma mark -
#pragma mark Fetching Objects to parse Server


- (void)readOnlineVideoInfo:(ParseHelperResultBlock)parseHelperResultBlock {
   PFQuery * query = [PFQuery queryWithClassName:@"OnlineServerInfo"];
   [query getObjectInBackgroundWithId:parseClassID block:^(PFObject * gameScore, NSError * error) {

       if (error) {
          // 1. Fetching local cache Objects
//          ParseHelperResultBlock localResultBlock = ^(OnlineServerInfo * object, NSError * error) {
//              parseHelperResultBlock(object, error);
//          };
//          [self readLocalVideoInfo:localResultBlock];
          parseHelperResultBlock(nil, error);
       } else {
          // 1. Fetching Objects to parse Server
          OnlineServerInfo * onlineServerInfo = [self parseInfo:gameScore];
          parseHelperResultBlock(onlineServerInfo, error);

          // 2. Save Objects to local to cache it
          [self saveLocalVideoInfo:onlineServerInfo];
       }
   }];
}


- (OnlineServerInfo *)parseInfo:(PFObject *)gameScore {
   OnlineServerInfo * serverInfo = [[OnlineServerInfo alloc] init];

   serverInfo.domainHost = gameScore[@"domainHost"];
   serverInfo.domainPort = gameScore[@"domainPort"];
   serverInfo.cacheThumbmail = gameScore[@"cacheThumbmail"];
   serverInfo.version = gameScore[@"version"];

   return serverInfo;
}


#pragma mark -
#pragma mark The Local Datastore


- (void)saveLocalVideoInfo:(OnlineServerInfo *)serverInfo {
   PFObject * gameScore = [PFObject objectWithClassName:@"OnlineServerInfo"];

   gameScore[@"domainHost"] = serverInfo.domainHost;
   gameScore[@"domainPort"] = serverInfo.domainPort;
   gameScore[@"cacheThumbmail"] = serverInfo.cacheThumbmail;
   gameScore[@"version"] = serverInfo.version;

   [gameScore pinInBackground];//The Local Datastore
}


#pragma mark -
#pragma mark Retrieving Objects from the Local Datastore


- (void)readLocalVideoInfo:(ParseHelperResultBlock)pFunction {
   PFObject * object = [PFObject objectWithoutDataWithClassName:@"OnlineServerInfo" objectId:@"9RQwiYQhBS"];
   [[object fetchFromLocalDatastoreInBackground] continueWithBlock:^id(BFTask * task) {
       if (task.error) {
          // something went wrong
          return task;
       }

       // task.result will be your game score
       return task;
   }];
}


- (void)readLocalVideoInfo123:(ParseHelperResultBlock)parseHelperResultBlock {
   PFQuery * query = [PFQuery queryWithClassName:@"OnlineServerInfo"];
   [query fromLocalDatastore];

   BFTask * bfTask = [query getObjectInBackgroundWithId:@"9RQwiYQhBS"];

   BFContinuationBlock continueWithBlock = ^id(BFTask * task) {
       if (task.error) {
          // something went wrong;
          return task;
       }

       // task.result will be your game score
       return task;
   };
   [bfTask continueWithBlock:continueWithBlock];

}

@end