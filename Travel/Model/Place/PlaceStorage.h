//
//  PlaceStorage.h
//  Travel
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FAVORITE_STORAGE @"FAVORITE_STORAGE"
#define HISTORY_STORAGE @"HISTORY_STORAGE"

@class Place;
@class PlaceList;

@interface PlaceStorage : NSObject

+ (PlaceStorage*)favoriteManager;
+ (PlaceStorage*)historyManager;

- (id)initWithType:(NSString*)typeValue;
- (NSArray*)allPlaces;
- (void)addPlace:(Place*)place;
- (void)deletePlace:(Place*)place;
- (void)deleteAllPlaces;
- (BOOL)isPlaceInFavorite:(int)placeId;
- (NSArray *)allPlacesSortByLatest;

@end
