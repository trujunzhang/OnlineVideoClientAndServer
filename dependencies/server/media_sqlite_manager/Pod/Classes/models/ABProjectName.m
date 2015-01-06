#import "ABProjectName.h"
#import "MobileDB.h"


@interface ABProjectName ()<NSCoding>

@end


@implementation ABProjectName

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180


- (instancetype)init {
   self = [super init];
   if (self) {
      self.sqliteObjectID = [MobileDB uniqueID];

      self.objectFullPath = @"";

      self.projectListsArray = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectName:(NSString *)projectName withProjectFullPath:(NSString *)projectFullPath {
   self = [self init];
   if (self) {
      self.sqliteObjectName = projectName;
      self.objectFullPath = projectFullPath;
   }

   return self;
}


- (BOOL)isEqual:(id)object {
   ABProjectName * compareLocation = object;

   return self.sqliteObjectID == compareLocation.sqliteObjectID;
}


#pragma mark - 
#pragma mark ABSqliteObject


- (NSMutableDictionary *)getUpdateDictionary {
   NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
   [dictionary setObject:self.sqliteObjectName forKey:@"projectName"];
   [dictionary setObject:self.objectFullPath forKey:@"objectFullPath"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (void)appendProjectList:(ABProjectList *)projectList {
   [self.projectListsArray addObject:projectList];
}


- (ABProjectList *)checkExistInSubDirectoryWithObjectName:(NSString *)sqliteObjectName {
   for (ABProjectList * sqliteObject in self.lastsubDirectoryListsArray) {
      if ([sqliteObject.sqliteObjectName isEqualToString:sqliteObjectName]) {
         return sqliteObject;
      }
   }
   return nil;
}
@end
