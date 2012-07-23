//
//  SelectedItemsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectedItemIdsManager.h"
#import "App.pb.h"
#import "TravelNetworkConstants.h" 

@implementation SelectedItemIdsManager

@synthesize spotSelectedItems = _spotSelectedItems;
@synthesize hotelSelectedItems = _hotelSelectedItems;
@synthesize restaurantSelectedItems = _restaurantSelectedItems;
@synthesize shoppingSelectedItems = _shoppingSelectedItems;
@synthesize entertainmentSelectedItems = _entertainmentSelectedItems;

@synthesize packageTourSelectedItems  = _packageTourSelectedItems;
@synthesize unPackageTourSelectedItems = _unPackageTourSelectedItems;

static SelectedItemIdsManager *_instance = nil;

+(id)defaultManager
{
    if (_instance == nil) {
        _instance = [[SelectedItemIdsManager alloc] init];
    }
    
    return _instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.spotSelectedItems = [[[PlaceSelectedItemIds alloc] init] autorelease];
        self.hotelSelectedItems = [[[PlaceSelectedItemIds alloc] init] autorelease];
        self.restaurantSelectedItems = [[[PlaceSelectedItemIds alloc] init] autorelease];
        self.shoppingSelectedItems = [[[PlaceSelectedItemIds alloc] init] autorelease];
        self.entertainmentSelectedItems = [[[PlaceSelectedItemIds alloc] init] autorelease];
        
        self.packageTourSelectedItems = [[[RouteSelectedItemIds alloc] init] autorelease];
        self.unPackageTourSelectedItems = [[[RouteSelectedItemIds alloc] init] autorelease];

    }
    
    return self;
}

-(void)dealloc
{
    [_spotSelectedItems release];
    [_hotelSelectedItems release];
    [_restaurantSelectedItems release];
    [_shoppingSelectedItems release];
    [_entertainmentSelectedItems release];
    
    [_packageTourSelectedItems release];
    [_unPackageTourSelectedItems release];
    [super dealloc];
}

- (PlaceSelectedItemIds*)getPlaceSelectedItems:(int)categoryId
{
    PlaceSelectedItemIds *selectedItems = nil;
    switch (categoryId) {
        case PlaceCategoryTypePlaceSpot:
            selectedItems = _spotSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceHotel:
            selectedItems = _hotelSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceRestraurant:
            selectedItems = _restaurantSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceShopping:
            selectedItems = _shoppingSelectedItems;
            break;
            
        case PlaceCategoryTypePlaceEntertainment:
            selectedItems = _entertainmentSelectedItems;
            break;
            
        default:
            break;
    }
    
    return selectedItems;
}

//- (void)resetPlaceSelectedItems:(int)categoryId
//{
//    switch (categoryId) {
//        case PlaceCategoryTypePlaceSpot:
//            [_spotSelectedItems reset];
//            break;
//            
//        case PlaceCategoryTypePlaceHotel:
//            [_hotelSelectedItems reset];
//            break;
//            
//        case PlaceCategoryTypePlaceRestraurant:
//            [_restaurantSelectedItems reset];
//            break;
//            
//        case PlaceCategoryTypePlaceShopping:
//            [_shoppingSelectedItems reset];
//            break;
//            
//        case PlaceCategoryTypePlaceEntertainment:
//            [_entertainmentSelectedItems release];
//            break;
//            
//        default:
//            break;
//    }
//}

- (RouteSelectedItemIds*)getRouteSelectedItems:(int)routeType
{
    RouteSelectedItemIds *selectedItems = nil;
    switch (routeType) {
        case OBJECT_LIST_ROUTE_PACKAGE_TOUR:
            selectedItems = _packageTourSelectedItems;
            break;
            
        case OBJECT_LIST_ROUTE_UNPACKAGE_TOUR:
            selectedItems = _unPackageTourSelectedItems;
            break;
            
        default:
            break;
    }
    
    return selectedItems;
}

//- (void)resetRouteSelectedItems:(int)routeType
//{
//    switch (routeType) {
//        case OBJECT_LIST_ROUTE_PACKAGE_TOUR:
//            [_packageTourSelectedItems reset];
//            break;
//            
//        case OBJECT_LIST_ROUTE_UNPACKAGE_TOUR:
//            [_unPackageTourSelectedItems reset];
//            break;
//            
//        default:
//            break;
//    }
//}


@end
