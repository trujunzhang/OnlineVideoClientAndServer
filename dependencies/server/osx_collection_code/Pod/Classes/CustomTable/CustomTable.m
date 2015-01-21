//
//  CustomTable.m
//  TableSelectionDemo
//
//  Created by Kumaran Venkataraman on 08/09/11.
//  Copyright 2011 Wings. All rights reserved.
//

#import "CustomTable.h"

@implementation CustomTable
@synthesize selectedCellRowIndex, selectedCellColumnIndex, customSelectedCell;

- (id)init {
    self = [super init];
    if(self) {
        // Initialization code here.
        selectedCellRowIndex = [[NSNumber alloc] init];
        selectedCellColumnIndex = [[NSNumber alloc] init];
        customSelectedCell = [[NSCell alloc] init];
    }

    return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];

    // which column and cell has been hit?

    long column = [self columnAtPoint:p];
    long row = [self rowAtPoint:p];

    /* The following lines can be used if you want to retrieve the selected cell instead of the row/column indices 
    */
    if(column == -1 || row == -1) {

    }
    else {
        NSTableColumn *theColumn = [[self tableColumns] objectAtIndex:column];
        NSCell *dataCell = [theColumn dataCellForRow:row];

        [self setSelectedCellRowIndex:[NSNumber numberWithLong:row]];
        [self setSelectedCellColumnIndex:[NSNumber numberWithLong:column]];
        [self setCustomSelectedCell:dataCell];
    }
    [super mouseDown:theEvent];
}

@end
