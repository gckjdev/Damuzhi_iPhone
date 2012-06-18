//
//  UnPackageTourListFilter.m
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "UnPackageTourListFilter.h"
#import "TravelNetworkConstants.h"
#import "CommonRouteListFilter.h"

#define LEFT_EDGE 5
#define TOP_EDGE 5
#define BTN_EDGE 8
#define HEIGHT_FILTER_BTN 27

@implementation UnPackageTourListFilter

+ (NSObject<RouteListFilterProtocol>*)createFilter
{
    UnPackageTourListFilter* filter = [[[UnPackageTourListFilter alloc] init] autorelease];
    return filter;
}

- (int)getRouteType
{
    return OBJECT_LIST_ROUTE_UNPACKAGE_TOUR;
}

- (NSString*)getRouteTypeName
{
    return NSLS(@"自由行");
}

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller
{
    CGFloat origin_x = LEFT_EDGE;
    CGFloat origin_y = superView.frame.size.height/2-HEIGHT_FILTER_BTN/2;
    
    CGRect rect3 = CGRectMake(origin_x, origin_y, 60, HEIGHT_FILTER_BTN);
    UIButton *agencyFilterBtn = [CommonRouteListFilter createFilterButton:rect3 title:NSLS(@"旅行社")];
    agencyFilterBtn.tag = TAG_FILTER_BTN_AGENCY;
    [superView addSubview:agencyFilterBtn];
    
    origin_x = agencyFilterBtn.frame.size.width + agencyFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect4 = CGRectMake(origin_x, origin_y, 50, HEIGHT_FILTER_BTN);
    UIButton *classifyFilterBtn = [CommonRouteListFilter createFilterButton:rect4 title:NSLS(@"筛选")];
    classifyFilterBtn.tag = TAG_FILTER_BTN_CLASSIFY;
    [superView addSubview:classifyFilterBtn];
    
    origin_x = classifyFilterBtn.frame.size.width + classifyFilterBtn.frame.origin.x + BTN_EDGE;
    CGRect rect5 = CGRectMake(origin_x, origin_y, 50, HEIGHT_FILTER_BTN);
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
