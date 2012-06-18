//
//  SelectedItemIdsManager.h
//  Travel
//
//  Created by 小涛 王 on 12-4-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedItemIds : NSObject

@property (retain, nonatomic) NSMutableArray *subCategoryItemIds;
@property (retain, nonatomic) NSMutableArray *sortItemIds;
@property (retain, nonatomic) NSMutableArray *areaItemIds;
@property (retain, nonatomic) NSMutableArray *priceRankItemIds;
@property (retain, nonatomic) NSMutableArray *serviceItemIds;
@property (retain, nonatomic) NSMutableArray *cuisineItemIds;

- (void)resetAll;

@end
