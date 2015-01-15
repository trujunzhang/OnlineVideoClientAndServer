//
// Created by djzhang on 12/31/14.
//

#import <media_sqlite_manager/MobileDB.h>
#import "MobileBaseDatabase.h"
#import "ABDatabase.h"


@implementation MobileBaseDatabase {

}


#pragma mark - for MobileDB


- (void)makeForMobileDB:(id<ABDatabase>)db {
    // OnlineVideoType
    [db sqlExecute:@"create table OnlineVideoType(onlineVideoTypeID text, onlineVideoTypeName text, objectFullPath text, primary key(onlineVideoTypeID));"];
    [db sqlExecute:@"create table OnlineVideoTypeProjectTypes(onlineVideoTypeID text, projectTypeID text, primary key (onlineVideoTypeID,projectTypeID));"];


    // ProjectType
    [db sqlExecute:@"create table ProjectType(projectTypeID text, projectTypeName text, objectFullPath text, primary key(projectTypeID));"];
    [db sqlExecute:@"create table ProjectTypeNames(projectTypeID text, projectNameID text, primary key (projectTypeID,projectNameID));"];

    // ProjectName+ProjectList
    [db sqlExecute:@"create table ProjectName(projectNameID text, projectName text, objectFullPath text, primary key(projectNameID));"];
    [db sqlExecute:@"create table ProjectList(projectListID text, projectListName text, objectFullPath text, primary key(projectListID));"];
    [db sqlExecute:@"create table ProjectNameLists(projectNameID text, projectListID text, primary key (projectNameID,projectListID));"];

    // ProjectFileInfo+ProjectList
    [db sqlExecute:@"create table ProjectFileInfo(fileInfoID text, fileInforName text, subtitleName text, objectFullPath text, primary key(fileInfoID));"];
    [db sqlExecute:@"create table ProjectListFileInfos(projectListID text, fileInfoID text, primary key (projectListID,fileInfoID));"];

    // Internal
    [db sqlExecute:@"create table Preferences(property text, value text, primary key(property));"];

    [self setPreference:@"1" forKey:@"SchemaVersion" forDatabase:db];
}


- (void)checkSchemaForMobileDB:(id<ABDatabase>)db {
    NSString *schemaVersion = [self preferenceForKey:@"SchemaVersion" forDatabase:db];

    if([schemaVersion isEqualToString:@"1"]) {
        // OnlineVideoType
        [db sqlExecute:@"create index idx_onlinevideotypes_onlinevideotypeid on OnlineVideoType(onlineVideoTypeID);"];
        [db sqlExecute:@"create index idx_onlinevideotypeprojecttypes_projecttypeid on OnlineVideoTypeProjectTypes(projectTypeID);"];// one->multiple

        // ProjectType
        [db sqlExecute:@"create index idx_projecttypes_projecttypeid on ProjectType(projectTypeID);"];
        [db sqlExecute:@"create index idx_projecttypenames_projectnameid on ProjectTypeNames(projectNameID);"];// one->multiple

        // ProjectName+ProjectList
        [db sqlExecute:@"create index idx_projectnames_projectnameid on ProjectName(projectNameID);"];
        [db sqlExecute:@"create index idx_projectlists_projectlistid on ProjectList(projectListID);"];
        [db sqlExecute:@"create index idx_projectnamelists_projectnameid on ProjectNameLists(projectNameID);"];// one->multiple

        // ProjectFileInfo+ProjectList
        [db sqlExecute:@"create index idx_projectfileinfos_fileinfoid on ProjectFileInfo(fileInfoID);"];
        [db sqlExecute:@"create index idx_projectlistfileinfos_fileinfoid on ProjectListFileInfos(fileInfoID);"];// one->multiple

        schemaVersion = @"2";
    }

    [db sqlExecute:@"ANALYZE"];

    [self setPreference:schemaVersion forKey:@"SchemaVersion" forDatabase:db];
}


#pragma mark -
#pragma mark -


+ (NSString *)uniqueID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);

//   NSLog(@"uuidString = %@", uuidString);

    return uuidString;
}


+ (BOOL)checkSqliteFileExist:(NSString *)path {
    BOOL myPathIsDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&myPathIsDir];

    return fileExists;
}


- (NSString *)escapeText:(NSString *)text {
    NSString *newValue = [text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return newValue;
}


#pragma mark - Preferences


- (NSString *)preferenceForKey:(NSString *)key forDatabase:(id<ABDatabase>)db {
    NSString *preferenceValue = @"";

    NSString *sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

    id<ABRecordset> results;
    results = [db sqlSelect:sql];

    if(![results eof]) {
        preferenceValue = [[results fieldWithName:@"value"] stringValue];
    }

    return preferenceValue;
}


- (void)setPreference:(NSString *)value forKey:(NSString *)key forDatabase:(id<ABDatabase>)db {
    if(!value) {
        return;
    }

    NSString *sql = [NSString stringWithFormat:@"select value from preferences where property='%@';", key];

    id<ABRecordset> results;
    results = [db sqlSelect:sql];
    if([results eof]) {
        sql = [NSString stringWithFormat:@"insert into preferences(property,value) values('%@','%@');",
                                         key,
                                         [self escapeText:value]];
    }
    else {
        sql = [NSString stringWithFormat:@"update preferences set value = '%@' where property = '%@';",
                                         [self escapeText:value],
                                         key];
    }

    [db sqlExecute:sql];
}


+ (BOOL)checkDBFileExist:(NSString *)filePathName {
    BOOL myPathIsDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePathName isDirectory:&myPathIsDir];
    return fileExists;
}


+ (NSString *)getThumbnailName:(NSString *)sqliteObjectID {
    return [NSString stringWithFormat:@"%@%@.jpg", thumbnailPrefix, sqliteObjectID];
}


@end