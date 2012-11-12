//
//  LocalRouteStorage.m
//  Travel
//
//  Created by haodong on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteStorage.h"
#import "TouristRoute.pb.h"
#import "LogUtil.h"
#import "AppUtils.h"

@interface LocalRouteStorage()

@property (assign, nonatomic) int routeType;

- (NSString*)getFilePath;
- (void)writeToFileWithList:(NSArray*)newList;

@end


static LocalRouteStorage *_localRouteFollowManager = nil;

@implementation LocalRouteStorage

@synthesize routeType = _routeType;

+ (LocalRouteStorage *)followManager
{
    if (_localRouteFollowManager == nil) {
        _localRouteFollowManager = [[LocalRouteStorage alloc] init];
    }
    
    return _localRouteFollowManager;
}


- (NSArray*)findAllRoutes
{
    NSData* data = [NSData dataWithContentsOfFile:[self getFilePath]];
    LocalRouteList *list = nil;
    if (data != nil) {
        @try {
            list = [LocalRouteList parseFromData:data];
        }
        @catch (NSException *exception) {
            PPDebug(@"<RouteStorage> findAllRoutes Caught %@%@", [exception name], [exception reason]);
        }
    }
    
    return [list routesList];
}


- (void)addRoute:(LocalRoute *)route
{
    [self deleteRoute:route];
    
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    [mutableArray addObject:route];    
    [self writeToFileWithList:mutableArray];
}


- (void)deleteRoute:(LocalRoute *)route
{
    BOOL found = NO;
    NSMutableArray* mutableArray = [NSMutableArray arrayWithArray:[self findAllRoutes]];
    for (LocalRoute *routeTemp in mutableArray) {
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
    for (LocalRoute *routeTemp in array) {
        if (routeTemp.routeId == routeId) {
            return YES;
        }
    }
    return NO;
}


- (NSString*)getFilePath
{
    return [AppUtils getFollowLocalRoutesFilePath];
}


- (void)writeToFileWithList:(NSArray*)newList
{
    LocalRouteList_Builder* builder = [[LocalRouteList_Builder alloc] init];    
    [builder addAllRoutes:newList];
    LocalRouteList *newLocalRouteList = [builder build];
    
    PPDebug(@"<RouteStorage> %@",[self getFilePath]);
    if (![[newLocalRouteList data] writeToFile:[self getFilePath]  atomically:YES]) {
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
