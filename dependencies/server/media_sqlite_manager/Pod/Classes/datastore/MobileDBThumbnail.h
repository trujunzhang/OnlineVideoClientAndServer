#import "MobileBaseDatabase.h"
@class SOThumbnailInfo;


@interface MobileDBThumbnail : MobileBaseDatabase


#pragma mark - Base

+ (MobileDBThumbnail *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(NSString*)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;
- (void)saveThumbnailInfoWithFileInfoID:(NSString*)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;
@end


