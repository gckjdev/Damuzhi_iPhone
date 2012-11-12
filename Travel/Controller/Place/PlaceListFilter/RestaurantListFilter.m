//
//  RestaurantListFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "RestaurantListFilter.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "CommonPlaceListFilter.h"
#import "App.pb.h"
#import "AppService.h"

@implementation RestaurantListFilter

- (void)dealloc
{
    [super dealloc];
}

#pragma - mark PlaceListFilterProtocol
#define FILTER_BUTTON_WIDTH 58
#define FILTER_BUTTON_HEIGHT 36
- (void)createFilterButtons:(UIView*)superView controller:(PPViewController*)commonPlaceController
{
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"菜系")];
    [button1 addTarget:commonPlaceController action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
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
    RestaurantListFilter* filter = [[[RestaurantListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PlaceCategoryTypePlaceRestraurant;
}

- (NSString*)getCategoryName
{
    return NSLS(@"餐馆");
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(PlaceSelectedItemIds *)selectedItemIds
{
    CLLocation *currentLocation = [[AppService defaultService] currentLocation];
    
    NSArray *placeList1 = [CommonPlaceListFilter filterPlaceList:placeList bySubCategoryIdList:selectedItemIds.subCategoryItemIds]; 
    
    NSArray *placeList2 = [CommonPlaceListFilter filterPlaceList:placeList1 byAreaIdList:selectedItemIds.areaItemIds];

    NSArray *placeList3 = [CommonPlaceListFilter filterPlaceList:placeList2 byServiceIdList:selectedItemIds.serviceItemIds];
    
    NSArray *resultList = [CommonPlaceListFilter sortPlaceList:placeList3 bySortId:[selectedItemIds.sortItemIds objectAtIndex:0] currentLocation:currentLocation];
    
    return resultList;
}

@end
