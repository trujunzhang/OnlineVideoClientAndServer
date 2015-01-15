#import <Foundation/Foundation.h>
#import "ABProjectName.h"


@interface ABProjectFileInfo : ABSqliteObject

@property (copy) NSString *subtitleName;

@property (assign) BOOL canDelete;

- (instancetype)initWithFileInforName:(NSString *)fileInforName;

- (NSString *)getOnlineVideoPlayUrl:(NSString *)domain;

- (NSString *)encodeAbstractFilePath;


@end
