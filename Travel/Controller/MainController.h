//
//  MainController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "CommonPlaceListController.h"
#import "MoreController.h"
#import "NearbyController.h"
#import "UserService.h"
#import "CommonDialog.h"

@interface MainController : PPViewController<UIActionSheetDelegate, UserServiceDelegate, CommonDialogDelegate, AppManagerProtocol>
@property (retain, nonatomic) IBOutlet UIImageView *mainBackgroundImageView;
@property (retain, nonatomic) IBOutlet UIButton *nearbyButton;
@property (retain, nonatomic) IBOutlet UIButton *spotButton;
@property (retain, nonatomic) IBOutlet UIButton *hotelButton;
@property (retain, nonatomic) IBOutlet UIButton *restaurantButton;
@property (retain, nonatomic) IBOutlet UIButton *shoppingButton;
@property (retain, nonatomic) IBOutlet UIButton *entertainmentButton;
@property (retain, nonatomic) IBOutlet UIButton *cityBasicButton;
@property (retain, nonatomic) IBOutlet UIButton *travelPreparationButton;
@property (retain, nonatomic) IBOutlet UIButton *travelUtilityButton;
@property (retain, nonatomic) IBOutlet UIButton *travelTransportButton;
@property (retain, nonatomic) IBOutlet UIButton *traveGuideButton;
@property (retain, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)clickSpotButton:(id)sender;
- (IBAction)clickHotelButton:(id)sender;
- (IBAction)clickRestaurant:(id)sender;
- (IBAction)clickShopping:(id)sender;
- (IBAction)clickEntertainment:(id)sender;

- (IBAction)clickCityBasicButton:(id)sender;
- (IBAction)clickTravelPreparationButton:(id)sender;
- (IBAction)clickTravelUtilityButton:(id)sender;
- (IBAction)clickTravelTransportButton:(id)sender;
- (IBAction)clickTraveGuideButton:(id)sender;
- (IBAction)clickNearbyButton:(id)sender;
- (void) clickTitle:(id)sender;

@end
