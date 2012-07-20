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


@interface MainController()

@property (retain, nonatomic) UIButton *currentSelectedButton;

@end

@implementation MainController
@synthesize homeButton = _homeButton;
@synthesize UnpackageButton = _UnpackageButton;
@synthesize PackageButton = _PackageButton;
@synthesize moreButton = _moreButton;

@synthesize currentSelectedButton = _currentSelectedButton;

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
    [_currentSelectedButton release];
    [_homeButton release];
    [_UnpackageButton release];
    [_PackageButton release];
    [_moreButton release];
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
    [self.navigationController pushViewController:controller animated:YES];
}

#define WIDTH_TOP_ARRAW 14
#define HEIGHT_TOP_ARRAW 7
#define WIDTH_BLANK_OF_TITLE 14

- (void)createButtonView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize withinSize = CGSizeMake(320, CGFLOAT_MAX);
    
    NSString *title = [NSString stringWithFormat:@"大拇指旅行 — %@", [[AppManager defaultManager] getCurrentCityName]];    
    CGSize titleSize = [title sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeTailTruncation];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width+WIDTH_TOP_ARRAW+WIDTH_BLANK_OF_TITLE, titleSize.height)];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    [button setImage:[UIImage imageNamed:@"top_arrow.png"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+WIDTH_BLANK_OF_TITLE, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -WIDTH_TOP_ARRAW-WIDTH_BLANK_OF_TITLE, 0, 0);
    
    [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
        
    [button release];
}

#define TAG_CITY_UPDATE_ALERT 123
#define TAG_USER_LOCATION_SEVICE_DENY 124

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"index_bg.png"];
    [super viewDidLoad];
    
    self.currentSelectedButton = self.homeButton;
    self.currentSelectedButton.selected = YES;
        
    [self checkCurrentCityVersion];
    
    [[UserService defaultService] autoLogin:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createButtonView];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:NO];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:YES];
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
    [self setHomeButton:nil];
    [self setUnpackageButton:nil];
    [self setPackageButton:nil];
    [self setMoreButton:nil];
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
}

- (IBAction)clickTraveGuideButton:(id)sender
{
    GuideController *controller = [[GuideController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickTravelRouteBtn:(id)sender {
    RouteController *controller = [[RouteController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickNearbyButton:(id)sender
{
    NearbyController *controller = [[NearbyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];  
}



- (void)updateSelectedButton:(UIButton *)button
{
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton = button;
    self.currentSelectedButton.selected = YES;
}


#pragma -mark share UIActionSheet delegate


- (void)checkCurrentCityVersion
{
    City *currentCity = [[AppManager defaultManager] getCity:[[AppManager defaultManager] getCurrentCityId]];
    if (![AppUtils hasLocalCityData:currentCity.cityId]) {
        return;
    }
        
    if (![currentCity.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:currentCity.cityId]]){
        NSString *message = NSLS(@"离线数据有更新，是否现在更新？");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:message delegate:self cancelButtonTitle:NSLS(@"以后再说") otherButtonTitles:NSLS(@"现在更新"),nil] autorelease];
        alert.tag = TAG_CITY_UPDATE_ALERT;
        [alert show];
    }
}

#pragma mark -
#pragma mark: implementation of alert view delegate.

- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView1.tag) {
        case TAG_CITY_UPDATE_ALERT:
            if (buttonIndex == 1) {
                CityManagementController *controller = [CityManagementController getInstance];

                [self.navigationController pushViewController:controller animated:YES];
                
                [controller clickDownloadListButton:controller.downloadListBtn];
            }
            break;
            
        default:
            break;
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
        NSString *str = [NSString stringWithFormat:NSLS(@"登陆失败：%@"), resultInfo];
        [self popupMessage:str title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"登陆成功") title:nil];    
}

@end
