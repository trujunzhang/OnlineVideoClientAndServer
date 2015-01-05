#import <Foundation/Foundation.h>
#import "ABProjectName.h"


@interface ABProjectFileInfo : ABSqliteObject<MKAnnotation>

@property(copy) NSString * subtitleName;
@property(copy) NSString * abstractFilePath;

@property(assign) BOOL canDelete;
- (instancetype)initWithFileInforName:(NSString *)fileInforName;


- (NSString *)getOnlineVideoPlayUrl:(NSString *)domain;
+ (ABProjectFileInfo *)reportFromJSON:(NSString *)json;
+ (NSArray *)reportsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (NSString *)encodeAbstractFilePath;
//- (NSString *)getCacheFileInfoThumbnail;
@end
