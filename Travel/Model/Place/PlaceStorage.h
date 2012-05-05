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

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) PlaceList* placeList;

+ (PlaceStorage*)favoriteManager;
+ (PlaceStorage*)historyManager;

- (id)initWithFileName:(NSString*)fileName;
- (NSArray*)allPlaces;
- (void)addPlace:(Place*)place;
- (void)deletePlace:(Place*)place;
- (void)deleteAllPlaces;
- (BOOL)isPlaceInFavorite:(int)placeId;

@end
