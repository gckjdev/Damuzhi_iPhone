//
//  PlaceSevice.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import <CoreLocation/CoreLocation.h>


@class PlaceManager;
@class PPViewController;
@class Place;

@protocol PlaceServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result placeList:(NSArray*)placeList;
- (void)finishAddFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishDeleteFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishFindTopFavoritePlaces:(NSArray*)list type:(int)type result:(int)result;
- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;

- (void)findRequestDone:(int)resultCode
                 result:(int)result 
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place;

@end

@interface PlaceService : CommonService
{
    PlaceManager    *_localPlaceManager;
    PlaceManager    *_onlinePlaceManager;
}

+ (PlaceService*)defaultService;

- (void)findPlaces:(int)categoryId viewController:(PPViewController<PlaceServiceDelegate>*)viewController;

- (void)findPlacesNearby:(int)categoryId place:(Place*)place num:(int)num viewController:(PPViewController<PlaceServiceDelegate>*)viewController;

- (void)findPlacesNearby:(int)categoryId place:(Place*)place distance:(double)distance viewController:(PPViewController<PlaceServiceDelegate> *)viewController;

- (void)addPlaceIntoFavorite:(PPViewController<PlaceServiceDelegate>*)viewController
                       place:(Place*)place;
- (void)deletePlaceFromFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                          place:(Place*)place;
- (void)getPlaceFavoriteCount:(PPViewController<PlaceServiceDelegate>*)viewController
                      placeId:(int)placeId;
- (void)findTopFavoritePlaces:(PPViewController<PlaceServiceDelegate>*)viewController type:(int)type;

- (void)findPlace:(int)placeId viewController:(PPViewController<PlaceServiceDelegate>*)viewController;

@end
