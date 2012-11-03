//
//  NearbyController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearbyController.h"
#import "PlaceListController.h"
#import "PlaceService.h"
#import "PPViewController.h"
#import "AppConstants.h"
#import "Place.pb.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "App.pb.h"
#import "PPNetworkRequest.h"
#import "AppService.h"
#import <CoreLocation/CoreLocation.h>
#import "UIUtils.h"
#import "PlaceUtils.h"
#import "AppUtils.h"
#import "FontSize.h"

//#define TEST_FOR_SIMULATE__LOCATION

#define POINT_OF_DISTANCE_250M  CGPointMake(28, 18)
#define POINT_OF_DISTANCE_500M   CGPointMake(66, 18)
#define POINT_OF_DISTANCE_1KM   CGPointMake(125, 18)
#define POINT_OF_DISTANCE_5KM   CGPointMake(287, 18)

#define DISTANCE_250M 0.250
#define DISTANCE_500M 0.500
#define DISTANCE_1KM  1.000
#define DISTANCE_5KM  5.000

#define TAG_RED_START_IMAGE_VIEW 789

#define ONCE_COUNT  20

typedef enum {
    TypeNearbyPlaceAll = 9999,
    TypeNearbyPlaceSpot = 1,
    TypeNearbyPlaceHotel = 2,
    TypeNearbyPlaceRestraurant = 3,
    TypeNearbyPlaceShopping = 4,
    TypeNearbyPlaceEntertainment = 5,
}TypeNearbyPlace;

@interface NearbyController ()

@property (assign, nonatomic) TypeNearbyPlace typeNearbyPlace;
@property (assign, nonatomic) double distance;
@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) PlaceListController* placeListController;

@property (assign, nonatomic) int start;
@property (assign, nonatomic) int totalCount;

#ifdef TEST_FOR_SIMULATE__LOCATION
@property (retain, nonatomic) CLLocation *testLocation;
#endif

- (void)setSelectedBtn:(int)categoryId;
//- (NSArray*)filterAndSortWithPlaceList:(NSArray *)placeList;

@end

@implementation NearbyController

@synthesize typeNearbyPlace = _typeNearbyPlace;
@synthesize distance = _distance;
@synthesize placeList = _placeList;
@synthesize placeListController = _placeListController;

@synthesize distanceView;
@synthesize categoryBtnsHolderView;
@synthesize allPlaceButton;
@synthesize spotButton;
@synthesize hotelButton;
@synthesize shoppingButton;
@synthesize entertainmentButton;
@synthesize restaurantButton;
@synthesize placeListHolderView;

#ifdef TEST_FOR_SIMULATE__LOCATION
@synthesize testLocation;
#endif

#pragma mark - View lifecycle

- (void)dealloc
{
    PPRelease(_placeList);
    PPRelease(_placeListController);
    
    [distanceView release];
    [categoryBtnsHolderView release];
    [allPlaceButton release];
    [spotButton release];
    [hotelButton release];
    [shoppingButton release];
    [entertainmentButton release];
    [restaurantButton release];
    [placeListHolderView release];

#ifdef TEST_FOR_SIMULATE__LOCATION
    PPRelease(testLocation);
#endif
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"地图") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickMapBtn:)];
    
    UIButton *mapBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [mapBtn setTitle:@"列表" forState:UIControlStateSelected];
    
    UIImageView *imageRedStartView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_star.png"]] autorelease];
    imageRedStartView.tag = TAG_RED_START_IMAGE_VIEW;
    [imageRedStartView setCenter:POINT_OF_DISTANCE_500M];
    [distanceView addSubview:imageRedStartView];
    
    [categoryBtnsHolderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"options_bg2.png"]]];    
    
    self.distance = DISTANCE_500M;
    self.typeNearbyPlace = TypeNearbyPlaceAll;
    allPlaceButton.selected = YES;
    
    [self setSelectedBtn:_typeNearbyPlace];
    
    self.placeListController = [[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController supportPullDownToRefresh:YES supportPullUpToLoadMore:YES pullDelegate:self] autorelease];
    _placeListController.aDelegate = self;
    [_placeListController showInView:placeListHolderView];
    [self showActivityWithText:NSLS(@"正在获取地理位置...")];
    
    UIButton *button = [_placeListController valueForKey:@"locateButton"];
    [_placeListController performSelector:@selector(clickMyLocationBtn:) withObject:button];
    
    //[[PlaceService defaultService] findPlaces:_categoryId viewController:self];
    
    _placeListController.isNearby = YES;
    
    
