//
//  CommonRouteDetailController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonRouteDetailController.h"
#import "TouristRoute.pb.h"
#import "PPNetworkRequest.h"
#import "ImageManager.h"
#import "RouteFeekbackController.h"
#import "PlaceOrderController.h"
#import "CommonWebController.h"
#import "CommonPlaceDetailController.h"
#import "FlightController.h"
#import "RouteUtils.h"
#import "PPDebug.h"

@interface CommonRouteDetailController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) TouristRoute *route;

@property (retain, nonatomic) RouteIntroductionController *introductionController;
@property (retain, nonatomic) CommonWebController *feeController;
@property (retain, nonatomic) CommonWebController *bookingPolicyController;
@property (retain, nonatomic) RouteFeekbackController *userFeekbackController;

@property (retain, nonatomic) UIButton *currentSelectedButton;

@end

@implementation CommonRouteDetailController

@synthesize routeId = _routeId;
@synthesize routeType = _routeType;
@synthesize route = _route;

@synthesize introductionController = _introductionController;
@synthesize feeController = _feeController;
@synthesize bookingPolicyController = _bookingPolicyController;
@synthesize userFeekbackController = _userFeekbackController;

@synthesize introductionButton = _introductionButton;
@synthesize costDescriptionButton = _costDescriptionButton;
@synthesize bookingPolicyButton = _bookingPolicyButton;
@synthesize userFeekbackButton = _userFeekbackButton;
@synthesize buttonsHolderView = _buttonsHolderView;
@synthesize contentScrollView = _contentScrollView;
@synthesize currentSelectedButton = _currentSelectedButton;


- (void)dealloc {
    [_route release];
    [_introductionController release];
    [_feeController release];
    [_userFeekbackController release];
    
    [_introductionButton release];
    [_costDescriptionButton release];
    [_bookingPolicyButton release];
    [_userFeekbackButton release];
    
    [_buttonsHolderView release];
    [_contentScrollView release];
    [_currentSelectedButton release];
    
    [super dealloc];
}

- (id)initWithRouteId:(int)routeId routeType:(int)routeType
{
    if (self = [super init]) {
        self.routeId = routeId;
        self.routeType = routeType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.title = @"路线详情";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    self.buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] lineNavBgImage]];
    
    self.currentSelectedButton = self.introductionButton;
    self.introductionButton.selected = YES;
    
    [[RouteService defaultService] findRouteWithRouteId:_routeId viewController:self];
}

- (void)viewDidUnload
{
    [self setIntroductionButton:nil];
    [self setCostDescriptionButton:nil];
    [self setBookingPolicyButton:nil];
    [self setUserFeekbackButton:nil];
    [self setButtonsHolderView:nil];
    [self setContentScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)updateSelectedButton:(UIButton *)button
{
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton = button;
    self.currentSelectedButton.selected = YES;
}


- (IBAction)clickIntroductionButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_introductionController == nil) {
        self.introductionController = [[[RouteIntroductionController alloc] initWithRoute:_route routeType:_routeType] autorelease];
        _introductionController.aDelegate = self;
    }
    
    [_introductionController showInView:self.contentScrollView];
}



- (IBAction)clickCostDecriptionButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feeController == nil) {
        self.feeController = [[[CommonWebController alloc] initWithWebUrl:_route.fee] autorelease];
    }
    
    [_feeController showInView:self.contentScrollView];    
}



- (IBAction)clickBookingPolicyButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_bookingPolicyController == nil) {
        self.bookingPolicyController = [[[CommonWebController alloc] initWithWebUrl:_route.bookingNotice] autorelease];
    }
    
    [_bookingPolicyController showInView:self.contentScrollView];        
    
}


- (IBAction)clickUserFeekbackButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_userFeekbackController == nil) {
        self.userFeekbackController = [[[RouteFeekbackController alloc] initWithRouteId:_routeId] autorelease];

    }

    [_userFeekbackController showInView:self.contentScrollView];   
}

- (void)findRequestDone:(int)result route:(TouristRoute *)route
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.route = route;
    
    [self clickIntroductionButton:_introductionButton];
}

- (void)didClickBookButton:(int)packageId
{
    PlaceOrderController *controller = [[[PlaceOrderController alloc] initWithRoute:_route routeType:_routeType packageId:packageId] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickConsult:(id)sender
{
    [self popupMessage:NSLS(@"拨打电话") title:nil];
}

- (void)didSelectedPlace:(int)placeId
{
    [[PlaceService defaultService] findPlace:placeId viewController:self];
}

- (void)findRequestDone:(int)resultCode
                 result:(int)result 
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    CommonPlaceDetailController *controller = [[[CommonPlaceDetailController alloc] initWithPlace:place] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickFlight:(int)packageId
{
    PPDebug(@"packageId is %d", packageId);
    
    TravelPackage *package = [RouteUtils findPackageByPackageId:packageId fromPackageList:_route.packagesList];
    
    FlightController *controller = [[FlightController alloc] initWithDepartFlight:package.departFlight returnFlight:package.returnFlight];
    
    
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


@end
