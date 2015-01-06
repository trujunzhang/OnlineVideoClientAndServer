#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject

@property(strong) NSMutableArray * sqliteObjectArray;

- (instancetype)initWithProjectListName:(NSString *)projectListName;

- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
