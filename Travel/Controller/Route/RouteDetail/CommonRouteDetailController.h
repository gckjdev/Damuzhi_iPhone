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

@interface CommonRouteDetailController : PPTableViewController <RouteServiceDelegate, RouteIntroductionControllerDelegate, PlaceServiceDelegate>







@property (retain, nonatomic) IBOutlet UIButton *introductionButton;
@property (retain, nonatomic) IBOutlet UIButton *costDescriptionButton;
@property (retain, nonatomic) IBOutlet UIButton *bookingPolicyButton;
@property (retain, nonatomic) IBOutlet UIButton *userFeekbackButton;
@property (retain, nonatomic) IBOutlet UIView *buttonsHolderView;

@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (id)initWithRouteId:(int)routeId routeType:(int)routeType;

@end
