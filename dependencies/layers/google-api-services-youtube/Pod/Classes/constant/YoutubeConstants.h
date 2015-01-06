#ifdef __OBJC__


//================================================================================================
// Google-client-api
//================================================================================================
// module
#import "ABProjectFileInfo.h"
#import "ABProjectName.h"
#import "ABProjectList.h"
#import "ABProjectType.h"

// common
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// other
#import "YoutubeVideoCache.h"


#endif

//#define hasLocalSqliteFile NO
#define hasLocalSqliteFile YES


//#define hasShowLeftMenu NO
#define hasShowLeftMenu YES


#define SUBSCRIPTION_LIST_MAX 2
#define subscriptionIndex  0
#define debugLeftMenuTapSubscription NO
//#define debugLeftMenuTapSubscription YES

#define debugCollectionViewToDetail  NO
//#define debugCollectionViewToDetail  YES

#define debugCollectionViewToDetail_local  NO
//#define debugCollectionViewToDetail_local  YES


// module

//#define YTYouTubeVideo  GTLYouTubeVideo
//#define YTYouTubeVideo  MABYT3_Video

#define YTYouTubeVideoCache  ABProjectFileInfo

#define YTYouTubePlayList  ABProjectList
#define YTYouTubePlaylistItem  GTLYouTubePlaylistItem

// Channel for other request
#define YTYouTubeChannel  ABProjectName

#define YTYouTubeType  ABProjectType

#if debugLeftMenuTapSubscription == YES
#define YTYouTubeSubscription  MABYT3_Subscription
#elif debugLeftMenuTapSubscription == NO
#define YTYouTubeSubscription  GTLYouTubeSubscription
#endif

#define YTYouTubeMABThumbmail  MABYT3_Thumbnail

//
#define YTServiceYouTube  GTLServiceYouTube
#define YTOAuth2Authentication  GTMOAuth2Authentication




//
#define YTQueryYouTube  GTLQueryYouTube


// different
//#define YTYouTubeSearchResult  GTLYouTubeSearchResult
#define YTYouTubeSearchResult  MABYT3_SearchItem

#define YTYouTubeActivity  MABYT3_Activity
#define YTYouTubeActivityContentDetails  MABYT3_ActivityContentDetails
#define YTYouTubeResourceId  MABYT3_ResourceId


















