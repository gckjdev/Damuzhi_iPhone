//
//  SelectedItemsManager.m
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectedItemIdsManager.h"
#import "CommonPlace.h"
#import "App.pb.h"

@implementation SelectedItemIdsManager

@synthesize spotSelectedItems = _spotSelectedItems;
@synthesize hotelSelectedItems = _hotelSelectedItems;
@synthesize restaurantSelectedItems = _restaurantSelectedItems;
@synthesize shoppingSelectedItems = _shoppingSelectedItems;
@synthesize entertainmentSelectedItems = _entertainmentSelectedItems;

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
        self.spotSelectedItems = [[[SelectedItemIds alloc] init] autorelease];
        self.hotelSelectedItems = [[[SelectedItemIds alloc] init] autorelease];
        self.restaurantSelectedItems = [[[SelectedItemIds alloc] init] autorelease];
        self.shoppingSelectedItems = [[[SelectedItemIds alloc] init] autorelease];
        self.entertainmentSelectedItems = [[[SelectedItemIds alloc] init] autorelease];
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
    [super dealloc];
}

- (SelectedItemIds*)getSelectedItems:(int)categoryId
{
    SelectedItemIds *selectedItems = nil;
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

- (void)resetAllSelectedItems
{
    [_spotSelectedItems resetAll];
    [_hotelSelectedItems resetAll];
    [_restaurantSelectedItems resetAll];
    [_shoppingSelectedItems resetAll];
    [_entertainmentSelectedItems resetAll];
}

@end
