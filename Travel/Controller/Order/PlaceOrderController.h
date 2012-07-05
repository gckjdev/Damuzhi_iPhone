//
//  PlaceOrderController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "TouristRoute.pb.h"
#import "MonthViewController.h"
#import "SelectController.h"
#import "OrderService.h"
#import "NonMemberOrderController.h"

@interface PlaceOrderController : PPViewController <MonthViewControllerDelegate, SelectControllerDelegate, OrderServiceDelegate, NonMemberOrderDelegate>

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;

@property (retain, nonatomic) IBOutlet UILabel *departCityLabel;

@property (retain, nonatomic) IBOutlet UIButton *departDateButton;
@property (retain, nonatomic) IBOutlet UIButton *adultButton;
@property (retain, nonatomic) IBOutlet UIButton *childrenButton;

@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

@property (retain, nonatomic) IBOutlet UILabel *noteLabel;

- (id)initWithRoute:(TouristRoute *)route 
          routeType:(int)routeType
          packageId:(int)packageId;

@end
