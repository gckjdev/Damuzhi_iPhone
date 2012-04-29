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
                NSLog (@"<readCityPlaceData:%@> Caught %@%@", filePath, [exception name], [exception reason]);
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

- (NSArray*)findPlacesNearby:(int)categoryId place:(Place*)place
{
    NSArray *list = [self findPlacesByCategory:categoryId];
    
    NSArray *sortedPlaceList = [self sortPlacesFromNearToFar:place placeList:list];
    
    NSMutableArray *retArray = [[[NSMutableArray alloc] init] autorelease];
        
    int count = [sortedPlaceList count];
    int loopCount = (count<5) ? count : 5;
    
    for (int i = 0; i < loopCount; i++)
    {
        [retArray addObject:[sortedPlaceList objectAtIndex:(loopCount - i -1)]];
    }
    return retArray;
}

- (NSArray*)sortPlacesFromNearToFar:(Place*)place placeList:(NSArray*)placeList
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];

    NSMutableArray *list = [NSMutableArray arrayWithArray:[NSArray arrayWithArray:placeList]];
    
    [list sortedArrayUsingComparator:^(id obj1, id obj2){
        Place *place1 = (Place*)obj1;
        Place *place2 = (Place*)obj2;
        
        CLLocationDistance dis1 = [self distanceBetween:place1 location:location];
        CLLocationDistance dis2 = [self distanceBetween:place2 location:location];
        
        if (dis1 > dis2) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (dis1 < dis2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [location release];
    
    // remove place
    for (Place *place1 in list) {
        if (place1.placeId == place.placeId) {
            [list removeObject:place1];
        }
    }
    
    return list;
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
            [retArray addObject:place1];
        }
    }
    
    [location release];
    
    return retArray;
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


@end
