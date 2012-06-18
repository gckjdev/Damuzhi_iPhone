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
#import "RouteIntroductionController.h"
#import "ImageManager.h"

@interface CommonRouteDetailController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) TouristRoute *route;

@property (retain, nonatomic) RouteIntroductionController *introductionController;

@end

@implementation CommonRouteDetailController

@synthesize routeId = _routeId;
@synthesize routeType = _routeType;
@synthesize route = _route;

@synthesize introductionController = _introductionController;

@synthesize introductionButton = _introductionButton;
@synthesize costDescriptionButton = _costDescriptionButton;
@synthesize bookingPolicyButton = _bookingPolicyButton;
@synthesize userFeekbackButton = _userFeekbackButton;
@synthesize buttonsHolderView = _buttonsHolderView;
@synthesize contentScrollView = _contentScrollView;


- (void)dealloc {
    [_route release];
    [_introductionController release];
    
    [_introductionButton release];
    [_costDescriptionButton release];
    [_bookingPolicyButton release];
    [_userFeekbackButton release];
    
    [_buttonsHolderView release];
    [_contentScrollView release];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] lineNavBgImage]];
    
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

- (IBAction)clickIntroductionButton:(id)sender {
    if (_introductionController == nil) {
        self.introductionController = [[[RouteIntroductionController alloc] initWithRoute:_route routeType:_routeType] autorelease];
    }
    
    [_introductionController showInView:self.contentScrollView];
}

- (IBAction)clickCostDecriptionButton:(id)sender {
}

- (IBAction)clickBookingPolicyButton:(id)sender {
}

- (IBAction)clickUserFeekbackButton:(id)sender {
}

- (void)findRequestDone:(int)result route:(TouristRoute *)route
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.route = route;
}



@end
