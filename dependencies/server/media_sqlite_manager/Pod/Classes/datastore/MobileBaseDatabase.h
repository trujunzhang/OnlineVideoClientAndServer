//
// Created by djzhang on 12/31/14.
//

#import <Foundation/Foundation.h>
@protocol ABDatabase;


static NSString * const dataBaseName = @"VideoTrainingDB.db";
static NSString * const thumbnailDataBaseName = @"MobileDBThumbnail.db";
static NSString * const thumbnailPrefix = @"TH_";
static NSString * const thumbnailFolder = @"thumbnail";

typedef void(^ReportResultsBlock)(NSArray * reports);
typedef void(^LocationResultsBlock)(NSArray * locations);


@interface MobileBaseDatabase : NSObject {

}

+ (NSString *)uniqueID;
- (void)makeForMobileDB:(id<ABDatabase>)db ;
- (void)checkSchemaForMobileDB:(id<ABDatabase>)db ;
- (void)makeForMobileDBThumbnail:(id<ABDatabase>)db;
- (void)checkSchemaForMobileDBThumbnail:(id<ABDatabase>)db ;

+ (BOOL)checkDBFileExist:(NSString *)filePathName;
+ (NSString *)getThumbnailName:(int)sqliteObjectID;
@end