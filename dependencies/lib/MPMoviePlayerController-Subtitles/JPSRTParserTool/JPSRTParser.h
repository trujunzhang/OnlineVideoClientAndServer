//
//  JPSRTParser.h
//  JPSRTParser
//
//  Created by Juan Pedro Catalán on 02/10/13.
//  Copyright (c) 2013 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Posted when SRT file has been downloaded.
 */
extern NSString * const JPSRTFileAvailableNotification;

/*
 * Posted when SRT file can't load.
 */
extern NSString * const JPErrorGetSRTFileNotification;

/*
 * Posted when SRT parsing process fail
 */
extern NSString * const JPErrorParsingSRTNotification;

typedef NS_ENUM(NSUInteger, JPSRTParsingState) {
    JPSRTParsingStateCompleted,
    JPSRTParsingStateFailed
};

typedef void (^JPSRTParserCompletionBlock)(JPSRTParsingState status, NSArray* subtitles);

@interface JPSRTParser : NSObject

#pragma mark - Properties
@property (nonatomic, copy)     NSString* srtFilePath;
@property (nonatomic, copy)     NSURL* srtURL;
@property (nonatomic, copy)     NSString* srtStringValue;
@property (nonatomic, copy)     NSDateFormatter* dateFormatter;;
@property (nonatomic, copy)     JPSRTParserCompletionBlock completionBlock;
@property (nonatomic, assign)   NSStringEncoding srtEncodeType;

#pragma mark - Methods
- (id) initWithContentOfSRTFile:(NSString *) srtFilePath;
- (id) initWithContentOfSRTURL:(NSURL *) srtURL;

- (NSArray *) parse;
- (void) parseCompletion:(JPSRTParserCompletionBlock)completionBlock;

@end
