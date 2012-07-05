//
//  FlightController.h
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "TouristRoute.pb.h"

@interface FlightController : PPTableViewController

- (id)initWithDepartFlight:(Flight *)departFlight returnFlight:(Flight *)returnFlight;


@property (retain, nonatomic) IBOutlet UILabel *departFlightLabel;


@property (retain, nonatomic) IBOutlet UILabel *departFlightLaunchInfoLabel;



@property (retain, nonatomic) IBOutlet UILabel *departFlightDescendInfoLabel;


@property (retain, nonatomic) IBOutlet UILabel *departFlightModeLabel;



@property (retain, nonatomic) IBOutlet UILabel *returnFlightLabel;

@property (retain, nonatomic) IBOutlet UILabel *returnFlightLaunchInforLabel;



@property (retain, nonatomic) IBOutlet UILabel *returnFlightDescendInforLabel;


@property (retain, nonatomic) IBOutlet UILabel *returnFlightModeLabel;


@property (retain, nonatomic) IBOutlet UIImageView *returnFlightBackgroundImage;

@property (retain, nonatomic) IBOutlet UIImageView *returnFlightBackgroundImage2;
@end
