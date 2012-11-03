//
//  LocalRouteListController.h
//  Travel
//
//  Created by 小涛 王 on 12-9-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"
#import "AppManager.h"

@interface LocalRouteListController : PPTableViewController <RouteServiceDelegate, AppManagerProtocol>

@end
