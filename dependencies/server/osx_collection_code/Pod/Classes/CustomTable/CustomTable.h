//
//  CustomTable.h
//  TableSelectionDemo
//
//  Created by Kumaran Venkataraman on 08/09/11.
//  Copyright 2011 Wings. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomTable : NSTableView {
    NSNumber *selectedCellRowIndex;
    NSNumber *selectedCellColumnIndex;
    NSCell *customSelectedCell;
}

@property (nonatomic, retain) NSNumber *selectedCellRowIndex;
@property (nonatomic, retain) NSNumber *selectedCellColumnIndex;
@property (nonatomic, retain) NSCell *customSelectedCell;
@end
