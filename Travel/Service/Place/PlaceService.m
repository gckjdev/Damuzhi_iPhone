//
//  PlaceSevice.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceService.h"
#import "PlaceManager.h"
#import "PPViewController.h"
#import "LogUtil.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "AppManager.h"
#import "TravelNetworkConstants.h"
#import "AppUtils.h"
#import "UserManager.h"
#import "JSON.h"
#import "PlaceStorage.h"

@implementation PlaceService

static PlaceService* _defaultPlaceService = nil;

#pragma mark - 
#pragma mark Life Cycle Management

- (void)dealloc
{
    [_localPlaceManager release];
    [_onlinePlaceManager release];
    [super dealloc];
}

+ (PlaceService*)defaultService
{
    if (_defaultPlaceService == nil){
        _defaultPlaceService = [[PlaceService alloc] init];                
    }
    
    return _defaultPlaceService;
}

- (id)init
{
    self = [super init];
    _localPlaceManager = [[PlaceManager alloc] init];
    _onlinePlaceManager = [[PlaceManager alloc] init];
    return self;
}


#pragma mark - 
#pragma mark Share Methods

typedef NSArray* (^LocalRequestHandler)(int* resultCode);
typedef NSArray* (^RemoteRequestHandler)(int* resultCode);

- (void)processLocalRemoteQuery:(PPViewController<PlaceServiceDelegate>*)viewController
                   localHandler:(LocalRequestHandler)localHandler
                  remoteHandler:(RemoteRequestHandler)remoteHandler
{
    [viewController showActivityWithText:NSLS(@"数据加载中......")];
    
    NSOperationQueue* queue = [self getOperationQueue:@"SERACH_WORKING_QUEUE"];
    [queue cancelAllOperations];
    
    [queue addOperationWithBlock:^{
        NSArray* list = nil;
        int resultCode = 0;
        if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]] == YES){
            // read local data firstly               
            PPDebug(@"Has Local Data For City %@, Read Data Locally", [[AppManager defaultManager] getCurrentCityName]);
            if (localHandler != NULL){
                list = localHandler(&resultCode);
            }
        }
        else{
            // if local data no exist, try to read data from remote            
            PPDebug(@"No Local Data For City %@, Read Data Remotely", [[AppManager defaultManager] getCurrentCityName]);            
            if (remoteHandler != NULL){
                list = remoteHandler(&resultCode);
            }
        }
            
        dispatch_async(dispatch_get_main_queue(), ^{
            if (viewController != nil) {
                [viewController hideActivity];     
            }
            
            if (viewController && [viewController respondsToSelector:@selector(findRequestDone:placeList:)]){
                [viewController findRequestDone:resultCode placeList:list];
            }
        });
    }];
}

#pragma mark - 
#pragma mark Place Life Cycle Management

- (int)getListTypeByPlaceCategoryId:(int)categoryId
{
    int listType = 0;
    
    switch (categoryId) {
        case PlaceCategoryTypePlaceAll:
            listType = OBJECT_LIST_TYPE_ALL_PLACE;
            break;
            
        case PlaceCategoryTypePlaceSpot:
            listType = OBJECT_LIST_TYPE_SPOT;
            break;
            
        case PlaceCategoryTypePlaceHotel:
            listType = OBJECT_LIST_TYPE_HOTEL;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            listType = OBJECT_LIST_TYPE_RESTAURANT;
            break;
            
        case PlaceCategoryTypePlaceShopping:
            listType = OBJECT_LIST_TYPE_SHOPPING;
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            listType = OBJECT_LIST_TYPE_ENTERTAINMENT;
            break;
    
        
        default:
            break;
    }
    
    return listType;
}

- (int)getNearbyListTypeByPlaceCategoryId:(int)categoryId
{
    int listType = 0;
    
    switch (categoryId) {
        case PlaceCategoryTypePlaceAll:
            listType = OBJECT_LIST_TYPE_ALL_NEARBY_PLACE;
            break;
            
        case PlaceCategoryTypePlaceSpot:
            listType = OBJECT_LIST_TYPE_NEARBY_SPOT;
            break;
            
        case PlaceCategoryTypePlaceHotel:
            listType = OBJECT_LIST_TYPE_NEARBY_HOTEL;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            listType = OBJECT_LIST_TYPE_NEARBY_RESTAURANT;
            break;
            
        case PlaceCategoryTypePlaceShopping:
            listType = OBJECT_LIST_TYPE_NEARBY_SHOPPING;
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            listType = OBJECT_LIST_TYPE_NEARBY_ENTERTAINMENT;
            break;
            
            
        default:
            break;
    }
    
    return listType;
}

