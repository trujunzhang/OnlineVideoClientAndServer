#import "MobileBaseDatabase.h"


@interface MobileDBThumbnail : MobileBaseDatabase


#pragma mark - Base

+ (MobileDBThumbnail *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

@end


