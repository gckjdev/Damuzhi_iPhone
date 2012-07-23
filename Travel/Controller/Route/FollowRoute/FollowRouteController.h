//
//  FollowRouteController.h
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"

@interface FollowRouteController : PPTableViewController <RouteServiceDelegate>

- (id)initWithRouteType:(int)routeType;

@end