- (int)getNearby10KMListTypeByPlaceCategoryId:(int)categoryId
{
    int listType = 0;
    
    switch (categoryId) {
        case PlaceCategoryTypePlaceAll:
            listType = OBJECT_LIST_TYPE_ALL_NEARBY_PLACE;
            break;
            
        case PlaceCategoryTypePlaceSpot:
            listType = OBJECT_LIST_TYPE_NEARBY_SPOT;
            break;
            
        case PlaceCategoryTypePlaceHotel:
            listType = OBJECT_LIST_TYPE_NEARBY_HOTEL;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            listType = OBJECT_LIST_TYPE_NEARBY_RESTAURANT;
            break;
            
        case PlaceCategoryTypePlaceShopping:
            listType = OBJECT_LIST_TYPE_NEARBY_SHOPPING;
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            listType = OBJECT_LIST_TYPE_NEARBY_ENTERTAINMENT;
            break;
            
            
        default:
            break;
    }
    
    return listType;
}

- (void)findPlaces:(int)categoryId viewController:(PPViewController<PlaceServiceDelegate>*)viewController
{
    int currentCityId = [[AppManager defaultManager] getCurrentCityId];

    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        [_localPlaceManager switchCity:currentCityId];
        NSArray* list = [_localPlaceManager findPlacesByCategory:categoryId];   
        *resultCode = 0;
        return list;
    };
    
    RemoteRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        int listType = [self getListTypeByPlaceCategoryId:categoryId];
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:listType
                                                               cityId:currentCityId
                                                                 lang:LanguageTypeZhHans]; 
        NSArray *list = nil;
        
        *resultCode = output.resultCode;
        if (output.resultCode == ERROR_SUCCESS) {
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                _onlinePlaceManager.placeList = [[travelResponse placeList] listList];    
                list = [_onlinePlaceManager findPlacesByCategory:categoryId]; 
            }
            @catch (NSException *exception) {
                PPDebug(@"<findPlaces:%d> Caught %@%@", categoryId, [exception name], [exception reason]);
            } 
        }
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)findPlacesNearby:(int)categoryId place:(Place*)place viewController:(PPViewController<PlaceServiceDelegate>*)viewController
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        int currentCityId = [[AppManager defaultManager] getCurrentCityId];
        [_localPlaceManager switchCity:currentCityId];
        NSArray* list = [_localPlaceManager findPlacesNearby:categoryId place:place];   
        *resultCode = 0;
        return list;
    };
    
    RemoteRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        int listType = [self getNearbyListTypeByPlaceCategoryId:categoryId];
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:listType
                                                              placeId:place.placeId
                                                                 lang:LanguageTypeZhHans];
        NSArray *list = nil;
        
        *resultCode = output.resultCode;
        if (output.resultCode == ERROR_SUCCESS) {
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                list = [[travelResponse placeList] listList]; 
            }
            @catch (NSException *exception) {
                PPDebug(@"<findPlacesNearby> Caught %@%@", [exception name], [exception reason]);
            } 
        }
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)findPlacesNearby:(int)categoryId place:(Place*)place distance:(double)distance viewController:(PPViewController<PlaceServiceDelegate> *)viewController;
{
    LocalRequestHandler localHandler = ^NSArray *(int* resultCode) {
        int currentCityId = [[AppManager defaultManager] getCurrentCityId];
        [_localPlaceManager switchCity:currentCityId];
        NSArray* list = [_localPlaceManager findPlacesNearby:categoryId place:place distance:distance];   
        *resultCode = 0;
        return list;
    };
    
    RemoteRequestHandler remoteHandler = ^NSArray *(int* resultCode) {
        // TODO, send network request here
        int listType = [self getNearby10KMListTypeByPlaceCategoryId:categoryId];
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:listType
                                                              placeId:place.placeId
                                                             distance:distance
                                                                 lang:LanguageTypeZhHans];
        NSArray *list = nil;

        *resultCode = output.resultCode;

        if (output.resultCode == ERROR_SUCCESS) {
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                list = [[travelResponse placeList] listList]; 
            }
            @catch (NSException *exception) {
                PPDebug(@"<findPlacesNearby> Caught %@%@", [exception name], [exception reason]);
            } 
        }
        
        return list;
    };
    
    [self processLocalRemoteQuery:viewController
                     localHandler:localHandler
                    remoteHandler:remoteHandler];
}

