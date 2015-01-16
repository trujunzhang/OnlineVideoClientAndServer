//
//  JPSRTParserNode.h
//  JPSRTParser
//
//  Created by Juan Pedro Catalán on 02/10/13.
//  Copyright (c) 2013 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPSRTParserNode : NSObject

#pragma mark - Properties
@property (nonatomic, assign)   NSUInteger        index;
@property (nonatomic, assign)   NSTimeInterval    beginTime;
@property (nonatomic, assign)   NSTimeInterval    endTime;
@property (nonatomic, copy)     NSString*         nodeText;

#pragma mark - Methods
- (id) initWithData:(NSDictionary *) nodeData;
- (id) initWithIndex:(NSInteger) nodeIndex
        andBeginTime:(NSTimeInterval) nodeBeginTime
          andEndTime:(NSTimeInterval) nodeEndTime
         andNodeText:(NSString *) text;

@end
