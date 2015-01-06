#import "MobileBaseDatabase.h"
@class SOThumbnailInfo;


@interface MobileDBThumbnail : MobileBaseDatabase


#pragma mark - Base

+ (MobileDBThumbnail *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(NSString *)name fileInforName:(NSString *)name1 projectFullPath:(NSString *)path;
@end


