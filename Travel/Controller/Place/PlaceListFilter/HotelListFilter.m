//
//  HoteListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-3-12.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "HotelListFilter.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "CommonPlaceListFilter.h"
#import "App.pb.h"
#import "AppService.h"

@implementation HotelListFilter

- (void)dealloc
{
    [super dealloc];
}

#pragma - mark PlaceListFilterProtocol
- (void)createFilterButtons:(UIView*)superView controller:(PPViewController*)commonPlaceController
{
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"价格")];
    [button1 addTarget:commonPlaceController action:@selector(clickPrice:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button1];

    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button2 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"区域")];
    [button2 addTarget:commonPlaceController action:@selector(clickArea:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button2];
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button3 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"服务")];
    [button3 addTarget:commonPlaceController action:@selector(clickService:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button3];

    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button4 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"排序")];
    [button4 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag = SORT_BUTTON_TAG;
    [superView addSubview:button4];
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    HotelListFilter* filter = [[[HotelListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PlaceCategoryTypePlaceHotel;
}

- (NSString*)getCategoryName
{
    return NSLS(@"酒店");
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(PlaceSelectedItemIds *)selectedItemIds
{
    CLLocation *currentLocation = [[AppService defaultService] currentLocation];
    
    NSArray *placeList1 = [CommonPlaceListFilter filterPlaceList:placeList byPriceIdList:selectedItemIds.priceRankItemIds];
    
    NSArray *placeList2 = [CommonPlaceListFilter filterPlaceList:placeList1 byAreaIdList:selectedItemIds.areaItemIds];
    
    NSArray *placeList3 = [CommonPlaceListFilter filterPlaceList:placeList2 byServiceIdList:selectedItemIds.serviceItemIds];
    
    NSArray *resultList = [CommonPlaceListFilter sortPlaceList:placeList3 bySortId:[selectedItemIds.sortItemIds objectAtIndex:0] currentLocation:currentLocation];
    
    return resultList;
}

@end
