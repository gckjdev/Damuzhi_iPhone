//
//  RouteUtils.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteUtils.h"
#import "TouristRoute.pb.h"
#import "RouteExtend.h"

@implementation RouteUtils

+ (NSArray *)getRouteList:(NSArray *)routeList departFromCity:(int)departCityId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (TouristRoute *route in routeList) {
        if ([route isDepartFromCity:departCityId]) {
            [retArray addObject:route];
        }
    }
    
    return retArray;
}

+ (NSArray *)getRouteList:(NSArray *)routeList headForCity:(int)departCityId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (TouristRoute *route in routeList) {
        if ([route isHeadForCity:departCityId]) {
            [retArray addObject:route];
        }
    }
    
    return retArray; 
}

+ (NSArray *)getRouteList:(NSArray *)routeList providedByAngency:(int)angencyId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (TouristRoute *route in routeList) {
        if ([route isProvidedByAngency:angencyId]) {
            [retArray addObject:route];
        }
    }
    
    return retArray; 
}

+ (NSArray *)getRouteList:(NSArray *)routeList inTheme:(int)themeId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (TouristRoute *route in routeList) {
        if ([route isKindOfTheme:themeId]) {
            [retArray addObject:route];
        }
    }
    
    return retArray; 
}

+ (NSArray *)getRouteList:(NSArray *)routeList inCategory:(int)categoryId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (TouristRoute *route in routeList) {
        if ([route isKindOfCategory:categoryId]) {
            [retArray addObject:route];
        }
    }
    
    return retArray; 
}


@end
