//
//  RouteStorage.m
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "RouteStorage.h"
#import "AppUtils.h"
#import "TouristRoute.pb.h"
#import "LogUtil.h"
#import "TravelNetworkConstants.h"

@interface RouteStorage()

@property (assign, nonatomic) int routeType;

- (NSString*)getFilePath;
- (void)writeToFileWithList:(NSArray*)newList;

@end


static RouteStorage *_followManager = nil;

@implementation RouteStorage
@synthesize routeType = _routeType;

+ (RouteStorage *)followManager:(int)routeType
{
    if (_followManager == nil) {
        _followManager = [[RouteStorage alloc] init];
    }
    
    _followManager.routeType = routeType;
    return _followManager;
}


- (NSArray*)findAllRoutes
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    TouristRouteList *list = nil;
    if (data != nil) {
        @try {
            list = [TouristRouteList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<RouteStorage> findAllRoutes Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return [list routesList];
}


- (void)addRoute:(TouristRoute *)route
{
    [self deleteRoute:route];
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    [mutableArray addObject:route];    
    [self writeToFileWithList:mutableArray];
}


- (void)deleteRoute:(TouristRoute *)route
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    for (TouristRoute *routeTemp in mutableArray) {
        if (routeTemp.routeId == route.routeId) {
            [mutableArray removeObject:routeTemp];
            found = YES;
            break;
        }
    }
    
    if (found) {
        [self writeToFileWithList:mutableArray];
    }
}

- (BOOL)isExistRoute:(int)routeId
{
    NSArray *array = [self findAllRoutes];
    for (TouristRoute *routeTemp in array) {
        if (routeTemp.routeId == routeId) {
            return YES;
        }
    }
    return NO;
}


- (NSString*)getFilePath
{
    return [AppUtils getFollowRoutesFilePath:_routeType];
}


- (void)writeToFileWithList:(NSArray*)newList
{
    TouristRouteList_Builder* builder = [[TouristRouteList_Builder alloc] init];    
    [builder addAllRoutes:newList];
    TouristRouteList *newTouristRouteList = [builder build];
    
    PPDebug(@"<RouteStorage> %@",[self getFilePath]);
    if (![[newTouristRouteList data] writeToFile:[self getFilePath]  atomically:YES]) {
        PPDebug(@"<RouteStorage> error");
    } 
    [builder release];
}

- (NSArray *)findAllRoutesSortByLatest
{
    NSArray *array = [self findAllRoutes];
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    
    int count = [array count];
    for (int i = count-1 ; i >= 0 ; i--) {
        [mutableArray addObject:[array objectAtIndex:i]];
    }
    return mutableArray;
}

@end
