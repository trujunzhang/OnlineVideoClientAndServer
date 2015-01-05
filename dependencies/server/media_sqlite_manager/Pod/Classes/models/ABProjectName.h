//
//  Location.h
//  MobileApp
//
//  Created by Aaron Bratcher on 12/06/2012.
//  Copyright (c) 2012 Market Force. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ABSqliteObject.h"


@interface ABProjectName : ABSqliteObject

// http://kickass.so/lynda-muse-essential-training-by-justin-seeley-t9250299.html
@property(copy) NSString * projectDownloadUrl;

@property(strong) NSMutableArray * projectListsArray;
@property(strong) NSMutableArray * lastsubDirectoryListsArray;

- (instancetype)initWithProjectName:(NSString *)projectName withProjectFullPath:(NSString *)projectFullPath;

+ (ABProjectName *)locationFromJSON:(NSString *)json;
+ (NSArray *)locationsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (void)appendProjectList:(id)list;
@end
