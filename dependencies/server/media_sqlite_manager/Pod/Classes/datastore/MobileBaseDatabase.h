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


- (void)checkSchemaForMobileDBThumbnail;
+ (NSString *)uniqueID;
- (void)makeForMobileDB;
- (void)checkSchemaForMobileDB;
- (void)makeForMobileDBThumbnail;
+ (BOOL)checkDBFileExist:(NSString *)filePathName;
+ (NSString *)getThumbnailName:(int)sqliteObjectID;
@end