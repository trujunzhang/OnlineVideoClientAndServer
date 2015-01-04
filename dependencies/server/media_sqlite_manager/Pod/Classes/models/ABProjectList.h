#import <Foundation/Foundation.h>
#import "ABProjectName.h"
@class ABProjectFileInfo;


@interface ABProjectList : ABSqliteObject

@property(assign) int projectListID;
@property(strong) NSMutableArray * projectFileInfos;

- (instancetype)initWithProjectListName:(NSString *)projectListName;

+ (ABProjectList *)reportFromJSON:(NSString *)json;
+ (NSArray *)reportsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (void)appendFileInfo:(id)fileInfo;
- (ABProjectFileInfo *)getFirstABProjectFileInfo;

@end
