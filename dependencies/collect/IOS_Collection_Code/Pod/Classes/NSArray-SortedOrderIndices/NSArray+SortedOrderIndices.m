//
//  NSArray+SortedOrderIndices.m
//  deneme
//
//  Created by Guven Iscan on 13/04/14.
//  Copyright (c) 2014 Guven Iscan. All rights reserved.
//

#import "NSArray+SortedOrderIndices.h"

@implementation NSArray (SortedOrderIndices)

-(NSArray *) sortedOrderIndices
{
    return [self sortedOrderIndicesAscending:TRUE];
}

-(NSArray *) sortedOrderIndicesAscending:(BOOL) ascending
{
    //Wrap array's objects into nsdictionaries
    NSMutableArray *wrappedObjs = [NSMutableArray array];
    for (NSInteger i = 0; i < self.count; i++)
    {
        [wrappedObjs addObject:@{@"value": self[i], @"index":@(i)}];
    }
    
    //Specify the value field as sort criteria and sort
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:ascending];
    [wrappedObjs sortUsingDescriptors:@[sd]];
    
    //Fetch and return indices of sorted array
    return [wrappedObjs valueForKey:@"index"];
}

@end
