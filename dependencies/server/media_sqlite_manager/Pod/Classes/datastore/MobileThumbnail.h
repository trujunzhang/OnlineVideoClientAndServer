#import "MobileBaseDatabase.h"


@interface MobileThumbnail : MobileBaseDatabase


#pragma mark - Base

+ (MobileThumbnail *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;

@end


