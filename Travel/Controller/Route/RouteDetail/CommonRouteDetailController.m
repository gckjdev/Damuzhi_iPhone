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
#import "RouteFeekbackListController.h"
#import "PlaceOrderController.h"
#import "CommonWebController.h"
#import "CommonPlaceDetailController.h"
#import "FlightController.h"
#import "RouteUtils.h"
#import "PPDebug.h"
#import "UIUtils.h"

@interface CommonRouteDetailController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) TouristRoute *route;

@property (retain, nonatomic) RouteIntroductionController *introductionController;
@property (retain, nonatomic) CommonWebController *feeController;
@property (retain, nonatomic) CommonWebController *bookingPolicyController;
@property (retain, nonatomic) RouteFeekbackListController *feekbackListController;

@property (retain, nonatomic) UIButton *currentSelectedButton;
@property (retain, nonatomic) NSArray *phoneList;

@end

@implementation CommonRouteDetailController

@synthesize routeId = _routeId;
@synthesize routeType = _routeType;
@synthesize route = _route;

@synthesize introductionController = _introductionController;
@synthesize feeController = _feeController;
@synthesize bookingPolicyController = _bookingPolicyController;
@synthesize feekbackListController = _feekbackListController;

@synthesize introductionButton = _introductionButton;
@synthesize costDescriptionButton = _costDescriptionButton;
@synthesize bookingPolicyButton = _bookingPolicyButton;
@synthesize userFeekbackButton = _userFeekbackButton;
@synthesize buttonsHolderView = _buttonsHolderView;
@synthesize contentView = _contentView;
@synthesize currentSelectedButton = _currentSelectedButton;
@synthesize phoneList = _phoneList;

- (void)dealloc {
    [_route release];
    [_introductionController release];
    [_feeController release];
    [_feekbackListController release];
    
    [_introductionButton release];
    [_costDescriptionButton release];
    [_bookingPolicyButton release];
    [_userFeekbackButton release];
    
    [_buttonsHolderView release];
    [_contentView release];
    [_currentSelectedButton release];
    [_phoneList release];
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
    

//    self.phoneList = [NSArray arrayWithObjects:@"toBeFinished", nil];
    
    self.buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] lineNavBgImage]];
    
    self.currentSelectedButton = self.introductionButton;
    self.introductionButton.selected = YES;
    
    [[RouteService defaultService] findRouteWithRouteId:_routeId viewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)clickConsult:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in self.phoneList){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[self.phoneList count]];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    [UIUtils makeCall:[self.phoneList objectAtIndex:buttonIndex]];
}



- (void)viewDidUnload
{
    [self setIntroductionButton:nil];
    [self setCostDescriptionButton:nil];
    [self setBookingPolicyButton:nil];
    [self setUserFeekbackButton:nil];
    [self setButtonsHolderView:nil];
    [self setContentView:nil];
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
    
    [_introductionController showInView:self.contentView];
}



- (IBAction)clickCostDecriptionButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feeController == nil) {
        self.feeController = [[[CommonWebController alloc] initWithWebUrl:_route.fee] autorelease];
    }
    
    [_feeController showInView:self.contentView];    
}



- (IBAction)clickBookingPolicyButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_bookingPolicyController == nil) {
        self.bookingPolicyController = [[[CommonWebController alloc] initWithWebUrl:_route.bookingNotice] autorelease];
    }
    
    [_bookingPolicyController showInView:self.contentView];        
    
}


- (IBAction)clickUserFeekbackButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feekbackListController == nil) {
        self.feekbackListController = [[[RouteFeekbackListController alloc] initWithRouteId:_routeId] autorelease];

    }

    [_feekbackListController showInView:self.contentView];   
}

- (void)findRequestDone:(int)result route:(TouristRoute *)route
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.route = route;
    
    self.phoneList = [NSArray arrayWithObjects:_route.contactPhone, nil];
//    NSLog(@"contact phone is %@", _route.contactPhone);
    
    [self clickIntroductionButton:_introductionButton];
}

- (void)didClickBookButton:(int)packageId
{
    PlaceOrderController *controller = [[[PlaceOrderController alloc] initWithRoute:_route routeType:_routeType packageId:packageId] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
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
    
    FlightController *controller = [[FlightController alloc] initWithDepartReturnFlight:package.departFlight returnFlight:package.returnFlight];
    
    
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
