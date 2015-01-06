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


@interface ABProjectType : ABSqliteObject

- (instancetype)initWithProjectName:(NSString *)projectName projectFullPath:(NSString *)projectFullPath;

+ (NSMutableDictionary *)getAllProjectNames:(NSMutableDictionary *)projectTypesDictionary;
@end
