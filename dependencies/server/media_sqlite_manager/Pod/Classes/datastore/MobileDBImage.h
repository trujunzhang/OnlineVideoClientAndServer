#import "MobileBaseDatabase.h"

#import "SqliteDatabaseConstant.h"

@class SOThumbnailInfo;


@interface MobileDBImage : NSObject


#pragma mark - Base

+ (MobileDBImage *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

- (SOThumbnailInfo *)checkExistForThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;
- (void)saveThumbnailInfoWithFileInfoID:(NSString *)sqliteObjectID fileInforName:(NSString *)sqliteObjectName projectFullPath:(NSString *)fullPath;

@end


