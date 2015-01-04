#import <Foundation/Foundation.h>
#import "ABProjectName.h"


@interface ABProjectFileInfo : ABSqliteObject<MKAnnotation>

@property(assign) int fileInfoID;

@property(copy) NSString * subtitleName;
@property(copy) NSString * abstractFilePath;

@property(assign) BOOL canDelete;
- (instancetype)initWithFileInforName:(NSString *)fileInforName abstractFilePath:(NSString *)abstractFilePath;


- (NSString *)getOnlineVideoPlayUrl:(NSString *)domain;
+ (ABProjectFileInfo *)reportFromJSON:(NSString *)json;
+ (NSArray *)reportsFromJSON:(NSString *)json;
- (NSString *)JSONValue;

- (NSString *)encodeAbstractFilePath;
//- (NSString *)getCacheFileInfoThumbnail;
@end
