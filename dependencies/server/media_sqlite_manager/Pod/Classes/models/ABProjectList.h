#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject

- (instancetype)initWithProjectListName:(NSString *)projectListName;

- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
