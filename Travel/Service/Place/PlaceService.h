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
#import "SelectedItemIdsManager.h"
#import "Package.pb.h"

@class PlaceManager;
@class PPViewController;
@class Place;
@class PlaceListFilter;

@protocol PlaceServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result placeList:(NSArray*)placeList;

- (void)findRequestDone:(int)resultCode 
                 result:(int)result 
             resultInfo:(NSString *)resultInfo
             totalCount:(int)totalCount
              placeList:(NSArray*)placeList;

- (void)finishAddFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishDeleteFavourite:(NSNumber*)resultCode count:(NSNumber*)count;
- (void)finishFindTopFavoritePlaces:(NSArray*)list type:(int)type result:(int)result;
- (void)didGetPlaceData:(int)placeId count:(int)placeFavoriteCount;

- (void)findRequestDone:(int)resultCode
                 result:(int)result 
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place;

@end

@protocol PlaceListFilterProtocol <NSObject>

@optional
- (void)createFilterButtons:(UIView*)superView controller:(PPViewController*)controller;
//- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (PlaceListFilter<PlaceListFilterProtocol>*)createFilter;

- (int)getCategoryId;
- (NSString*)getCategoryName;

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(PlaceSelectedItemIds*)selectedItemIds;

@end

@interface PlaceListFilter : NSObject <PlaceListFilterProtocol>

//- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
- (void)findAllPlacesWithStart:(int)start
                         count:(int)count
               selectedItemIds:(PlaceSelectedItemIds *)selectedItemIds
                needStatistics:(BOOL)needStatistics 
                viewController:(PPViewController<PlaceServiceDelegate>*)viewController
                        filter:(id<PlaceListFilterProtocol>)filter;

@end


@interface PlaceService : CommonService
{
    PlaceManager    *_localPlaceManager;
    PlaceManager    *_onlinePlaceManager;
}

+ (PlaceService*)defaultService;

- (void)findPlaces:(int)categoryId viewController:(PPViewController<PlaceServiceDelegate>*)viewController;

- (void)findPlacesWithCategoryId:(int)categoryId 
                           start:(int)start
                           count:(int)count
                 selectedItemIds:(PlaceSelectedItemIds *)selectedItemIds
                  needStatistics:(BOOL)needStatistics 
                  viewController:(PPViewController<PlaceServiceDelegate>*)viewController
                          filter:(id<PlaceListFilterProtocol>)filter;

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

- (void)findNearbyPlaces:(int)type
                Latitude:(double)latitude
               longitude:(double)longitude
                distance:(double)distance
                   start:(int)start
                   count:(int)count
                delegate:(id<PlaceServiceDelegate>)delegate;

@end
