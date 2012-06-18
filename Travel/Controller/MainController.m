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
#import "FavoriteController.h"
#import "CityBasicController.h"
#import "CityBasicDataSource.h"
#import "TravelPreparationDataSource.h"
#import "TravelUtilityDataSource.h"
#import "TravelTransportDataSource.h"
#import "CommonPlace.h"
#import "AppDelegate.h"

#import "NearbyController.h"
#import "AppManager.h"
#import "CityManagementController.h"
#import "ShareToSinaController.h"
#import "ShareToQQController.h"
#import "RouteController.h"
#import "GuideController.h"
#import "CommonWebController.h"
#import "UIImageUtil.h"
#import "AppUtils.h"
#import "PackageManager.h"
#import "MobClick.h"
#import "PPDebug.h"

#import "CommonRouteListController.h"
#import "PackageTourListFilter.h"
#import "UnPackageTourListFilter.h"

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
        
    [self checkCurrentCityVersion];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createButtonView];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
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

- (IBAction)clickMoreButton:(id)sender
{
    MoreController *controller = [[MoreController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickFavorite:(id)sender
{
    FavoriteController *fc = [[FavoriteController alloc] init];
    [self.navigationController pushViewController:fc animated:YES];
    [fc release];
}

- (IBAction)clickHelp:(id)sender {
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = NSLS(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
//    NSObject<RouteListFilterProtocol>* filter = [PackageTourListFilter createFilter];
//    CommonRouteListController *controller = [[CommonRouteListController alloc] initWithFilterHandler:filter DepartCityId:1 destinationCityId:0 hasStatisticsLabel:YES];
//    
//    controller.navigationItem.title = [filter getRouteTypeName];
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
}

- (IBAction)clickShare:(id)sender
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLS(@"取消") destructiveButtonTitle:NSLS(@"通过短信") otherButtonTitles:NSLS(@"分享到新浪微博"), NSLS(@"分享到腾讯微博"), nil];
    [shareSheet showInView:self.view];
    [shareSheet release];
}

#pragma -mark share UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self sendSms:nil body:[NSString stringWithFormat:NSLS(@"kShareContent"),[MobClick getConfigParams:@"download_website"]]];
            break;
        }
        case 1:
        {
            ShareToSinaController *sc = [[ShareToSinaController alloc] init];
            [self.navigationController pushViewController:sc animated:YES];
            [sc release];
            break;
        }
        case 2:
        {
            ShareToQQController *shareToQQ = [[ShareToQQController alloc] init];
            [self.navigationController pushViewController:shareToQQ animated:YES];
            [shareToQQ release];
            break;
        }
        case 3:
            break;
        default:
            break;
    }
}

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

@end
