//
//  NearbyController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceService.h"
#import "PPTableViewController.h"
#import "PlaceListController.h"

@class PlaceListController;

@interface NearbyController : PPViewController<PlaceServiceDelegate, UIGestureRecognizerDelegate,PullDelegate, UIAlertViewDelegate, PlaceListControllerDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *distanceView;
@property (retain, nonatomic) IBOutlet UIView *categoryBtnsHolderView;
@property (retain, nonatomic) IBOutlet UIButton *allPlaceButton;
@property (retain, nonatomic) IBOutlet UIButton *spotButton;
@property (retain, nonatomic) IBOutlet UIButton *hotelButton;
@property (retain, nonatomic) IBOutlet UIButton *restaurantButton;
@property (retain, nonatomic) IBOutlet UIButton *shoppingButton;
@property (retain, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;

@end
