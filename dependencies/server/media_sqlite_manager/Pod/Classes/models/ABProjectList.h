#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject

@property(strong) NSMutableArray * projectFileInfoArray;

- (instancetype)initWithProjectListName:(NSString *)projectListName;


- (void)appendFileInfo:(id)fileInfo;
- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
