//
//  MainController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "CommonPlaceListController.h"
#import "SpotListFilter.h"
#import "HotelListFilter.h"
#import "RestaurantListFilter.h"
#import "ShoppingListFilter.h"
#import "EntertainmentListFilter.h"
#import "CityBasicController.h"
#import "CityBasicDataSource.h"
#import "TravelPreparationDataSource.h"
#import "TravelUtilityDataSource.h"
#import "TravelTransportDataSource.h"
#import "AppDelegate.h"
#import "PPNetworkRequest.h"

#import "NearbyController.h"
#import "AppManager.h"
#import "CityManagementController.h"

#import "RouteController.h"
#import "GuideController.h"
#import "CommonWebController.h"
#import "UIImageUtil.h"
#import "AppUtils.h"
#import "PackageManager.h"
#import "MobClick.h"
#import "PPDebug.h"
#include "UserService.h"
#import "CommonRouteListController.h"
#import "PackageTourListFilter.h"
#import "UnPackageTourListFilter.h"
#import "FavoriteController.h"
#import "DeviceDetection.h"

@interface MainController()

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_mainBackgroundImageView release];
    [_nearbyButton release];
    [_spotButton release];
    [_hotelButton release];
    [_restaurantButton release];
    [_shoppingButton release];
    [_entertainmentButton release];
    [_cityBasicButton release];
    [_travelPreparationButton release];
    [_travelUtilityButton release];
    [_travelTransportButton release];
    [_traveGuideButton release];
    [_favoriteButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) clickTitle:(id)sender
{
    CityManagementController *controller = [CityManagementController getInstance];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#define WIDTH_TOP_ARRAW 14
#define HEIGHT_TOP_ARRAW 7
#define WIDTH_BLANK_OF_TITLE 14

- (void)createButtonView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize withinSize = CGSizeMake(320, CGFLOAT_MAX);
    
    NSString *title = [NSString stringWithFormat:@"城市指南 — %@", [[AppManager defaultManager] getCurrentCityName]];    
    CGSize titleSize = [title sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeTailTruncation];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width+WIDTH_TOP_ARRAW+WIDTH_BLANK_OF_TITLE, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    [button setImage:[UIImage imageNamed:@"top_arrow.png"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+WIDTH_BLANK_OF_TITLE, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -WIDTH_TOP_ARRAW-WIDTH_BLANK_OF_TITLE, 0, 0);
    
//    button.titleLabel.shadowOffset = CGSizeMake(-1, -2);
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
        
    [button release];
}

#define TAG_CITY_UPDATE_ALERT 123
#define TAG_USER_LOCATION_SEVICE_DENY 124

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([DeviceDetection isIPhone5]) {
        PPDebug(@"is iPhone5");
        
        self.nearbyButton.frame = CGRectOffset(self.nearbyButton.frame, 0, 10);
        self.spotButton.frame = CGRectOffset(self.spotButton.frame, 0, 10);
        self.hotelButton.frame = CGRectOffset(self.hotelButton.frame, 0, 10);
        self.restaurantButton.frame = CGRectOffset(self.restaurantButton.frame, 0, 20);
        self.shoppingButton.frame = CGRectOffset(self.shoppingButton.frame, 0, 20);
        self.entertainmentButton.frame = CGRectOffset(self.entertainmentButton.frame, 0, 20);
        
        self.cityBasicButton.frame = CGRectOffset(self.cityBasicButton.frame, 0, 44);
        self.travelPreparationButton.frame = CGRectOffset(self.travelPreparationButton.frame, 0, 44);
        self.travelUtilityButton.frame = CGRectOffset(self.travelUtilityButton.frame, 0, 44);
        self.travelTransportButton.frame = CGRectOffset(self.travelTransportButton.frame, 0, 44);
        self.traveGuideButton.frame = CGRectOffset(self.traveGuideButton.frame, 0, 44);
        self.favoriteButton.frame = CGRectOffset(self.favoriteButton.frame, 0, 44);
    } else {
        PPDebug(@"is not iPhone5");
    }
    
    [self checkCurrentCityVersion];
    
    [[UserService defaultService] autoLogin:self];
}

- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    
    [self createButtonView];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self hideTabBar:NO];
    
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self hideTabBar:YES];
    
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
    [self setMainBackgroundImageView:nil];
    [self setNearbyButton:nil];
    [self setSpotButton:nil];
    [self setHotelButton:nil];
    [self setRestaurantButton:nil];
    [self setShoppingButton:nil];
    [self setEntertainmentButton:nil];
    [self setCityBasicButton:nil];
    [self setTravelPreparationButton:nil];
    [self setTravelUtilityButton:nil];
    [self setTravelTransportButton:nil];
    [self setTraveGuideButton:nil];
    [self setFavoriteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickSpotButton:(id)sender {
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[SpotListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickHotelButton:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[HotelListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickRestaurant:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[RestaurantListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickShopping:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[ShoppingListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickEntertainment:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[EntertainmentListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickCityBasicButton:(id)sender
{
    CityBasicController* controller = [[CityBasicController alloc] initWithDataSource:[CityBasicDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickTravelPreparationButton:(id)sender
{
    CommonWebController* controller = [[CommonWebController alloc] initWithDataSource:[TravelPreparationDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickTravelUtilityButton:(id)sender
{
    CommonWebController *controller = [[CommonWebController alloc]initWithDataSource:[TravelUtilityDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];  
}

- (IBAction)clickTravelTransportButton:(id)sender
{
    CommonWebController *controller = [[CommonWebController alloc]initWithDataSource:[TravelTransportDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];  
    
//    FavoriteController *controller = [[FavoriteController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
    
}

- (IBAction)clickTraveGuideButton:(id)sender
{
    GuideController *controller = [[GuideController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickFavoriteButton:(id)sender {
    FavoriteController *controller = [[FavoriteController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickNearbyButton:(id)sender
{
    NearbyController *controller = [[NearbyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];  
}


- (void)showUpdateCityAlert
{
    int currentCityId= [[AppManager defaultManager] getCurrentCityId];
    NSString *currentCityName = [[AppManager defaultManager] getCurrentCityName];
    NSString *currentCityCountry = [[AppManager defaultManager] getCountryName:currentCityId];
    int citySize = [[AppManager defaultManager] getCityDataSize:currentCityId];
    NSString *citySizeString = [NSString stringWithFormat:@"%0.2fM", citySize/1024.0/1024.0];
    
    NSString *alertTitle = NSLS(@"离线数据包更新提示");
    NSString *alertSubtitle = [NSString stringWithFormat:@"%@.%@", currentCityCountry, currentCityName];
    NSString *alertContent = [NSString stringWithFormat:@"有新的城市指南信息升级，是否更新？\n大小:%@", citySizeString];
    
    CommonDialog *dialog = [CommonDialog createDialogWithTitle:alertTitle
                                                      subTitle:alertSubtitle
                                                       content:alertContent
                                                 OKButtonTitle:NSLS(@"立刻升级")
                                             cancelButtonTitle:NSLS(@"下次提醒")
                                                      delegate:self];
    dialog.contentTextView.textAlignment = NSTextAlignmentCenter;
    [dialog showInView:self.view];
}

- (void)checkCurrentCityVersion
{
    City *currentCity = [[AppManager defaultManager] getCity:[[AppManager defaultManager] getCurrentCityId]];
    
    if (![AppUtils hasLocalCityData:currentCity.cityId]) {
        return;
    }
        
    if (![currentCity.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:currentCity.cityId]]){
        [self showUpdateCityAlert];
    }
}

#pragma mark: implementation of UserServiceDelegate.

- (void)loginDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，登录失败") title:nil];
        return;
    }
    
    if (result != 0) {
        NSString *str = [NSString stringWithFormat:NSLS(@"登录失败：%@"), resultInfo];
        [self popupMessage:str title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"登录成功") title:nil];    
}

#pragma mark - CommonDialogDelegate methods
- (void)didClickOkButton
{
    CityManagementController *controller = [CityManagementController getInstance];
    [self.navigationController pushViewController:controller animated:YES];
    [controller clickDownloadListButton:controller.downloadListBtn];
}


#pragma mark - AppManagerProtocol methods
- (void)currentCityDidChange:(int)newCityId
{
    [self checkCurrentCityVersion];
}


@end
