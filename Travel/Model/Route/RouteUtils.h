//
//  RouteUtils.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouristRoute.pb.h"

@interface RouteUtils : NSObject

+ (NSArray *)getRouteList:(NSArray *)routeList departFromCity:(int)departCityId;
+ (NSArray *)getRouteList:(NSArray *)routeList headForCity:(int)departCityId;
+ (NSArray *)getRouteList:(NSArray *)routeList providedByAngency:(int)angencyId;
+ (NSArray *)getRouteList:(NSArray *)routeList inTheme:(int)themeId;
+ (NSArray *)getRouteList:(NSArray *)routeList inCategory:(int)categoryId;

+ (Booking *)bookingOfDate:(NSDate *)date bookings:(NSArray *)bookings;

+ (TravelPackage *)findPackageByPackageId:(int)packageId fromPackageList:(NSArray *)packageList;


@end
