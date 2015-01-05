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

@property(assign) int sqliteObjectID;


// http://kickass.so/lynda-muse-essential-training-by-justin-seeley-t9250299.html
@property(copy) NSString * projectDownloadUrl;

// Lynda.com/Adobe.com/Muse
@property(copy) NSString * projectAbstractPath;

@property(strong) NSMutableArray * projectLists;

- (instancetype)initWithProjectName:(NSString *)projectName;

+ (ABProjectName *)locationFromJSON:(NSString *)json;
+ (NSArray *)locationsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (void)appendProjectList:(id)list;
@end
