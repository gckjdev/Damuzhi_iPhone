//
//  EntertainmentListFilter.m
//  Travel
//
//  Created by haodong qiu on 12年3月30日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "EntertainmentListFilter.h"
#import "CommonPlace.h"
#import "PlaceService.h"
#import "LogUtil.h"
#import "CommonListFilter.h"
#import "App.pb.h"
#import "AppService.h"

@implementation EntertainmentListFilter

- (void)dealloc
{
    [super dealloc];
}

#pragma - mark PlaceListFilterProtocol
#define FILTER_BUTTON_WIDTH 58
#define FILTER_BUTTON_HEIGHT 36
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)commonPlaceController
{
    CGRect frame = CGRectMake(0, superView.frame.size.height/2-HEIGHT_OF_FILTER_BUTTON/2, WIDTH_OF_FILTER_BUTTON, HEIGHT_OF_FILTER_BUTTON);
    
    frame.origin.x += 10;
    UIButton *button1 = [CommonListFilter createFilterButton:frame title:NSLS(@"分类")];
    [button1 addTarget:commonPlaceController action:@selector(clickCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button1];
    button1.tag = 1;
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button2 = [CommonListFilter createFilterButton:frame title:NSLS(@"区域")];
    [button2 addTarget:commonPlaceController action:@selector(clickArea:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button2];
    
    frame.origin.x += WIDTH_OF_FILTER_BUTTON+DISTANCE_BETWEEN_BUTTONS;
    UIButton *button3 = [CommonListFilter createFilterButton:frame title:NSLS(@"排序")];
    [button3 addTarget:commonPlaceController action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = SORT_BUTTON_TAG;
    [superView addSubview:button3];
}

- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
{
    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
}

+ (NSObject<PlaceListFilterProtocol>*)createFilter
{
    EntertainmentListFilter* filter = [[[EntertainmentListFilter alloc] init] autorelease];
    return filter;
}

- (int)getCategoryId
{
    return PlaceCategoryTypePlaceEntertainment;
}

- (NSString*)getCategoryName
{
    return NSLS(@"娱乐");
}

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(SelectedItems *)selectedItems
{
    CLLocation *currentLocation = [[AppService defaultService] currentLocation];
    
    NSArray *afterCategoryFilter = [CommonListFilter filterBySelectedSubCategoryIdList:placeList selectedSubCategoryIdList:selectedItems.selectedSubCategoryIdList ];
    NSArray *afterAreaFilter = [CommonListFilter filterBySelectedAreaIdList:afterCategoryFilter selectedAreaIdList:selectedItems.selectedAreaIdList];
    NSArray *resultList = [CommonListFilter sortBySelectedSortId:afterAreaFilter selectedSortId:[selectedItems.selectedSortIdList objectAtIndex:0] currentLocation:currentLocation];
    return resultList;
}

@end
