//
//  PlaceStorage.m
//  Travel
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceStorage.h"
#import "Place.pb.h"
#import "LogUtil.h"
#import "AppManager.h"
#import "AppUtils.h"

@interface PlaceStorage()
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) PlaceList* placeList;

@end


static PlaceStorage* _favoriteManager = nil;
static PlaceStorage* _historyManager = nil;

@implementation PlaceStorage

@synthesize type = _type;
@synthesize placeList = _placeList;

- (void)dealloc
{
    [_type release];
    [_placeList release];
    [super dealloc];
}

- (id)initWithType:(NSString*)typeValue
{
    self = [super init];
    if (self) {
        self.type = typeValue;
    }
    return self;
}

+ (PlaceStorage*)favoriteManager
{
    if (_favoriteManager == nil) {
        _favoriteManager = [[PlaceStorage alloc] initWithType:FAVORITE_STORAGE];
    }
    return _favoriteManager;
}

+ (PlaceStorage*)historyManager
{
    if (_historyManager == nil) {
        _historyManager = [[PlaceStorage alloc] initWithType:HISTORY_STORAGE];
    }
    return _historyManager;
}

- (NSString*)getFilePath
{
    NSString *filePath = nil;
    if (_type == FAVORITE_STORAGE) {
        filePath = [AppUtils getFavoriteFilePath:[[AppManager defaultManager] getCurrentCityId]];
    }
    else {
        //filePath = [AppUtils getHistoryFilePath:[[AppManager defaultManager] getCurrentCityId]];
        filePath = [AppUtils getDefaultHistoryFilePath];
    }
    
    return filePath;
}

- (void)loadPlaceList
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    if (data != nil) {
        @try {
            self.placeList = [PlaceList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<loadPlaceList> Caught %@%@", [exception name], [exception reason]);
        }
    }
}

- (NSArray*)allPlaces
{
    [self loadPlaceList];
    return [self.placeList listList];
}

- (void)writeToFileWithList:(NSArray*)newList
{
    PlaceList_Builder* builder = [[PlaceList_Builder alloc] init];    
    [builder setCityId:0];    
    [builder addAllList:newList];
    PlaceList* newPlaceList = [builder build];
    
    // save to files        
    PPDebug(@"<writeToFileWithList> filePath is :%@",[self getFilePath]);
    if (![[newPlaceList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<writeToFileWithList> wirteToFile error");
    } 
    [builder release];
    
    [self loadPlaceList];
}

- (void)addPlace:(Place*)place
{
    [self deletePlace:place];
    
    // generate new list by adding place into existing place list
    NSMutableArray* newList = [NSMutableArray arrayWithArray:[self allPlaces]];
    [newList addObject:place];  
    
    if (self.type == HISTORY_STORAGE) {
        while ([newList count]>30) {
            [newList removeObjectAtIndex:0];
        }
    }
    
    [self writeToFileWithList:newList];
}

- (void)deletePlace:(Place*)place
{
    BOOL found = NO;
    NSMutableArray* newList = [NSMutableArray arrayWithArray:[self allPlaces]];
    for (Place *placeTemp in newList) {
        if (placeTemp.placeId == place.placeId) {
            [newList removeObject:placeTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:newList];
    }
}

- (void)deleteAllPlaces
{
    [self writeToFileWithList:nil];
}

- (BOOL)isPlaceInFavorite:(int)placeId
{
    NSArray *arrary = [self allPlaces];
    for (Place *place in arrary) {
        if (place.placeId == placeId) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)allPlacesSortByLatest
{
    NSArray *array = [self allPlaces];
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    
    int count = [array count];
    for (int i = count-1 ; i >= 0 ; i--) {
        [mutableArray addObject:[array objectAtIndex:i]];
    }
    return mutableArray;
}

@end
