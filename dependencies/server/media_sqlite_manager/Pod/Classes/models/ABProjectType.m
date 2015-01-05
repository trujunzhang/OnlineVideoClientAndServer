#import "ABProjectType.h"
#import "MobileDB.h"


@interface ABProjectType ()<NSCoding>

@end


@implementation ABProjectType


- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];
      self.ProjectNameArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectTypeID:(int)projectTypeID projectTypeName:(NSString *)projectTypeName {
   self = [self init];
   if (self) {
      self.sqliteObjectID = projectTypeID;
      self.sqliteObjectName = projectTypeName;
   }

   return self;
}


- (instancetype)initWithProjectType:(NSString *)projectName projectFullPath:(NSString *)projectFullPath {
   self = [self init];
   if (self) {
      self.sqliteObjectName = projectName;
      self.projectFullPath = projectFullPath;
   }

   return self;
}


- (BOOL)isEqual:(id)object {
   ABProjectType * compareLocation = object;

   return self.sqliteObjectID == compareLocation.sqliteObjectID;
}


#pragma mark - 
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.sqliteObjectName forKey:@"projectTypeName"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (void)appendProjectName:(ABProjectName *)projectName {
   [self.ProjectNameArray addObject:projectName];
}


+ (NSMutableDictionary *)getAllProjectNames:(NSMutableDictionary *)projectTypesDictionary {
   NSMutableDictionary * projectNamesDictionary = [[NSMutableDictionary alloc] init];

   for (ABProjectType * projectType in projectTypesDictionary.allValues) {
      NSString * projectTypeName = projectType.sqliteObjectName;

      for (ABProjectName * abProjectName in projectType.ProjectNameArray) {
         NSString * projectName = abProjectName.sqliteObjectName;

         [projectNamesDictionary setObject:projectName forKey:projectTypeName];
      }
   }

   return projectNamesDictionary;
}

@end
