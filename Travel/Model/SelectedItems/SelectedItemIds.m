//
//  SelectedItemIdsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectedItemIdsManager.h"
#import "CommonPlace.h"
#import "Item.h"

@implementation PlaceSelectedItemIds

@synthesize subCategoryItemIds = _subCategoryItemIds;
@synthesize sortItemIds = _sortItemIds;
@synthesize areaItemIds = _areaItemIds;
@synthesize priceRankItemIds = _priceRankItemIds;
@synthesize serviceItemIds = _serviceItemIds;
@synthesize cuisineItemIds = _cuisineItemIds;

- (void)dealloc {
    [_subCategoryItemIds release];
    [_sortItemIds release];
    [_areaItemIds release];
    [_priceRankItemIds release];
    [_serviceItemIds release];
    [_cuisineItemIds release];

    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.subCategoryItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.sortItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.priceRankItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.areaItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.serviceItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.cuisineItemIds = [[[NSMutableArray alloc] init] autorelease];
                
        [self.subCategoryItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.priceRankItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.areaItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.serviceItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.cuisineItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.sortItemIds addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
    }
    
    return self;
}

- (void)reset
{
    [self.subCategoryItemIds removeAllObjects];
    [self.sortItemIds removeAllObjects];
    [self.priceRankItemIds removeAllObjects];
    [self.areaItemIds removeAllObjects];  
    [self.serviceItemIds removeAllObjects];
    
    [self.subCategoryItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.priceRankItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.areaItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.serviceItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.cuisineItemIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.sortItemIds addObject:[NSNumber numberWithInt:SORT_BY_RECOMMEND]];
}

@end




@implementation RouteSelectedItemIds

@synthesize departCityIds = _departCityIds;
@synthesize destinationCityIds = _destinationCityIds;
@synthesize agencyIds = _agencyIds;
@synthesize themeIds = _themeIds;
@synthesize routeTypeIds = _routeTypeIds;

- (void)dealloc {
    [_departCityIds release];
    [_destinationCityIds release];
    [_agencyIds release];
    [_themeIds release];
    [_routeTypeIds release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.departCityIds = [[[NSMutableArray alloc] init] autorelease];
        self.destinationCityIds = [[[NSMutableArray alloc] init] autorelease];
        self.agencyIds = [[[NSMutableArray alloc] init] autorelease];
        self.themeIds = [[[NSMutableArray alloc] init] autorelease];
        self.routeTypeIds = [[[NSMutableArray alloc] init] autorelease];
        
        [self.departCityIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.destinationCityIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.agencyIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.themeIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
        [self.routeTypeIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    }
    
    return self;
}

- (void)reset
{
    [self.departCityIds removeAllObjects];
    [self.destinationCityIds removeAllObjects];
    [self.agencyIds removeAllObjects];
    [self.themeIds removeAllObjects];
    [self.routeTypeIds removeAllObjects];
    
    [self.departCityIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.destinationCityIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.agencyIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.themeIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
    [self.routeTypeIds addObject:[NSNumber numberWithInt:ALL_CATEGORY]];
}

@end

