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
#import "PPDebug.h"

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

+ (TravelPackage *)findPackageByPackageId:(int)packageId fromPackageList:(NSArray *)packageList
{
    PPDebug(@"find packageId = %d", packageId);

    TravelPackage *package;
    for (package in packageList) {
        PPDebug(@"packageId = %d", package.packageId);

        if (package.packageId == packageId) {
            return package;
        }
    }
    
    return nil;
}


+ (Booking *)bookingOfDate:(NSDate *)date bookings:(NSArray *)bookings
{
    int passDay = [date timeIntervalSince1970] / 86400;
    for (Booking *booking in bookings) {
        if (passDay == booking.date / 86400) {
            return booking;
        }
    }
    
    return nil;
}

@end
