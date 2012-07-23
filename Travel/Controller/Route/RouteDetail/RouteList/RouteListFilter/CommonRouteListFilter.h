//
//  CommonRouteListFilter.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TAG_FILTER_BTN_DEPART_CITY 18
#define TAG_FILTER_BTN_DESTINATION_CITY 19
#define TAG_FILTER_BTN_AGENCY 20
#define TAG_FILTER_BTN_CLASSIFY 21
#define TAG_SORT_BTN 22

typedef enum{
    depart = 0,
    destination = 1
} typeCity;

@interface CommonRouteListFilter : NSObject

+ (UIButton*)createFilterButton:(CGRect)frame title:(NSString*)title;

+ (NSArray *)filterRouteList:(NSArray *)routeList byAgencyIdList:(NSArray *)agencyIdList;
+ (NSArray *)filterRouteList:(NSArray *)routeList byThemeIdList:(NSArray *)themeIdList;
+ (NSArray *)filterRouteList:(NSArray *)routeList byCategoryIdList:(NSArray *)categoryIdList;
+ (NSArray *)filterRouteList:(NSArray *)routeList byDepartCityId:(int)departCityId;
+ (NSArray *)filterRouteList:(NSArray *)routeList byDestinationCityId:(int)destinationCityId;

@end
