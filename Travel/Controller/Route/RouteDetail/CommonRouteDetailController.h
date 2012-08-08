//
//  CommonRouteDetailController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "RouteService.h"
#import "RouteIntroductionController.h"
#import "PlaceService.h"
#import "PlaceOrderController.h"

@interface CommonRouteDetailController : PPTableViewController <RouteServiceDelegate, RouteIntroductionControllerDelegate, PlaceServiceDelegate, UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UIButton *introductionButton;
@property (retain, nonatomic) IBOutlet UIButton *costDescriptionButton;
@property (retain, nonatomic) IBOutlet UIButton *bookingPolicyButton;
@property (retain, nonatomic) IBOutlet UIButton *userFeekbackButton;
@property (retain, nonatomic) IBOutlet UIView *buttonsHolderView;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *agencyNameLabel;

- (id)initWithRouteId:(int)routeId routeType:(int)routeType;

@end
