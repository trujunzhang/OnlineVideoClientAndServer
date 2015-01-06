//
// Created by djzhang on 12/31/14.
//

#import <Foundation/Foundation.h>
@protocol ABDatabase;


@interface MobileBaseDatabase : NSObject {

}

+ (NSString *)uniqueID;
- (void)makeForMobileDB:(id<ABDatabase>)db ;
- (void)checkSchemaForMobileDB:(id<ABDatabase>)db ;
- (void)makeForMobileDBThumbnail:(id<ABDatabase>)db;
- (void)checkSchemaForMobileDBThumbnail:(id<ABDatabase>)db ;

+ (BOOL)checkDBFileExist:(NSString *)filePathName;
+ (NSString *)getThumbnailName:(NSString*)sqliteObjectID;
@end