//
//  JPSRTParser.m
//  JPSRTParser
//
//  Created by Juan Pedro Catalán on 02/10/13.
//  Copyright (c) 2013 Juanpe Catalán. All rights reserved.
//

#import "JPSRTParser.h"
#import "JPSRTParserNode.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@interface JPSRTParser ()

- (NSTimeInterval) _timeIntervalFromTimeString:(NSString*)timeString;

@end

static const char kCompletionBlockKey;

#define kDEFAULT_ENCODE_TYPE        NSUTF8StringEncoding
#define kDEFAULT_SRT_DATE_FORMAT    @"HH:mm:ss,SSS"
#define kCR                         @"\r"
#define kCRLFCRLF                   @"\r\n\r\n"
#define kCRLF                       @"\r\n"
#define kLF                         @"\n"
#define kTIME_SEPARATOR             @" --> "

@implementation JPSRTParser

NSString * const JPSRTFileAvailableNotification = @"JPSRTFileAvailableNotification";
NSString * const JPErrorParsingSRTNotification  = @"JPErrorParsingSRTNotification";
NSString * const JPErrorGetSRTFileNotification  = @"JPErrorGetSRTFileNotification";

#pragma mark - Block 
- (void) setCompletionBlock:(JPSRTParserCompletionBlock)completionBlock{
    objc_setAssociatedObject(self, &kCompletionBlockKey, completionBlock, OBJC_ASSOCIATION_COPY);
}

- (JPSRTParserCompletionBlock) completionBlock{

  return objc_getAssociatedObject(self, &kCompletionBlockKey);
}

#pragma mark - Initialization

- (id) initWithContentOfSRTFile:(NSString *) srtFilePath{

    self = [super init];
    if (self) {
        
        //
        // SRT Path
        //
        self.srtFilePath            = srtFilePath;
        
        //
        // Date format
        //
        _dateFormatter              = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat   = kDEFAULT_SRT_DATE_FORMAT;
        
        //
        // Encoding
        //
        _srtEncodeType              = kDEFAULT_ENCODE_TYPE;
        
        //
        // Obtain SRT string
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError	*error				= nil;
            self.srtStringValue         = [NSString stringWithContentsOfFile:_srtFilePath
                                                                    encoding:self.srtEncodeType
                                                                       error:&error];
            if (!error && self.srtStringValue) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JPSRTFileAvailableNotification
                                                                    object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:JPErrorGetSRTFileNotification
                                                                    object:nil];
            }
        });
        
    }
    return self;
}

- (id) initWithContentOfSRTURL:(NSURL *) srtURL{

    self = [super init];
    if (self) {
        
        //
        // SRT URL
        //
        self.srtURL                 = srtURL;
        
        //
        // Date format
        //
        _dateFormatter              = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat   = kDEFAULT_SRT_DATE_FORMAT;
        
        //
        // Encoding
        //
        _srtEncodeType              = kDEFAULT_ENCODE_TYPE;
        
        //
        // Obtain SRT string
        //
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSError	*error				= nil;
            self.srtStringValue         = [NSString stringWithContentsOfURL:_srtURL
                                                                   encoding:self.srtEncodeType
                                                                      error:&error];
            
            if (!error && self.srtStringValue) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JPSRTFileAvailableNotification
                                                                    object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:JPErrorGetSRTFileNotification
                                                                    object:nil];
            }
        });
    }
    return self;
}

#pragma mark - Parse
- (NSArray *) parse{
    
    NSMutableArray*     subtitles	= [NSMutableArray array];
    
    if (self.srtStringValue) {
        
        NSMutableArray*     tempArray   = (NSMutableArray *)[self.srtStringValue componentsSeparatedByString:kLF];
        
        NSInteger blockIndex            = 0;
        JPSRTParserNode*  item          = nil;
        NSInteger indexArray            = 0;
        
        for (NSString* itemString in tempArray) {
            
            NSString* tempString = [itemString stringByReplacingOccurrencesOfString:kCR withString:@""];
            
            if (blockIndex == 0) {
                
                item        = [[JPSRTParserNode alloc] init];
                item.index  = [tempString intValue];
                blockIndex  = 1;
                
            }else if(blockIndex == 1){
                
                NSArray* timeArrayN1        = [tempString componentsSeparatedByString:@"-->"];
                
                NSTimeInterval subStartTime	= [self _timeIntervalFromTimeString:[timeArrayN1 objectAtIndex:0]];
                item.beginTime              = subStartTime;
                
                NSTimeInterval subEndTime	= [self _timeIntervalFromTimeString:[timeArrayN1 objectAtIndex:1]];
                item.endTime                = subEndTime;
                
                blockIndex = 2;
                
            }else if (blockIndex == 2){
                if (item.nodeText && ![item.nodeText isEqualToString:@""]) {
                    
                    item.nodeText	= [item.nodeText stringByAppendingString:@" "];
                    item.nodeText	= [item.nodeText stringByAppendingString:[NSString stringWithUTF8String:[tempString UTF8String]]];
                    blockIndex      = 3;
                    
                }else{
                    
                    item.nodeText           = [NSString stringWithUTF8String:[tempString UTF8String]];
                    NSInteger currentIndex  = indexArray + 1;
                    
                    if ([[[tempArray objectAtIndex:currentIndex]stringByReplacingOccurrencesOfString:kCR withString:@""] isEqualToString:@""])
                        blockIndex = 3;
                    else
                        blockIndex = 2;
                    
                }
            }else if (blockIndex == 3){
                [subtitles addObject:item];
                blockIndex = 0;
            }
            indexArray++;
        }
    }else{
        if (self.completionBlock) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.completionBlock(JPSRTParsingStateFailed, nil);
                
            });
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JPErrorParsingSRTNotification
                                                                object:nil];
            
        }
        
        return nil;
    }
    
    if (self.completionBlock) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.completionBlock(JPSRTParsingStateCompleted, subtitles);
            
        });
    }else{
        
        return [NSArray arrayWithArray:subtitles];
    }
    return nil;
}

- (void) parseCompletion:(JPSRTParserCompletionBlock)completionBlock{

    self.completionBlock = completionBlock;
    
    [self performSelectorInBackground:@selector(parse) withObject:nil];
}

#pragma mark Private

- (NSTimeInterval) _timeIntervalFromTimeString:(NSString*)timeString{
    
    NSArray* separatedTime      = [timeString componentsSeparatedByString:@":"];
    CGFloat hours               = [[separatedTime objectAtIndex:0] floatValue];
    CGFloat minutes             = [[separatedTime objectAtIndex:1] floatValue];
    
    NSArray* separatedSeconds   = [[separatedTime objectAtIndex:2] componentsSeparatedByString:@","];
    
    CGFloat seconds             = [[separatedSeconds objectAtIndex:0] floatValue];
    CGFloat miliseconds         = [[separatedSeconds objectAtIndex:1] floatValue]/1000.0f;
    
    return ((hours * 360.0f) + (minutes * 60.0f) + seconds + miliseconds);
}

@end
	