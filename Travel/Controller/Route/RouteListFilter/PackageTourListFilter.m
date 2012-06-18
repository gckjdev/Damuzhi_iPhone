//
//  PackageTourListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-6-6.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PackageTourListFilter.h"
#import "CommonRouteListFilter.h"
#import "RouteService.h"
#import "TravelNetworkConstants.h"

#define LEFT_EDGE 20
#define TOP_EDGE 5
#define BTN_EDGE 10

@implementation PackageTourListFilter

+ (NSObject<RouteListFilterProtocol>*)createFilter
{
    PackageTourListFilter* filter = [[[PackageTourListFilter alloc] init] autorelease];
    return filter;
}

- (int)getRouteType
{
    return OBJECT_LIST_ROUTE_PACKAGE_TOUR;
}

- (NSString*)getRouteTypeName
{
    return NSLS(@"跟团游");
}

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller
{
    CGFloat origin_x = LEFT_EDGE;
    CGRect rect1 = CGRectMake(origin_x, TOP_EDGE, 40, 20);
    UIButton *departFilterBtn = [CommonRouteListFilter createFilterButton:rect1 title:[NSString stringWithFormat:NSLS(@"出发:%@"), @""]];
    departFilterBtn.tag = TAG_FILTER_BTN_DEPART_CITY;
    [superView addSubview:departFilterBtn];
    
    origin_x = departFilterBtn.frame.size.width + departFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect2 = CGRectMake(origin_x + BTN_EDGE, TOP_EDGE, 40, 20);
    UIButton *destFilterBtn = [CommonRouteListFilter createFilterButton:rect2 title:NSLS(@"目的地")];
    destFilterBtn.tag = TAG_FILTER_BTN_DESTINATION_CITY;
    [superView addSubview:destFilterBtn];
    
    origin_x = destFilterBtn.frame.size.width + destFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect3 = CGRectMake(LEFT_EDGE, TOP_EDGE, 40, 20);
    UIButton *agencyFilterBtn = [CommonRouteListFilter createFilterButton:rect3 title:NSLS(@"旅行社")];
    agencyFilterBtn.tag = TAG_FILTER_BTN_AGENCY;
    [superView addSubview:agencyFilterBtn];
    
    origin_x = agencyFilterBtn.frame.size.width + agencyFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect4 = CGRectMake(LEFT_EDGE, TOP_EDGE, 40, 20);
    UIButton *classifyFilterBtn = [CommonRouteListFilter createFilterButton:rect4 title:NSLS(@"筛选")];
    classifyFilterBtn.tag = TAG_FILTER_BTN_CLASSIFY;
    [superView addSubview:classifyFilterBtn];
    
    origin_x = classifyFilterBtn.frame.size.width + classifyFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect5 = CGRectMake(LEFT_EDGE, TOP_EDGE, 40, 20);
    UIButton *sortBtn = [CommonRouteListFilter createFilterButton:rect5 title:NSLS(@"排序")];
    sortBtn.tag = TAG_SORT_BTN;
    [superView addSubview:sortBtn];
}

- (void)findRoutesWithDepartCityId:(int)departCityId
                 destinationCityId:(int)destinationCityId
                             start:(int)start
                             count:(int)count
                    viewController:(PPViewController<RouteServiceDelegate>*)viewController
{
    [[RouteService defaultService] findRoutesWithType:[self getRouteType]
                                         departCityId:departCityId
                                    destinationCityId:destinationCityId 
                                                start:start 
                                                count:count 
                                       viewController:viewController];
    return;
}

@end
