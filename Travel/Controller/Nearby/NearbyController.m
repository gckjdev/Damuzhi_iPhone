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
#import "CommonPlace.h"
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

//#define TEST_FOR_SIMULATE__LOCATION

#define POINT_OF_DISTANCE_500M  CGPointMake(28, 18)
#define POINT_OF_DISTANCE_1KM   CGPointMake(83, 18)
#define POINT_OF_DISTANCE_5KM   CGPointMake(164, 18)
#define POINT_OF_DISTANCE_10KM   CGPointMake(287, 18)

#define DISTANCE_500M 500
#define DISTANCE_1KM  1000
#define DISTANCE_5KM 5000
#define DISTANCE_10KM 10000

#define TAG_RED_START_IMAGE_VIEW 789

@interface NearbyController ()

@property (assign, nonatomic) int categoryId;
@property (assign, nonatomic) int distance;
@property (retain, nonatomic) NSArray *allPlaceList;
@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) PlaceListController* placeListController;

#ifdef TEST_FOR_SIMULATE__LOCATION
@property (retain, nonatomic) CLLocation *testLocation;
#endif

- (void)setSelectedBtn:(int)categoryId;
- (NSArray*)filterAndSortWithPlaceList:(NSArray *)placeList;

@end

@implementation NearbyController

@synthesize categoryId = _categoryId;
@synthesize distance = _distance;
@synthesize allPlaceList = _allPlaceList;
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
    PPRelease(_allPlaceList);
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"地图") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickMapBtn:)];
    
    UIButton *mapBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [mapBtn setTitle:@"列表" forState:UIControlStateSelected];
    
    UIImageView *imageRedStartView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_star.png"]] autorelease];
    imageRedStartView.tag = TAG_RED_START_IMAGE_VIEW;
    [imageRedStartView setCenter:POINT_OF_DISTANCE_1KM];
    [distanceView addSubview:imageRedStartView];
    
    [categoryBtnsHolderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"options_bg2.png"]]];    
    
    self.distance = DISTANCE_1KM;
    self.categoryId = PlaceCategoryTypePlaceAll;
    allPlaceButton.selected = YES;
    
    [self setSelectedBtn:_categoryId];
    
    self.placeListController = [[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController wantPullDownToRefresh:YES pullDownDelegate:self] autorelease];
    _placeListController.aDelegate = self;
    
    [_placeListController showInView:placeListHolderView];
    
    UIButton *button = [_placeListController valueForKey:@"locateButton"];
    [_placeListController performSelector:@selector(clickMyLocationBtn:) withObject:button];
    
    [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
    
    _placeListController.isNearby = YES;
    
#ifdef TEST_FOR_SIMULATE__LOCATION
    self.testLocation = [[[CLLocation alloc] initWithLatitude:0.0 longitude:0.0] autorelease];
    [self addDoubleTapToView:self.view];
#endif
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


- (NSArray*)filterAndSortWithPlaceList:(NSArray *)list
{
    if ([[AppService defaultService] currentLocation] == nil) {
        return nil;
    }
    
    NSMutableArray *placeList = [[[NSMutableArray alloc] init] autorelease];
    
    NSArray *array = [PlaceUtils getPlaceList:list ofCategory:_categoryId];
    for (Place *place in array) {
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
        
        CLLocationDistance distance = [[[AppService defaultService] currentLocation] distanceFromLocation:placeLocation];
        [placeLocation release];
                
        if (distance <= _distance) {
            [placeList addObject:place];
        }
    }

    return [PlaceUtils sortedByDistance:[[AppService defaultService] currentLocation] array:placeList type:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR];
}

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
        [UIImageView setAnimationDuration:1];
        [imageView setCenter:center];
        [UIImageView commitAnimations];        
    }else{
        [imageView setCenter:center];        
    }
}

- (IBAction)click500M:(id)sender {
    if (_distance != DISTANCE_500M) {
        self.distance = DISTANCE_500M;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_500M 
              needAnimation:YES];
        
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)click1K:(id)sender {
    if (_distance != DISTANCE_1KM) {
        self.distance = DISTANCE_1KM;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_1KM 
              needAnimation:YES];
        
        [self updateDataSorce];

    }   
}

- (IBAction)click5K:(id)sender {
    if (_distance != DISTANCE_5KM) {
        self.distance = DISTANCE_5KM;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW] 
                   toCenter:POINT_OF_DISTANCE_5KM 
              needAnimation:YES];
        
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }    
}

- (IBAction)click10K:(id)sender {
    if (_distance != DISTANCE_10KM) {
        self.distance = DISTANCE_10KM;
        
        [self moveImageView:[distanceView viewWithTag:TAG_RED_START_IMAGE_VIEW]
                   toCenter:POINT_OF_DISTANCE_10KM 
              needAnimation:YES];
        
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)clickSpotBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceSpot) {
        self.categoryId = PlaceCategoryTypePlaceSpot;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)clickHotelBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceHotel) {
        self.categoryId = PlaceCategoryTypePlaceHotel;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)clickAllBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceAll) {
        self.categoryId = PlaceCategoryTypePlaceAll;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];

    }
}

- (IBAction)clickRestaurantBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceRestraurant) {
        self.categoryId = PlaceCategoryTypePlaceRestraurant;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)clickShoppingBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceShopping) {
        self.categoryId = PlaceCategoryTypePlaceShopping;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
    }
}

- (IBAction)clickEntertainmentBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceEntertainment) {
        self.categoryId = PlaceCategoryTypePlaceEntertainment;
        [self setSelectedBtn:_categoryId];
//        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self updateDataSorce];
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

- (void)findRequestDone:(int)result placeList:(NSArray*)placeList
{    
    [_placeListController dataSourceDidFinishLoadingNewData];
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
    }
    
    self.allPlaceList = placeList;
//    self.placeList = [self filterByDistanceAndSort:_allPlaceList distance:_distance];
//    
//    // Update place count in navigation bar.
//    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
//    
//    // Reload place list.
//    [_placeListController setPlaceList:_placeList];
    [self updateDataSorce];
}

- (void)updateDataSorce
{
    self.placeList = [self filterAndSortWithPlaceList:_allPlaceList];
    
    // Update place count in navigation bar.
    self.title = [NSString stringWithFormat:NSLS(@"我的附近(%d)"), [_placeList count]];
    
    // Reload place list.
    [_placeListController setPlaceList:_placeList];
}

- (void)didPullDown
{
    [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
}

- (void)didUpdateToLocation
{
    [self updateDataSorce];
}

- (void)didFailUpdateLocation
{
    [self updateDataSorce];
}

@end
