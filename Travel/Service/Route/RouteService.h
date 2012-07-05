//
//  RouteService.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "Package.pb.h"

#define ROUTE_TYPE_PACKAGE_TOUR  OBJECT_LIST_ROUTE_PACKAGE_TOUR         // 跟团游
#define ROUTE_TYPE_UNPACKAGE_TOUR OBJECT_LIST_ROUTE_UNPACKAGE_TOUR      // 自由行(旅行社路线)
#define ROUTE_TYPE_SELF_GUIDE_TOUR OBJECT_LIST_ROUTE_SELF_GUIDE_TOUR    // 自定制

@class PPViewController;

@protocol RouteServiceDelegate <NSObject>

@optional
- (void)findRequestDone:(int)result totalCount:(int)totalCount list:(NSArray*)list;
- (void)findRequestDone:(int)result route:(TouristRoute *)route;


@end

@interface RouteService : CommonService

+ (RouteService*)defaultService;

- (void)findRoutesWithType:(int)routeType
              departCityId:(int)departCityId
         destinationCityId:(int)destinationCityId
                     start:(int)start
                     count:(int)count
            viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)findRouteWithRouteId:(int)routeId viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)queryRouteFeekbacks:(int)routeId 
                      start:(int)start
                      count:(int)count
             viewController:(PPViewController<RouteServiceDelegate>*)viewController;
                

@end
