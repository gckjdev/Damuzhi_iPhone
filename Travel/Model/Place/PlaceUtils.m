//
//  PlaceUtils.m
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PlaceUtils.h"
#import "LocaleUtils.h"
#import "AppManager.h"
#import "PlaceExtend.h"
#import "AppConstants.h"

@implementation PlaceUtils

+ (NSString*)hotelStarToString:(int32_t)hotelStar
{
    switch (hotelStar) {
        case 1:
            return NSLS(@"一星级");
            break;
        case 2:
            return NSLS(@"二星级");
            break;
        case 3:
            return NSLS(@"三星级");
            break;
        case 4:
            return NSLS(@"四星级");
            break;
        case 5:
            return NSLS(@"五星级");
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString*)getDetailPrice:(Place*)place
{
    NSString *price = @"";
    NSString *currencySymbol = [[AppManager defaultManager] getCurrencySymbol:place.cityId];
    switch (place.categoryId) {
        case PlaceCategoryTypePlaceSpot:
        case PlaceCategoryTypePlaceHotel:
            price = place.priceDescription;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
        case PlaceCategoryTypePlaceEntertainment:
            price = [self priceStringWithSymbol:currencySymbol price:[place.avgPrice intValue]];
            break;
            
        default:
            break;
    }

    return price;
}

+ (NSString*)getPrice:(Place*)place
{
    NSString *price = @"";
    NSString *currencySymbol = [[AppManager defaultManager] getCurrencySymbol:place.cityId];
    switch (place.categoryId) {
        case PlaceCategoryTypePlaceSpot:
        case PlaceCategoryTypePlaceHotel:
            price = [self priceStringWithSymbol:currencySymbol price:[place.price intValue]];
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
        case PlaceCategoryTypePlaceEntertainment:
            price = [self priceStringWithSymbol:currencySymbol price:[place.avgPrice intValue]];
            break;
            
        default:
            break;
    }

    return price;
}

+ (NSString*)priceStringWithSymbol:(NSString*)symbol price:(int)price
{
    if (price > 0) {
        return [NSString stringWithFormat:@"%@%d", symbol, price];
    }else {
        return NSLS(@"免费");
    }
}


+ (NSString*)getDistanceString:(Place*)place currentLocation:(CLLocation*)currentLocation
{
    if (currentLocation == nil) {
        return @"";
    }
    
    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
    CLLocationDistance distance = [placeLocation distanceFromLocation:currentLocation];
    [placeLocation release];
    
    return[PlaceUtils getDistanceStringFrom:distance];
}

+ (NSString*)getDistanceStringFrom:(float)distance
{    
    // 单位统一为KM，大于1KM的，采用四舍五入，不用小数点; 22. 小于1KM的用M，精确到十位。
    if (distance > 100.0*1000.0) {
        return NSLS(@">100km");
    }else if (distance >=1000.0) {
        long long temp = distance/1000.0 + 0.5;
        return [NSString stringWithFormat:NSLS(@"%lldkm"), temp];
    }
    else {
        int temp = (int)distance > 10? (int)distance : 10;
        return [NSString stringWithFormat:NSLS(@"%dm"), temp];
    }
}


+ (int)getPlacesCountInSameType:(int)type typeId:(int)typeId placeList:(NSArray*)placeList
{
    int count = 0;
    switch (type) {
        case TYPE_SUBCATEGORY:
            count = [PlaceUtils getPlacesCountInSameSubcategory:typeId placeList:placeList];
            break;
            
        case TYPE_PROVIDED_SERVICE:
            count = [PlaceUtils getPlacesHaveSameProvidedService:typeId placeList:placeList];
            break;
            
        case TYPE_AREA:
            count = [PlaceUtils getPlacesInSameArea:typeId placeList:placeList];
            break;
            
        default:
            break;
    }
    
    return count;
}

+ (int)getPlacesHaveSameProvidedService:(int)providedServiceId placeList:(NSArray*)placeList
{
    if (providedServiceId == ALL_CATEGORY) {
        return [placeList count];
    }
    
    int count = 0;
    for (Place *place in placeList) {
        for(NSNumber *serviceId in place.providedServiceIdList)
        {
            if ([serviceId intValue] == providedServiceId) {
                count++;
                break;
            }
        }
    }
    
    return count;
}

+ (int)getPlacesCountInSameSubcategory:(int)subcategoryId placeList:(NSArray*)placeList
{
    if (subcategoryId == ALL_CATEGORY) {
        return [placeList count];
    }
    
    int count = 0;
    for (Place *place in placeList) {
        if (place.subCategoryId == subcategoryId) {
            count++;
        }
    }
    
    return count;
}

+ (NSArray*)getPlaceList:(NSArray*)placeList inSameSubcategory:(int)subcategoryId
{    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place *place in placeList) {
        if ([place isKindOfSubCategory:subcategoryId]) {
            [retArray addObject:place];
        };
    }
    
    return retArray;
}

+ (NSArray*)getPlaceList:(NSArray*)placeList hasSameService:(int)serviceId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place *place in placeList) {
        if ([place hasService:serviceId]) {
            [retArray addObject:place];
        }
    }
    
    return retArray;
}

+ (NSArray*)getPlaceList:(NSArray*)placeList inSameArea:(int)areaId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place *place in placeList) {
        if ([place isInArea:areaId]) {
            [retArray addObject:place];
        }
    }
    
    return retArray;
}



+ (int)getPlacesInSameArea:(int)areaId placeList:(NSArray*)placeList
{
    if (areaId == ALL_CATEGORY) {
        return [placeList count];
    }
    
    int count = 0;
    for (Place *place in placeList) {
        if (place.areaId == areaId) {
            count++;
        }
    }
    
    return count;
}

+ (NSArray*)sortedByDistance:(CLLocation*)location array:(NSArray*)array type:(int)type
{
    NSArray *retArray = [array sortedArrayUsingComparator:^NSComparisonResult(id place1, id place2){
        CLLocation *place1Location = [[CLLocation alloc] initWithLatitude:[place1 latitude] longitude:[place1 longitude]];
        CLLocation *place2Location = [[CLLocation alloc] initWithLatitude:[place2 latitude] longitude:[place2 longitude]];
        CLLocationDistance distance1 = [location distanceFromLocation:place1Location];
        CLLocationDistance distance2 = [location distanceFromLocation:place2Location];
        [place1Location release];
        [place2Location release];
        
        if (type == SORT_BY_DESTANCE_FROM_NEAR_TO_FAR) {
            if (distance1 < distance2)
                return NSOrderedAscending;
            else  if (distance1 > distance2)
                return NSOrderedDescending;
            else return NSOrderedSame;
        }else if(type == SORT_BY_DESTANCE_FROM_FAR_TO_NEAR){
            if (distance1 > distance2)
                return NSOrderedAscending;
            else  if (distance1 < distance2)
                return NSOrderedDescending;
            else return NSOrderedSame;
        }else {
            return NSOrderedSame;
        }
    }];
    
    return retArray;
}

+ (NSArray*)getPlaceList:(NSArray *)placeList ofCategory:(int)categoryId
{
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place *place in placeList) {
        if ([place isKindOfCategory:categoryId]) {
            [retArray addObject:place];
        };
    }
    
    return retArray;
}


@end
