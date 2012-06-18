//
//  SelectedItemsManager.h
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "SelectedItemIds.h"

@interface SelectedItemIdsManager : NSObject <CommonManagerProtocol>

@property (retain, nonatomic) SelectedItemIds *spotSelectedItems;
@property (retain, nonatomic) SelectedItemIds *hotelSelectedItems;
@property (retain, nonatomic) SelectedItemIds *restaurantSelectedItems;
@property (retain, nonatomic) SelectedItemIds *shoppingSelectedItems;
@property (retain, nonatomic) SelectedItemIds *entertainmentSelectedItems;

- (SelectedItemIds*)getSelectedItems:(int)categoryId;
- (void)resetAllSelectedItems;

@end
