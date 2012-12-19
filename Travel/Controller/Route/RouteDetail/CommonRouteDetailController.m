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
#import "RouteUtils.h"
#import "PPDebug.h"
#import "UIUtils.h"
#import "AppManager.h"
#import "FontSize.h"

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
@synthesize routeNameLabel = _routeNameLabel;

@synthesize routeIdLabel = _routeIdLabel;
@synthesize agencyNameLabel = _agencyNameLabel;
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
    
    [_routeNameLabel release];
    [_routeIdLabel release];
    [_agencyNameLabel release];
    [_bookingPolicyController release];
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
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    self.buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] lineNavBgImage]];
    
    self.currentSelectedButton = self.introductionButton;
    self.introductionButton.selected = YES;

    [self.introductionButton setContentEdgeInsets:UIEdgeInsetsMake(4, 3, 2, 3)];
    [self.costDescriptionButton setContentEdgeInsets:UIEdgeInsetsMake(4, 3, 2, 3)];
    [self.bookingPolicyButton setContentEdgeInsets:UIEdgeInsetsMake(4, 3, 2, 3)];
    [self.userFeekbackButton setContentEdgeInsets:UIEdgeInsetsMake(4, 3, 2, 3)];

    self.introductionController = [[[RouteIntroductionController alloc] init] autorelease];
    [self.introductionController showInView:self.contentView];
    _introductionController.aDelegate = self;
    self.introductionButton.selected = YES;
    self.costDescriptionButton.userInteractionEnabled = NO;
    self.userFeekbackButton.userInteractionEnabled = NO;
    self.bookingPolicyButton.userInteractionEnabled = NO;

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
        PPDebug(@"phone/title is %@",title);
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
    
    NSString *phone = [self.phoneList objectAtIndex:buttonIndex];
    PPDebug(@"phone is %@", phone);
//    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];    
    [UIUtils makeCall:phone];
}



- (void)viewDidUnload
{
    [self setIntroductionButton:nil];
    [self setCostDescriptionButton:nil];
    [self setBookingPolicyButton:nil];
    [self setUserFeekbackButton:nil];
    [self setButtonsHolderView:nil];
    [self setContentView:nil];
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [self setAgencyNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)updateSelectedButton:(UIButton *)button
{
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton = button;
    self.currentSelectedButton.selected = YES;
    UIColor *color = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [button setTitleColor:color forState:UIControlStateSelected];
}


- (IBAction)clickIntroductionButton:(id)sender {
    
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
//    if (_introductionController == nil) {
//        self.introductionController = [[[RouteIntroductionController alloc] init] autorelease];
//        _introductionController.aDelegate = self;
//        [_introductionController showInView:self.contentView];
//    }
    [self.contentView bringSubviewToFront:_introductionController.view];
}



- (IBAction)clickCostDecriptionButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feeController == nil) {
        self.feeController = [[[CommonWebController alloc] initWithWebUrl:_route.fee] autorelease];
        _feeController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + 79);
        
        [_feeController showInView:self.contentView];
    }
    
    [self.contentView bringSubviewToFront:_feeController.view];
}



- (IBAction)clickBookingPolicyButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_bookingPolicyController == nil) {
        self.bookingPolicyController = [[[CommonWebController alloc] initWithWebUrl:_route.bookingNotice] autorelease];
        
        _bookingPolicyController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + 79);
        [_bookingPolicyController showInView:self.contentView];  
    }
    
    [self.contentView bringSubviewToFront:_bookingPolicyController.view];
}


- (IBAction)clickUserFeekbackButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feekbackListController == nil) {
        self.feekbackListController = [[[RouteFeekbackListController alloc] initWithRouteId:_routeId] autorelease];
        [_feekbackListController showInView:self.contentView];   
    }
    
    [self.contentView bringSubviewToFront:_feekbackListController.view];
}

- (void)findRequestDone:(int)result route:(TouristRoute *)route
{
    self.costDescriptionButton.userInteractionEnabled = YES;
    self.userFeekbackButton.userInteractionEnabled = YES;
    self.bookingPolicyButton.userInteractionEnabled = YES;
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.route = route;
    
    self.phoneList = [NSArray arrayWithObjects:_route.contactPhone, nil];
    PPDebug(@"_route.contactPhone is %@",_route.contactPhone);
    
    [self.routeNameLabel setText:_route.name];
    PPDebug(@"_route.name is %@",_route.name);
    self.routeNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0.0 alpha:1.0];
    _routeIdLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [self.routeIdLabel setText:[NSString stringWithFormat:NSLS(@"编号：%d"), _route.routeId]];
    
    _agencyNameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [_agencyNameLabel setText:[[AppManager defaultManager] getAgencyShortName:_route.agencyId]];

    [_introductionController updateWithRoute:_route routeType:_routeType];
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
//    PPDebug(@"packageId is %d", packageId);
//    
//    TravelPackage *package = [RouteUtils findPackageByPackageId:packageId fromPackageList:_route.packagesList];
//    
//    FlightController *controller = [[FlightController alloc] initWithDepartReturnFlight:package.departFlight returnFlight:package.returnFlight];
//    
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
}

@end
