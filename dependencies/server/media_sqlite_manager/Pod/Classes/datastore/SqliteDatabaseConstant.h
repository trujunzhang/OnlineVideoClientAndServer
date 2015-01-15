static NSString *const dataBaseName = @"VideoTrainingDB.db";
static NSString *const imageDataBaseName = @"imageDB.db";

static NSString *const thumbnailPrefix = @"TH_";
static NSString *const thumbnailFolder = @"thumbnail";
static NSString *const appCacheDirectory = @".cache";

typedef void(^ReportResultsBlock)(NSArray *reports);

typedef void(^LocationResultsBlock)(NSArray *locations);