- (void)addPlaceIntoFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                       place:(Place*)place
{
    NSString* userId = [[UserManager defaultManager] userId];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput* output = [TravelNetworkRequest addFavoriteByUserId:userId placeId:[NSString stringWithFormat:@"%d",place.placeId]  longitude:[NSString stringWithFormat:@"%f",place.longitude] latitude:[NSString stringWithFormat:@"%f",place.latitude]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
            if (0 == result.intValue){
                //[[PlaceStorage favoriteManager] addPlace:place];
            }else {
                PPDebug(@"<PlaceService> addPlaceIntoFavorite faild,result:%d", result.intValue);
            }
            [[PlaceStorage favoriteManager] addPlace:place];
            
            if ([viewController respondsToSelector:@selector(finishAddFavourite:count:)]){
                [viewController finishAddFavourite:result count:placeFavoriteCount];
            }
        });
    }); 
}

- (void)deletePlaceFromFavorite:(PPViewController<PlaceServiceDelegate>*)viewController 
                          place:(Place*)place
{
    NSString* userId = [[UserManager defaultManager] userId];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest deleteFavoriteByUserId:userId placeId:[NSString stringWithFormat:@"%d",place.placeId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (output.resultCode == ERROR_SUCCESS) {
                NSDictionary* jsonDict = [output.textData JSONValue];
                NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
                NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
                if (0 == result.intValue){
                    
                }else {
                    PPDebug(@"<PlaceService> deletePlaceIntoFavorite faild,result:%d", result.intValue);
                }
                [[PlaceStorage favoriteManager] deletePlace:place];
                
                if (viewController && [viewController respondsToSelector:@selector(finishDeleteFavourite:count:)]){
                    [viewController finishDeleteFavourite:result count:placeFavoriteCount];
                }
            }
        });
    }); 
}

- (void)getPlaceFavoriteCount:(PPViewController<PlaceServiceDelegate>*)viewController
                      placeId:(int)placeId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryPlace:[[UserManager defaultManager] userId] placeId:[NSString stringWithFormat:@"%d",placeId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS) {
                NSDictionary* jsonDict = [output.textData JSONValue];
                NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
                NSNumber *placeFavoriteCount = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_PLACE_FAVORITE_COUNT];
                
                if (0 == result.intValue){
                    
                }else {
                    PPDebug(@"<PlaceService> getPlaceFavoriteCount faild,result:%d", result.intValue);
                }
                
                if ([viewController respondsToSelector:@selector(didGetPlaceData:count:)]){
                    PPDebug(@"<getPlaceFavoriteCount> placeId=%d, count=%d", placeId, placeFavoriteCount.intValue);
                    [viewController didGetPlaceData:placeId count:placeFavoriteCount.intValue];
                }
            }
        });
    }); 
}

- (void)findTopFavoritePlaces:(PPViewController<PlaceServiceDelegate>*)viewController type:(int)type
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        int currentyCityId = [[AppManager defaultManager] getCurrentCityId];
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:type 
                                                               cityId:currentyCityId 
                                                                 lang:LanguageTypeZhHans];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *favoritPlaceList = nil;
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                favoritPlaceList = [[travelResponse placeList] listList];   
            }
            @catch (NSException *exception) {
                PPDebug(@"<findTopFavoritePlaces:%d> Caught %@%@", type, [exception name], [exception reason]);
            }  
            
            if ([viewController respondsToSelector:@selector(finishFindTopFavoritePlaces:type:result:)]){
                [viewController finishFindTopFavoritePlaces:favoritPlaceList type:type result:output.resultCode];
            }
        });
    }); 
}

@end
