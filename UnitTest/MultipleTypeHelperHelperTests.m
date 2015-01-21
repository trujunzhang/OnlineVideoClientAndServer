//
//  MultipleTypeHelperHelperTests.m
//  OnlineVideoClient
//
//  Created by djzhang on 1/2/15.
//  Copyright (c) 2015 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Expecta.h"
#import "ABOnlineVideoTypeStore.h"
#import "MultipleTypeHelper.h"

@interface MultipleTypeHelperHelperTests : XCTestCase
@property (nonatomic, strong) ABOnlineVideoTypeStore *onlineVideoTypeStore;
@end


@implementation MultipleTypeHelperHelperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.onlineVideoTypeStore = [[ABOnlineVideoTypeStore alloc] init];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExample {
    NSMutableArray *videoTypeArray = [self.onlineVideoTypeStore getTheSameVideoTypeArray];

    NSMutableArray *array = [MultipleTypeHelper getSingleOnlineVideoTypesArray:videoTypeArray];

    NSString *debug = @"debug";
}


@end
