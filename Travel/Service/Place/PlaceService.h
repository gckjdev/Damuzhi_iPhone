//
//  PlaceSevice.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@class PlaceManager;
@class PPViewController;
@class Place;

@protocol PlaceServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result dataList:(NSArray*)dataList;
- (void)filterAndSort;

- (void)finishAddFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishDeleteFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishFindTopFavoritePlaces:(NSArray*)list type:(int)type;
- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;

@end

@interface PlaceService : CommonService

{
    PlaceManager    *_localPlaceManager;
    PlaceManager    *_onlinePlaceManager;
    
    int             _currentCityId;
}

@property (nonatomic, assign) int currentCityId;

+ (PlaceService*)defaultService;

- (void)findPlacesByCategoryId:(PPViewController<PlaceServiceDelegate>*)viewController categoryId:(int)categoryId;
//- (void)findAllSpots:(PPViewController<PlaceServiceDelegate>*)viewController;
//- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
//- (void)findAllHotels:(PPViewController<PlaceServiceDelegate>*)viewController;

- (void)findMyPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findHistoryPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;


- (void)addPlaceIntoFavorite:(PPViewController<PlaceServiceDelegate>*)viewController
                       place:(Place*)place;
- (void)deletePlaceFromFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                          place:(Place*)place;
- (void)getPlaceFavoriteCount:(PPViewController<PlaceServiceDelegate>*)viewController
                      placeId:(int)placeId;
- (void)findTopFavoritePlaces:(PPViewController<PlaceServiceDelegate>*)viewController type:(int)type;

//- (BOOL)isPlaceInFavorite:(int)placeId;

@end
