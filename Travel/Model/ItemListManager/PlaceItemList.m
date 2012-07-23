//
//  ItemList.m
//  Travel
//
//  Created by 小涛 王 on 12-7-16.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceItemList.h"

@implementation PlaceItemList

@synthesize subCategoryItems;
@synthesize areaItems;
@synthesize serviceItems;
@synthesize priceRankItems;
@synthesize sortItems;

- (void)dealloc
{
    [subCategoryItems release];
    [areaItems release];
    [serviceItems release];
    [priceRankItems release];
    [sortItems release];
    
    [super dealloc];
}

@end
