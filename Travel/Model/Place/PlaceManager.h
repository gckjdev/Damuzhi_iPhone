//
//  PlaceManager.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Place.pb.h"

@interface PlaceManager : NSObject<CommonManagerProtocol>
{
    int             _cityId;
}

@property (nonatomic, retain) NSArray*  placeList;

- (void)switchCity:(int)newCityId;
- (NSArray*)findPlacesByCategory:(int)categoryId;
- (NSArray*)findPlacesNearby:(int)categoryId place:(Place*)place num:(int)num;
- (NSArray*)findPlacesNearby:(int)categoryId place:(Place *)place distance:(double)distance;

- (NSArray *)findNearbyPlaces:(int)type
                     latitude:(double)latitude
                    longitude:(double)longitude
                     distance:(double)distance
                   totalCount:(int*)totalCount;

@end
