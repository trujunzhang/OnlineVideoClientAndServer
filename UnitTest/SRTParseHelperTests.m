//
//  SRTParseHelperTests.m
//  OnlineVideoClient
//
//  Created by djzhang on 1/16/15.
//  Copyright (c) 2015 djzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SOSubtitle.h"
#import "BFTask.h"
#import "SOSRTParserHelper.h"
#import "SDSRTParserHelper.h"

@interface SRTParseHelperTests : XCTestCase

@end

@implementation SRTParseHelperTests {
    SOSRTParserHelper *parserHelper;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSDSRTParserHelper {
    NSString *fileName = @"Alexander the Great";
    NSString *stringFromFile = [self readStringFromFile:fileName];

    parserHelper = [[SDSRTParserHelper alloc] init];

    NSMutableDictionary *subtitlesParts = [NSMutableDictionary dictionary];

    void (^completion)(BOOL, NSError *) = ^(BOOL b, NSError *error) {
        NSMutableDictionary *subtitlesPartsReturn = subtitlesParts;
        NSString *debug = @"debug";
    };
    [parserHelper parseSRTString:stringFromFile
                    toDictionary:subtitlesParts
                          parsed:completion];

}

- (void)testSOSRTParserHelper {
    NSString *fileName = @"Alexander the Great";
    NSString *stringFromFile = [self readStringFromFile:fileName];

    parserHelper = [[SOSRTParserHelper alloc] init];

    NSMutableDictionary *subtitlesParts = [NSMutableDictionary dictionary];

    void (^completion)(BOOL, NSError *) = ^(BOOL b, NSError *error) {
        NSMutableDictionary *subtitlesPartsReturn = subtitlesParts;
        NSString *debug = @"debug";
    };
    [parserHelper parseSRTString:stringFromFile
                    toDictionary:subtitlesParts
                          parsed:completion];

}


- (void)testExampleForAlexander {
    int expect = 1264;

    NSString *fileName = @"Alexander the Great";
    NSMutableArray *array = [self parseSRTToArray:fileName expect:expect];
}

- (void)testExampleForReagan {
    int expect = 1593;

    NSString *fileName = @"1980 Presidential Candidate Debate  Governor Ronald Reagan and President Jimmy Carter - 10 28 80";
    NSMutableArray *array = [self parseSRTToArray:fileName expect:expect];
}

- (void)testExampleForSherlock {
    int expect = 685;

    NSString *fileName = @"The Adventures Of Sherlock Holmes - S01E01 - A Scandal In Bohemia";
    NSMutableArray *array = [self parseSRTToArray:fileName expect:expect];
}

#pragma mark -
#pragma mark common methond

- (NSMutableArray *)parseSRTToArray:(NSString *)fileName expect:(int)expect {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"srt"];
    SOSubtitle *soSubtitle = [[SOSubtitle alloc] init];
    BFTask *task = [soSubtitle subtitleFromFile:filePath];
    SOSubtitle *resultSubtitle = [task result];
    NSMutableArray *array = [resultSubtitle subtitleItems];

    XCTAssertEqual(array.count, expect, "equal");
    return array;
}


- (NSString *)readStringFromFile:(NSString *)fileName {
    NSString *localSRTFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"srt"];
    // Error
    NSError *error = nil;


    // File to string
    NSString *subtitleString = [NSString stringWithContentsOfFile:localSRTFile
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
    return subtitleString;
}


@end
