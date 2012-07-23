//
//  RouteSelectController.h
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "SelectedItemIdsManager.h"

@protocol RouteSelectControllerDelegate <NSObject>

@optional
- (void)didClickFinish;

@end

@interface RouteSelectController : PPTableViewController

@property (assign, nonatomic) id<RouteSelectControllerDelegate> aDelegate;

- (id)initWithRouteType:(int)routeType
        selectedItemIds:(RouteSelectedItemIds *)selectedItemIds;


@end
