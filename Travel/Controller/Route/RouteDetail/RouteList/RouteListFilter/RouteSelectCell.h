//
//  RouteSelectCell.h
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"

#define HEIGHT_SELECT_BUTTON 46
#define NUM_OF_SELECT_BUTTON_IN_LINE 4

@interface RouteSelectCell : PPTableViewCell

- (void)setCellData:(NSArray *)itemList
    selectedItemIds:(NSMutableArray *)selectedItemIds
       multiOptions:(BOOL)multiOptions
        needConfirm:(BOOL)needConfirm
      needShowCount:(BOOL)needShowCount;

@end
