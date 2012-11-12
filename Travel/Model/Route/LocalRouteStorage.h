//
//  LocalRouteStorage.h
//  Travel
//
//  Created by haodong on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocalRoute;

@interface LocalRouteStorage : NSObject

+ (LocalRouteStorage *)followManager;
- (NSArray*)findAllRoutes;
- (void)addRoute:(LocalRoute *)route;
- (void)deleteRoute:(LocalRoute *)route;
- (BOOL)isExistRoute:(int)routeId;
- (NSArray *)findAllRoutesSortByLatest;

@end
