//
//  PlaceOrderController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "TouristRoute.pb.h"
#import "MonthViewController.h"
#import "SelectController.h"
#import "OrderService.h"
#import "NonMemberOrderController.h"
#import "PlaceOrderCell.h"


@interface PlaceOrderController : PPTableViewController <PlaceOrderCellDelegate, MonthViewControllerDelegate, SelectControllerDelegate, OrderServiceDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

- (id)initWithRoute:(TouristRoute *)route 
          routeType:(int)routeType
          packageId:(int)packageId ;

@end
