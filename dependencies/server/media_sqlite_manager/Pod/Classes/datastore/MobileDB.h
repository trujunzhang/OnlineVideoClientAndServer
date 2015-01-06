#import <Foundation/Foundation.h>
#import <media_sqlite_manager/MobileDB.h>
#import "ABProjectName.h"
#import "ABProjectList.h"
#import "MobileBaseDatabase.h"
#import "MobileDB.h"
@class ABProjectType;

@interface MobileDB : MobileBaseDatabase


#pragma mark - Base

+ (MobileDB *)dbInstance;
+ (NSString *)getDBFilePathForiOS;
+ (MobileDB *)dbInstance:(NSString *)path;

- (id)initWithFile:(NSString *)filePathName;
- (void)close;


- (void)readProjectNameLists:(int)projectNameID withArray:(NSMutableArray *)mutableArray isReadArray:(BOOL)isReadArray;
#pragma mark - Locations
- (void)locationsForReport:(ABProjectList *)report Results:(LocationResultsBlock)locationsBlock;
- (void)fillDetailsForLocations:(NSArray *)locations;
- (void)saveLocation:(ABProjectName *)location;

#pragma mark - Reports
- (void)saveReport:(ABProjectList *)report;
- (void)allReports:(ReportResultsBlock)reportsBlock;
- (void)allReportsWithLocations:(ReportResultsBlock)reportsBlock;

#pragma mark - Preferences
- (BOOL)checkFileInfoExist:(NSString *)fileAbstractPath;
- (void)readFileInfoAbstractPath:(LocationResultsBlock)locationsBlock withFileInfoID:(int)fileInfoID;
- (NSString *)preferenceForKey:(NSString *)key;
- (void)setPreference:(NSString *)value forKey:(NSString *)key;

#pragma mark - Utilities
- (void)saveForOnlineVideoTypeDictionary:(NSMutableDictionary *)dictionary withName:(NSString *)onlineTypeName whithOnlineVideoTypePath:(NSString *)onlineVideoTypePath;
- (void)readDictionaryForProjectTypeWithProjectTypeId:(int)projectTypeId toDictionary:(NSMutableDictionary *)dictionary hasAllList:(BOOL)isAllList;
- (NSMutableDictionary *)readDictionaryForProjectTypeWithProjectTypeId:(int)projectTypeId hasAllList:(BOOL)isAllList;


- (NSMutableArray *)readOnlineVideoTypes:(NSMutableDictionary *)filterDictionary isReadArray:(BOOL)isReadArray;
- (NSMutableArray *)readOnlineVideoTypes;

#pragma mark - Check Row Exist
- (ABProjectType *)checkExistForProjectTypeWithProjectTypeName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath;
- (ABProjectName *)checkExistForProjectNameWithProjectName:(NSString *)sqliteObjectName projectFullPath:(NSString *)projectFullPath;
- (void)getFileInfoArrayForProjectList:(ABProjectList *)projectList;
- (void)makeObjectFullPathForProjectListArray:(NSMutableArray *)projectListArray projectFullPath:(NSString *)projectFullPath;
@end


