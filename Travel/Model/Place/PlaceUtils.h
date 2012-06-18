//
//  PlaceUtils.h
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.pb.h"
#import <CoreLocation/CoreLocation.h>

#define TYPE_SUBCATEGORY 1
#define TYPE_PROVIDED_SERVICE 2
#define TYPE_AREA 3
#define TYPE_PRICE 4
#define TYPE_SORT 5

@interface PlaceUtils : NSObject

+ (NSString*)hotelStarToString:(int32_t)hotelStar;
+ (NSString*)getDetailPrice:(Place*)place;
+ (NSString*)getPrice:(Place*)place;
+ (NSString*)getDistanceString:(Place*)place currentLocation:(CLLocation*)currentLocation;
+ (int)getPlacesCountInSameType:(int)type typeId:(int)typeId placeList:(NSArray*)placeList;
+ (NSArray*)sortedByDistance:(CLLocation*)location array:(NSArray*)array type:(int)type;

+ (NSArray*)getPlaceList:(NSArray*)placeList inSameSubcategory:(int)subcategoryId;
+ (NSArray*)getPlaceList:(NSArray*)placeList hasSameService:(int)serviceId;
+ (NSArray*)getPlaceList:(NSArray*)placeList inSameArea:(int)areaId;

+ (NSArray*)getPlaceList:(NSArray *)placeList ofCategory:(int)categoryId;
@end