#ifdef TEST_FOR_SIMULATE__LOCATION
    self.testLocation = [[[CLLocation alloc] initWithLatitude:0.0 longitude:0.0] autorelease];
    [self addDoubleTapToView:self.view];
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self setDistanceView:nil];
    [self setCategoryBtnsHolderView:nil];
    [self setAllPlaceButton:nil];
    [self setSpotButton:nil];
    [self setHotelButton:nil];
    [self setRestaurantButton:nil];
    [self setShoppingButton:nil];
    [self setEntertainmentButton:nil];
    [self setPlaceListHolderView:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#ifdef TEST_FOR_SIMULATE__LOCATION
UITextField * alertTextField;

- (void)addDoubleTapToView:(UIView*)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"输入经纬度数值" message:@"格式:113.905029 22.254087 " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
////        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        alertTextField = [alert textFieldAtIndex:0];
//        alertTextField.keyboardType = UIKeyboardTypeDefault;
//        alertTextField.placeholder = @"";
//        [alert show];
//        [alert release];  
        
        UIAlertView* textAlertView = [UIUtils showTextView:@"输入经纬度数值" okButtonTitle:@"确定" cancelButtonTitle:@"取消" delegate:self];
        alertTextField = (UITextField*)[textAlertView viewWithTag:kAlertTextViewTag];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            NSMutableString *text = [[NSMutableString alloc] initWithString:[alertTextField text]];
            NSArray *array = [text componentsSeparatedByString:@" "];
            [text release];
            if ([array count] <2) {
                UIAlertView* textAlertView = [UIUtils showTextView:@"输入错误,请重新输入经纬度" okButtonTitle:@"确定" cancelButtonTitle:@"取消" delegate:self];
                alertTextField = (UITextField*)[textAlertView viewWithTag:kAlertTextViewTag];
                return;
            }
            
            NSString *logtitude= [array objectAtIndex:0];
            NSString *latitude = [array objectAtIndex:1];
            double log = [logtitude doubleValue];
            double lat = [latitude doubleValue];
            self.testLocation = [[[CLLocation alloc] initWithLatitude:lat longitude:log] autorelease];
            [[AppService defaultService] setCurrentLocation:testLocation];
//            [[PlaceService defaultService] findPlaces:_categoryId viewController:self];    
            [self findPlaces];
        }
            break;  
        default:
            break;
    }

    
}

#endif


//- (NSArray*)filterAndSortWithPlaceList:(NSArray *)list
//{
//    if ([[AppService defaultService] currentLocation] == nil) {
//        return nil;
//    }
//    
//    NSMutableArray *placeList = [[[NSMutableArray alloc] init] autorelease];
//    
//    NSArray *array = [PlaceUtils getPlaceList:list ofCategory:_categoryId];
//    for (Place *place in array) {
//        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
//        
//        CLLocationDistance distance = [[[AppService defaultService] currentLocation] distanceFromLocation:placeLocation];
//        [placeLocation release];
//                
//        if (distance <= _distance) {
//            [placeList addObject:place];
//        }
//    }
//
//    return [PlaceUtils sortedByDistance:[[AppService defaultService] currentLocation] array:placeList type:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR];
//}

- (void )clickMapBtn:(id)sender
{
    UIButton *mapBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    mapBtn.selected = !mapBtn.selected;
    
    UIViewAnimationTransition animationTransition = (mapBtn.selected ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight);
    
    [self showSwitchAnimation:animationTransition];
    
    if (mapBtn.selected){
        [self.placeListController switchToMapMode];
    }
    else{
        [self.placeListController switchToListMode];
    }
}

- (void)showSwitchAnimation:(UIViewAnimationTransition)animationTransition
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:animationTransition
						   forView:self.view cache:YES];
    
    [UIView commitAnimations];
}

- (void)moveImageView:(UIView *)imageView toCenter:(CGPoint)center needAnimation:(BOOL)need
{
    if (need) {
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDuration:0.6];
        [imageView setCenter:center];
        [UIImageView commitAnimations];        
    }else{
        [imageView setCenter:center];        
    }
}


- (IBAction)click250M:(id)sender{
    if (_distance != DISTANCE_250M) {
        self.distance = DISTANCE_250M;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_250M
              needAnimation:YES];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}


- (IBAction)click500M:(id)sender {
    if (_distance != DISTANCE_500M) {
        self.distance = DISTANCE_500M;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_500M 
              needAnimation:YES];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)click1K:(id)sender {
    if (_distance != DISTANCE_1KM) {
        self.distance = DISTANCE_1KM;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_1KM 
              needAnimation:YES];
        
        _start = 0;
        [self findNearbyPlaces];
    }   
}

- (IBAction)click5K:(id)sender {
    if (_distance != DISTANCE_5KM) {
        self.distance = DISTANCE_5KM;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW] 
                   toCenter:POINT_OF_DISTANCE_5KM 
              needAnimation:YES];
        
        _start = 0;
        [self findNearbyPlaces];;
    }    
}

