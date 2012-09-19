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
- (void)findRequestDone:(int)result
             totalCount:(int)totalCount
                   list:(NSArray*)list
             statistics:(RouteStatistics *)statistics;

- (void)findRequestDone:(int)result
             totalCount:(int)totalCount
                   list:(NSArray*)list;

- (void)findRequestDone:(int)result
                  route:(TouristRoute *)route;

- (void)findRequestDone:(int)result
             localRoute:(LocalRoute *)route;

- (void)followRouteDone:(int)resultCode 
                 result:(int)result 
             resultInfo:(NSString *)resultInfo;

- (void)unfollowRouteDone:(int)resultCode 
                   result:(int)result 
               resultInfo:(NSString *)resultInfo;

- (void)routeFeekBackDidSend:(int)resultCode 
                      result:(int)result 
                  resultInfo:(NSString *)resultInfo;

@end


@class RouteSelectedItemIds;
@interface RouteService : CommonService

+ (RouteService*)defaultService;



- (void)findRoutesWithType:(int)routeType
                     start:(int)start
                     count:(int)count 
           selectedItemIds:(RouteSelectedItemIds *)selectedItemIds
            needStatistics:(BOOL)needStatistics 
            viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)findRouteWithRouteId:(int)routeId viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)queryRouteFeekbacks:(int)routeId 
                      start:(int)start
                      count:(int)count
             viewController:(PPViewController<RouteServiceDelegate>*)viewController;
                
- (void)followRoute:(TouristRoute *)route 
          routeType:(int)routeType 
     viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)unfollowRoute:(TouristRoute *)route 
          routeType:(int)routeType 
     viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)routeFeedbackWithRouteId:(int)routeId 
                         orderId:(int)orderId
                            rank:(int)rank
                         content:(NSString *)content   
                  viewController:(PPViewController<RouteServiceDelegate>*)viewController;




//for local route
- (void)findLocalRoutes:(int)cityId
                  start:(int)start
                  count:(int)count 
         needStatistics:(BOOL)needStatistics 
         viewController:(PPViewController<RouteServiceDelegate>*)viewController;


- (void)findLocalRouteWithRouteId:(int)routeId 
                   viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)followLocalRoute:(LocalRoute *)route viewController:(PPViewController<RouteServiceDelegate>*)viewController;

- (void)unFollowLocalRoute:(LocalRoute *)route viewController:(PPViewController<RouteServiceDelegate>*)viewController;

@end
