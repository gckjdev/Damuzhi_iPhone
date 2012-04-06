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
#import "WBEngine.h"

#define kSinaWeiBoAppKey        @"475196157"
#define kSinaWeiBoAppSecret     @"747adfaf3ec50dfe3791f9f0481365aa"

@interface MainController : PPViewController<UIActionSheetDelegate>
{
    CommonPlaceListController *_spotListComtroller;
    CommonPlaceListController *_hotelListComtroller;
    CommonPlaceListController *_restaurantListComtroller;
    CommonPlaceListController *_shoppingListComtroller;
    CommonPlaceListController *_entertainmentListComtroller;
    NearbyController *_nearbyController;
    MoreController *_moreController;
}

@property (nonatomic, retain) WBEngine *sinaWeiBoEngine;

- (IBAction)clickSpotButton:(id)sender;
- (IBAction)clickHotelButton:(id)sender;
- (IBAction)clickRestaurant:(id)sender;
- (IBAction)clickShopping:(id)sender;
- (IBAction)clickEntertainment:(id)sender;

- (IBAction)clickCityOverviewButton:(id)sender;
- (IBAction)clickTravelUtilityButton:(id)sender;
- (IBAction)clickNearbyButton:(id)sender;
- (IBAction)clickMoreButton:(id)sender;
-(void) clickTitle:(id)sender;
- (IBAction)clickFavorite:(id)sender;
- (IBAction)clickShare:(id)sender;

@end
