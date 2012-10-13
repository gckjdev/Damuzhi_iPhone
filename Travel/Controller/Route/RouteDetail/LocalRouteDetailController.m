//
//  LocalRouteDetailController.m
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteDetailController.h"
#import "TouristRoute.pb.h"
#import "FontSize.h"
#import "CommonWebController.h"
#import "RouteFeekbackListController.h"
#import "LocalRouteOrderController.h"
#import "AppManager.h"
#import "DepartPlaceMapController.h"
#import "CommonPlaceDetailController.h"
#import "AnimationManager.h"

@interface LocalRouteDetailController ()

@property (assign, nonatomic) int routeId;
@property (retain, nonatomic) LocalRoute *route;
@property (retain, nonatomic) LocalRouteIntroductionController *introductionController;
@property (retain, nonatomic) CommonWebController *bookingPolicyController;
@property (retain, nonatomic) RouteFeekbackListController *feekbackListController;
@property (retain, nonatomic) UIButton *currentSelectedButton;
@property (retain, nonatomic) NSString *detailUrl;

@end

@implementation LocalRouteDetailController
@synthesize routeNameLabel = _routeNameLabel;
@synthesize routeIdLabel = _routeIdLabel;
@synthesize agencyNameLabel = _agencyNameLabel;
@synthesize contentHolderView = _contentHolderView;

@synthesize routeId = _routeId;
@synthesize route = _route;
@synthesize introductionController = _introductionController;
@synthesize bookingPolicyController = _bookingPolicyController;
@synthesize feekbackListController = _feekbackListController;
@synthesize introductionButton = _introductionButton;
@synthesize currentSelectedButton = _currentSelectedButton;
@synthesize detailUrl = _detailUrl;

- (void)dealloc
{
    [_routeNameLabel release];
    [_routeIdLabel release];
    [_agencyNameLabel release];
    [_contentHolderView release];
    [_route release];
    [_introductionController release];
    [_bookingPolicyController release];
    [_feekbackListController release];
    [_currentSelectedButton release];
    [_introductionButton release];
    [_detailUrl release];
    [super dealloc];
}

- (id)initWithLocalRouteId:(int)routeId
{
    self = [super init];
    if (self) {
        self.routeId = routeId;
    }
    return self;
}

- (id)initWithLocalRouteId:(int)routeId detailUrl:(NSString *)detailUrl
{
    self = [self initWithLocalRouteId:routeId];
    if (self) {
        self.detailUrl = detailUrl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"路线详情";
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    
    self.currentSelectedButton = self.introductionButton;
    self.introductionButton.selected = YES;
    self.introductionController = [[[LocalRouteIntroductionController alloc] init] autorelease];
    self.introductionController.delegate = self;
    [_introductionController showInView:self.contentHolderView];
    
    [[RouteService defaultService] findLocalRouteWithRouteId:_routeId viewController:self];
    
    if (_detailUrl) {
        [_introductionController loadDetailHtml:_detailUrl];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [self setAgencyNameLabel:nil];
    [self setContentHolderView:nil];
    [self setIntroductionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)clickConsult:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:NSLS(@"返回") destructiveButtonTitle:_route.contactPhone otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
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
    
    [self.contentHolderView bringSubviewToFront:_introductionController.view];
}


- (IBAction)clickBookingPolicyButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_bookingPolicyController == nil) {
        self.bookingPolicyController = [[[CommonWebController alloc] initWithWebUrl:_route.bookingNotice] autorelease];
        
        _bookingPolicyController.view.frame = CGRectMake(0, 0, self.contentHolderView.frame.size.width, self.contentHolderView.frame.size.height);
        [_bookingPolicyController showInView:self.contentHolderView];  
    }
    
    [self.contentHolderView bringSubviewToFront:_bookingPolicyController.view];
}


- (IBAction)clickUserFeekbackButton:(id)sender {
    UIButton *button  = (UIButton *)sender;
    [self updateSelectedButton:button];
    
    if (_feekbackListController == nil) {
        self.feekbackListController = [[[RouteFeekbackListController alloc] initWithRouteId:_routeId] autorelease];
        [_feekbackListController showInView:self.contentHolderView];   
    }
    
    [self.contentHolderView bringSubviewToFront:_feekbackListController.view];
}

- (DepartPlace *)findDepartPlace:(int)departPlaceId
{
    for (DepartPlace *departPlace in _route.departPlacesList) {
        if (departPlace.departPlaceId == departPlaceId) {
            return departPlace;
        }
    }
    
    return nil;
}

#pragma mark -
#pragma RouteServiceDelegate method
- (void)findRequestDone:(int)result localRoute:(LocalRoute *)route
{
    self.route = route;
    self.routeNameLabel.text = route.name;
    self.routeIdLabel.text = [NSString stringWithFormat:@"编号:%d",route.routeId];
    self.agencyNameLabel.text = [[AppManager defaultManager] getAgencyShortName:route.agencyId];
    [_introductionController updateWithRoute:route];
    
    if (_detailUrl == nil) {
        [_introductionController loadDetailHtml:route.detailUrl];
    }
}

#pragma mark - 
#pragma UIActionSheetDelegate method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    [UIUtils makeCall:_route.contactPhone];
}

#pragma mark - 
#pragma LocalRouteIntroductionControllerDelegage method
- (void)didClickBookingButton
{
    LocalRouteOrderController *controller = [[[LocalRouteOrderController alloc] initWithRoute:_route] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickDepartPlace:(int)departPlaceId
{
    DepartPlace *departPlace = [self findDepartPlace:departPlaceId];
    DepartPlaceMapController *controller = [[[DepartPlaceMapController alloc] initWithLatitude:departPlace.latitude 
                                                                                    longitude:departPlace.longitude 
                                                                                    placeName:departPlace.departPlace] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickRelatePlace:(int)RelatePlaceId
{
    [[PlaceService defaultService] findPlace:RelatePlaceId viewController:self];
}


#define TAG_FOLLOW_OK_VIEW  12091901
- (void)didClickFollow
{
    CGRect rect = CGRectMake(0, 0, 109, 52);
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.tag = TAG_FOLLOW_OK_VIEW;
    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"favorites_ok.png"]];
    [button setTitle:NSLS(@"关注成功") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(-8, 20, 0, 0)];
    CGPoint fromPosition = CGPointMake(320/2, 354);
    CGPoint toPosition = CGPointMake(320/2, 354);
    [self.view addSubview:button];
    [button release];
    
    [AnimationManager alertView:button fromPosition:fromPosition toPosition:toPosition interval:2 delegate:self];
    
    [[RouteService defaultService] followLocalRoute:_route viewController:self];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *view = [self.view viewWithTag:TAG_FOLLOW_OK_VIEW];
    [view removeFromSuperview];
}

- (void)findRequestDone:(int)resultCode
                 result:(int)result 
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place
{
    if (resultCode != 0) {
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

- (void)followRouteDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    
}

@end
