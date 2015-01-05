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

      self.projectDownloadUrl = @"";
      self.projectAbstractPath = @"";

      self.projectLists = [[NSMutableArray alloc] init];
   }

   return self;
}


- (instancetype)initWithProjectName:(NSString *)projectName {
   self = [self init];
   if (self) {
      self.sqliteObjectName = projectName;
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
   [dictionary setObject:self.projectDownloadUrl forKey:@"projectDownloadUrl"];
   [dictionary setObject:self.projectAbstractPath forKey:@"projectAbstractPath"];

   return dictionary;
}


- (NSMutableDictionary *)getInsertDictionary {

   return [self getUpdateDictionary];
}


- (void)appendProjectList:(ABProjectList *)projectList {
   [self.projectLists addObject:projectList];
}
@end