- (IBAction)clickSpotBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceSpot) {
        self.typeNearbyPlace = TypeNearbyPlaceSpot;
        [self setSelectedBtn:_typeNearbyPlace];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)clickHotelBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceHotel) {
        self.typeNearbyPlace = TypeNearbyPlaceHotel;
        [self setSelectedBtn:_typeNearbyPlace];

        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)clickAllBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceAll) {
        self.typeNearbyPlace = TypeNearbyPlaceAll;
        [self setSelectedBtn:_typeNearbyPlace];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)clickRestaurantBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceRestraurant) {
        self.typeNearbyPlace = TypeNearbyPlaceRestraurant;
        [self setSelectedBtn:_typeNearbyPlace];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)clickShoppingBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceShopping) {
        self.typeNearbyPlace = TypeNearbyPlaceShopping;
        [self setSelectedBtn:_typeNearbyPlace];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (IBAction)clickEntertainmentBtn:(id)sender {
    if (_typeNearbyPlace != TypeNearbyPlaceEntertainment) {
        self.typeNearbyPlace = TypeNearbyPlaceEntertainment;
        [self setSelectedBtn:_typeNearbyPlace];
        
        _start = 0;
        [self findNearbyPlaces];
    }
}

- (void)setSelectedBtn:(int)categoryId
{
    for (UIView *subView in [categoryBtnsHolderView subviews]) {
        if (![subView isKindOfClass:[UIButton class]]) {
            return;
        }
        
        UIButton *button = (UIButton*)subView;
        if (button.tag == categoryId) {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
}

//- (void)findRequestDone:(int)result placeList:(NSArray*)placeList
//{    
//    [_placeListController dataSourceDidFinishLoadingNewData];
//    
//    if (result != ERROR_SUCCESS) {
//        [self popupMessage:@"网络弱，数据加载失败" title:nil];
//    }
//    
//    self.allPlaceList = placeList;
////    self.placeList = [self filterByDistanceAndSort:_allPlaceList distance:_distance];
////    
////    // Update place count in navigation bar.
////    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
////    
////    // Reload place list.
////    [_placeListController setPlaceList:_placeList];
//    [self updateDataSorce];
//}
//
//- (void)updateDataSorce
//{
//    //self.placeList = [self filterAndSortWithPlaceList:_allPlaceList];
//    
//    // Update place count in navigation bar.
//    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
//    
//    // Reload place list.
//    [_placeListController setPlaceList:_placeList];
//}

- (void)didPullDownToRefresh
{
    _start = 0;
    [self findNearbyPlaces];
}

- (void)didPullUpToLoadMore
{
    [self findNearbyPlaces];
}

- (void)didUpdateToLocation
{
    [self hideActivity];
    _start = 0;
    [self findNearbyPlaces];
}

- (void)didFailUpdateLocation
{
    [self hideActivity];
    [self popupMessage:NSLS(@"未能获取当前地理位置！") title:nil];
}

- (void)findNearbyPlaces
{
    [self showActivityWithText:NSLS(@"数据加载中......")];
    
    CLLocation *userCurrentLocation =  [[AppService defaultService] currentLocation];
    
    [[PlaceService defaultService] findNearbyPlaces:_typeNearbyPlace
                                           Latitude:userCurrentLocation.coordinate.latitude
                                          longitude:userCurrentLocation.coordinate.longitude
                                           distance:_distance
                                              start:_start
                                              count:ONCE_COUNT
                                           delegate:self];
    
//    [[PlaceService defaultService] findNearbyPlaces:_typeNearbyPlace
//                                           Latitude:23.128571
//                                          longitude:113.273958
//                                           distance:_distance
//                                              start:_start
//                                              count:ONCE_COUNT
//                                           delegate:self];
}

- (void)findRequestDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo totalCount:(int)totalCount placeList:(NSArray *)placeList
{
    [self hideActivity];
 
    PPDebug(@"findRequestDone result:%d totalCount:%d listCount:%d", result, totalCount, [placeList count]);
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
    }
    
    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), totalCount];
    
    if (_start == 0) {
        _placeListController.noMoreData = NO;
        
        self.placeList = nil;
        self.placeList = placeList;
    } else {
        NSMutableArray *newPlaceList = [NSMutableArray arrayWithArray:self.placeList];
        [newPlaceList addObjectsFromArray:placeList];
        self.placeList = newPlaceList;
    }
    
    _start += [placeList count];
    _totalCount = totalCount;
    
    if (_start >= totalCount || [placeList count] == 0) {
        _placeListController.noMoreData = YES;
    } else {
        _placeListController.noMoreData = NO;
    }
    
    [_placeListController setPlaceList:self.placeList];
    
    [_placeListController dataSourceDidFinishLoadingNewData];
    [_placeListController dataSourceDidFinishLoadingMoreData];
}

@end
