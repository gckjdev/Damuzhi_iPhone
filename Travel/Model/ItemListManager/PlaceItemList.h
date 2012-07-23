//
//  ItemList.h
//  Travel
//
//  Created by 小涛 王 on 12-7-16.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceItemList : NSObject

@property (retain, nonatomic) NSArray *subCategoryItems;
@property (retain, nonatomic) NSArray *sortItems;
@property (retain, nonatomic) NSArray *areaItems;
@property (retain, nonatomic) NSArray *priceRankItems;
@property (retain, nonatomic) NSArray *serviceItems;

@end
