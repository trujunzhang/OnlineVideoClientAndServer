typedef NS_ENUM (NSUInteger, ONLINE_VIDEO_TYPE) {
    VIDEO_TYPE_YOUTUBE,
    VIDEO_TYPE_LYNDA,
    VIDEO_TYPE_SEASON,
    VIDEO_TYPE_DIVX,
    VIDEO_TYPE_OPERA,
};


@interface VideoTpyeConstant : NSObject

+ (NSString *)getVideoTypeName:(ONLINE_VIDEO_TYPE)type;

@end
