//
//  RouteFeekback.h
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"

@interface RouteFeekbackListController : PPTableViewController <RouteServiceDelegate>

- (id)initWithRouteId:(int)routeId;

- (void)showInView:(UIView *)superView;

@end
