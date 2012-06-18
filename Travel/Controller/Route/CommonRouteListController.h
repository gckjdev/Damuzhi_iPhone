//
//  CommonRouteListController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"

@protocol RouteListFilterProtocol <NSObject>

+ (NSObject<RouteListFilterProtocol>*)createFilter;

- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;

- (NSString*)getRouteTypeName;

- (void)findRoutesWithDepartCityId:(int)departCityId
                 destinationCityId:(int)destinationCityId
                             start:(int)start
                             count:(int)count
                    viewController:(PPViewController<RouteServiceDelegate>*)viewController;

@end

@interface CommonRouteListController : PPTableViewController <RouteServiceDelegate>

- (id)initWithFilterHandler:(NSObject<RouteListFilterProtocol>*)filterHandler
               DepartCityId:(int)departCityId
          destinationCityId:(int)destinationCityId
         hsaStatisticsLabel:(BOOL)hasStatisticsLabel;

@end
