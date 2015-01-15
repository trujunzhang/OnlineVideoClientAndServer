//
// Created by djzhang on 12/28/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsFileInfoVideoCollectionViewController.h"


@interface AsFileInfoVideoCollectionViewController ()<YoutubeCollectionNextPageDelegate> {

}
@end


@implementation AsFileInfoVideoCollectionViewController {

}

- (instancetype)initWithTitle:(NSString *)title withProjectListArray:(NSMutableArray *)projectListArray {
    self = [super initWithNextPageDelegate:self
                                 withTitle:title
                      withProjectListArray:projectListArray];
    if(self) {
        [self executeRefreshTask];
    }

    return self;
}


#pragma mark -
#pragma mark YoutubeCollectionNextPageDelegate


- (void)executeRefreshTask {
    [self fetchVideoListFromChannel];
}


- (void)executeNextPageTask {
    [self fetchVideoListFromChannelByPageToken];
}


@end