//
// Created by djzhang on 1/6/15.
// Copyright (c) 2015 mhergon. All rights reserved.
//

#import "SRTParserHelper.h"


@implementation SRTParserHelper {

}

- (instancetype)init {
    self = [super init];
    if(self) {

    }

    return self;
}


- (void)parseSRTString:(NSString *)string toDictionary:(NSMutableDictionary *)subtitlesParts parsed:(void (^)(BOOL parsed, NSError *error))completion {

    // Create Scanner
    NSScanner *scanner = [NSScanner scannerWithString:string];

    // Search for members
    while (!scanner.isAtEnd) {

        // Variables
        NSString *indexString;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&indexString];

        NSString *startString;
        [scanner scanUpToString:@" --> " intoString:&startString];
        [scanner scanString:@"-->" intoString:NULL];

        NSString *endString;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&endString];


        NSString *textString;
        [scanner scanUpToString:@"\r\n\r\n" intoString:&textString];
        textString = [textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        // Regular expression to replace tags
        NSError *error = nil;
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"[<|\\{][^>|\\^}]*[>|\\}]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
        if(error) {
            completion(NO, error);
            return;
        }

        textString = [regExp stringByReplacingMatchesInString:textString.length > 0 ? textString : @""
                                                      options:0
                                                        range:NSMakeRange(0, textString.length)
                                                 withTemplate:@""];


        // Temp object
        NSTimeInterval startInterval = [self timeFromString:startString];
        NSTimeInterval endInterval = [self timeFromString:endString];
        NSDictionary *tempInterval = @{
                kIndex : indexString,
                kStart : @(startInterval),
                kEnd : @(endInterval),
                kText : textString ? textString : @""
        };
        [subtitlesParts setObject:tempInterval
                           forKey:indexString];

    }

    if(completion != NULL) {
        completion(YES, nil);
    }
}


- (NSTimeInterval)timeFromString:(NSString *)timeString {

    NSScanner *scanner = [NSScanner scannerWithString:timeString];

    int h, m, s, c;
    [scanner scanInt:&h];
    [scanner scanString:@":" intoString:NULL];
    [scanner scanInt:&m];
    [scanner scanString:@":" intoString:NULL];
    [scanner scanInt:&s];
    [scanner scanString:@"," intoString:NULL];
    [scanner scanInt:&c];

    return (h * 3600) + (m * 60) + s + (c / 1000.0);

}


@end