#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject

@property(strong) NSMutableArray * projectFileInfos;

- (instancetype)initWithProjectListName:(NSString *)projectListName;


- (void)appendFileInfo:(id)fileInfo;
- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
