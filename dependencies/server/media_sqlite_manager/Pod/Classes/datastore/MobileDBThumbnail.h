#import "MobileBaseDatabase.h"
@class SOThumbnailInfo;


@interface MobileDBThumbnail : MobileBaseDatabase


#pragma mark - Base

+ (MobileDBThumbnail *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(int)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;
- (void)saveThumbnailInfoWithFileInfoID:(int)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;
@end


