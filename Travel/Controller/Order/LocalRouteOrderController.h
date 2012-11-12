//
//  LocalRouteOrderController.h
//  Travel
//
//  Created by haodong on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewController.h"
#import "TouristRoute.pb.h"
#import "MonthViewController.h"
#import "SelectController.h"
#import "OrderService.h"
#import "NonMemberOrderController.h"
#import "PlaceOrderCell.h"


@interface LocalRouteOrderController : PPTableViewController <PlaceOrderCellDelegate, MonthViewControllerDelegate, SelectControllerDelegate, OrderServiceDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

- (id)initWithRoute:(LocalRoute *)route;


@end
