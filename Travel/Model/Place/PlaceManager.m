//
//  PlaceManager.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceManager.h"
#import "Place.pb.h"
#import "LogUtil.h"
#import "AppManager.h"
#import "AppUtils.h"
#import <CoreLocation/CoreLocation.h>

@implementation PlaceManager

static PlaceManager *_placeDefaultManager;
@synthesize placeList = _placeList;

- (void)dealloc
{
    [_placeList release];
    [super dealloc];
}

+ (id)defaultManager
{
    if (_placeDefaultManager == nil){
        _placeDefaultManager = [[PlaceManager alloc] init];
    }
    
    return _placeDefaultManager;
}

- (NSArray*)readCityPlaceData:(int)cityId
{
    // if there has no local city data
    if (![AppUtils hasLocalCityData:cityId]) {
        return nil;
    }
    
    NSMutableArray *placeList = [[[NSMutableArray alloc] init] autorelease];
    for (NSString *filePath in [AppUtils getPlaceFilePathList:cityId]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data != nil) {
            @try {
                PlaceList *places = [PlaceList parseFromData:data];
                [placeList addObjectsFromArray:[places listList]];
            }
            @catch (NSException *exception) {
                PPDebug(@"<readCityPlaceData:%@> Caught %@%@", filePath, [exception name], [exception reason]);
            }
        }
    }
    
    return placeList;
}

- (void)switchCity:(int)newCityId
{
    if (newCityId == _cityId){
        return;
    }
    
    // set city and read data by new city
    _cityId = newCityId;
    self.placeList = [self readCityPlaceData:newCityId];
}

- (NSArray*)findPlacesByCategory:(int)categoryId
{
    if (categoryId == PlaceCategoryTypePlaceAll) {
        return _placeList;
    }
    
    NSMutableArray* placeList = [[[NSMutableArray alloc] init] autorelease];
    for (Place* place in _placeList){
        if ([place categoryId] == categoryId){
            [placeList addObject:place];
        }
    }

    return placeList;
}

- (double)distanceBetween:(Place*)place1 place2:(Place*)place2
{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:place1.latitude longitude:place1.longitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:place2.latitude longitude:place2.longitude];
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    
    [location1 release];
    [location2 release];
    
    return distance;
}

- (double)distanceBetween:(Place*)place location:(CLLocation*)location
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    
    CLLocationDistance distance = [loc distanceFromLocation:location];
    
    [loc release];
    
    return distance;
}

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place*)place num:(int)num
{
    NSArray *list = [self findPlacesByCategory:categoryId];

    NSArray *sortedPlaceList = [self sortPlacesFromNearToFar:place placeList:list];
    
    int sortedListCount = [sortedPlaceList count];
    
    NSRange range;
    range.location = 0;
    range.length = (sortedListCount >= num) ? num : sortedListCount;
    
    return [sortedPlaceList subarrayWithRange:range];
}

- (NSArray*)sort:(CLLocation*)location placeList:(NSArray*)placeList
{
    NSArray *sortedList = [placeList sortedArrayUsingComparator:^(id obj1, id obj2){
        Place *place1 = (Place*)obj1;
        Place *place2 = (Place*)obj2;
        
        CLLocationDistance dis1 = [self distanceBetween:place1 location:location];
        CLLocationDistance dis2 = [self distanceBetween:place2 location:location];
        
        if (dis1 < dis2) {
            return NSOrderedAscending;
        }
        else if (dis1 > dis2) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    return sortedList;
}

- (NSArray*)sortPlacesFromNearToFar:(Place*)place placeList:(NSArray*)placeList
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];

    for (Place *pl in placeList) {
        if (pl.placeId == place.placeId) {
            continue;
        }
        [list addObject:pl];
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    
    NSArray *sortedList = [self sort:location placeList:list];
    
    [location release];
    return sortedList;
}

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place *)place distance:(double)distance
{    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
    NSArray *list = [self findPlacesByCategory:categoryId];
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place1 in list) {
        if(place.placeId == place1.placeId)
        {
            continue;
        }
        
        double dis = [self distanceBetween:place1 location:location];
        
        if (dis < distance*1000.0) {
//            PPDebug(@"place = %@, distance = %f", place1.name, dis);
            [retArray addObject:place1];
        }
    }
    
    [location release];
    
    return retArray;
}

- (NSArray *)filterByDistance:(double)distance location:(CLLocation*)location placeList:(NSArray *)placeList
{
    NSMutableArray *resultList = [[[NSMutableArray alloc] init] autorelease];
    
    for (Place *place in placeList) {
        CLLocationDistance dis = [self distanceBetween:place location:location];
        if (dis <= distance*1000.0) {
            [resultList addObject:place];
        }
    }
    
    return resultList;
}

- (NSArray *)findNearbyPlaces:(int)type
                     latitude:(double)latitude
                    longitude:(double)longitude
                     distance:(double)distance
                   totalCount:(int*)totalCount
{
    //filter with type
    NSArray *listAfterTypeFilter = [self findPlacesByCategory:type];
    
    PPDebug(@"listAfterTypeFilter count:%d", [listAfterTypeFilter count]);
    
    //filter with distance
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
    NSArray *listAfterDistaceFilter = [self filterByDistance:distance location:location placeList:listAfterTypeFilter];
    
    *totalCount = [listAfterDistaceFilter count];
    
    //sort by distance
    NSArray *listSorted = [self sort:location placeList:listAfterDistaceFilter];
    
    return listSorted;
}


@end
