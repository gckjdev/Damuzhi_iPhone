//
//  SpotListFilter.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotListFilter.h"
#import "PlaceService.h"
#import "AppManager.h"
#import "Place.pb.h"
#import "CityOverviewService.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "CommonPlaceListFilter.h"
#import "App.pb.h"
#import "AppService.h"

@implementation SpotListFilter

- (void)dealloc
{
    [super dealloc];
}

#pragma Protocol Implementations

- (int)getCategoryId
{
    return PlaceCategoryTypePlaceSpot; // TODO change to constants
}

- (NSString*)getCategoryName
{
    return NSLS(@"景点");
}

- (void)createFilterButtons:(UIView*)superView controller:(PPViewController *)commonPlaceController
{    
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"分类")];
    [button1 addTarget:commonPlaceController action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button1];
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button2 = [CommonPlaceListFilter createFilterButton:frame title:NSLS(@"排序")];
    [button2 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = SORT_BUTTON_TAG;
    [superView addSubview:button2];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    SpotListFilter* filter = [[[SpotListFilter alloc] init] autorelease];
    return filter;
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(PlaceSelectedItemIds *)selectedItemIds
{
    CLLocation *currentLocation = [[AppService defaultService] currentLocation];
    
    NSArray *placeList1 = [CommonPlaceListFilter filterPlaceList:placeList bySubCategoryIdList:selectedItemIds.subCategoryItemIds];
    
    NSArray *resultList = [CommonPlaceListFilter sortPlaceList:placeList1 bySortId:[selectedItemIds.sortItemIds objectAtIndex:0] currentLocation:currentLocation];
    
    return resultList;
}

@end
