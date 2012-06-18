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

@property (retain, nonatomic) PlaceSelectedItemIds *spotSelectedItems;
@property (retain, nonatomic) PlaceSelectedItemIds *hotelSelectedItems;
@property (retain, nonatomic) PlaceSelectedItemIds *restaurantSelectedItems;
@property (retain, nonatomic) PlaceSelectedItemIds *shoppingSelectedItems;
@property (retain, nonatomic) PlaceSelectedItemIds *entertainmentSelectedItems;

@property (retain, nonatomic) RouteSelectedItemIds *packageTourSelectedItems;
@property (retain, nonatomic) RouteSelectedItemIds *unPackageTourSelectedItems;

- (PlaceSelectedItemIds*)getPlaceSelectedItems:(int)categoryId;
//- (void)resetPlaceSelectedItems:(int)categoryId;

- (RouteSelectedItemIds*)getRouteSelectedItems:(int)routeType;
//- (void)resetRouteSelectedItems:(int)routeType;

@end
