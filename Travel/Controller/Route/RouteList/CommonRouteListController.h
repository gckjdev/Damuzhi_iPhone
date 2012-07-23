//
//  CommonRouteListController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"
#import "SelectController.h"
#import "SelectCityController.h"
#import "RouteSelectController.h"

@protocol RouteListFilterProtocol <NSObject>

+ (NSObject<RouteListFilterProtocol>*)createFilter;

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;

- (int)getRouteType;

- (NSString*)getRouteTypeName;

- (void)findRoutesWithStart:(int)start 
                      count:(int)count 
       RouteSelectedItemIds:(RouteSelectedItemIds *)routeSelectedItemIds
             needStatistics:(BOOL)needStatistics 
             viewController:(PPViewController<RouteServiceDelegate>*)viewController;

@end

@interface CommonRouteListController : PPTableViewController <RouteServiceDelegate, SelectControllerDelegate, SelectCityDelegate, RouteSelectControllerDelegate>

- (id)initWithFilterHandler:(NSObject<RouteListFilterProtocol>*)filterHandler
               DepartCityId:(int)departCityId
          destinationCityId:(int)destinationCityId
         hasStatisticsLabel:(BOOL)hasStatisticsLabel;

@end
