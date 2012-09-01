//
//  FavoriteController.m
//  Travel
//
//  Created by haodong qiu on 12年3月28日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "FavoriteController.h"
#import "PlaceListController.h"
#import "PlaceStorage.h"
#import "LogUtil.h"
#import "Place.pb.h"
#import "ImageName.h"
#import "PlaceService.h"
#import "TravelNetworkConstants.h"
#import "UIImageUtil.h"
#import "App.pb.h"
#import "PPNetworkRequest.h"
#import "FontSize.h"

@interface FavoriteController ()

@property (assign, nonatomic) BOOL canDelete;

@property (retain, nonatomic) NSArray *showMyList;
@property (retain, nonatomic) NSArray *showTopList;
@property (retain, nonatomic) PlaceListController *myFavPlaceListController;
@property (retain, nonatomic) PlaceListController *topFavPlaceListController;

@property (retain, nonatomic) NSArray *myAllFavoritePlaceList;
@property (retain, nonatomic) NSArray *topAllFavoritePlaceList;
@property (retain, nonatomic) NSArray *topSpotFavoritePlaceList;
@property (retain, nonatomic) NSArray *topHotelFavoritePlaceList;
@property (retain, nonatomic) NSArray *topRestaurantFavoritePlaceList;
@property (retain, nonatomic) NSArray *topShoppingFavoritePlaceList;
@property (retain, nonatomic) NSArray *topEntertainmentFavoritePlaceList;

@property (retain, nonatomic) UIButton *myFavoriteButton;
@property (retain, nonatomic) UIButton *topFavoriteButton;
@property (retain, nonatomic) UIButton *deleteButton;

- (void)createRightBarButton;
- (void)clickMyFavorite:(id)sender;
- (void)clickTopFavorite:(id)sender;
- (void)clickDelete:(id)sender;
- (NSArray*)filterFromMyFavorite:(int)categoryId;

@end

@implementation FavoriteController
@synthesize buttonHolderView;
@synthesize myFavPlaceListView;
@synthesize myFavPlaceListController;
@synthesize showMyList = _showMyList;
@synthesize topFavPlaceListView;
@synthesize topFavPlaceListController;
@synthesize showTopList = _showTopList;
@synthesize canDelete;
@synthesize myFavoriteButton;
@synthesize topFavoriteButton;
@synthesize deleteButton;
@synthesize myAllFavoritePlaceList;
@synthesize topAllFavoritePlaceList;
@synthesize topSpotFavoritePlaceList;
@synthesize topHotelFavoritePlaceList;
@synthesize topRestaurantFavoritePlaceList;
@synthesize topShoppingFavoritePlaceList;
@synthesize topEntertainmentFavoritePlaceList;

- (void)dealloc {
    PPRelease(buttonHolderView);
    PPRelease(myFavPlaceListView);
    PPRelease(myFavPlaceListController);
    PPRelease(_showMyList);
    PPRelease(topFavPlaceListView);
    PPRelease(topFavPlaceListController);
    PPRelease(_showTopList);
    PPRelease(myFavoriteButton);
    PPRelease(topFavoriteButton);
    PPRelease(deleteButton);
    PPRelease(myAllFavoritePlaceList);
    PPRelease(topAllFavoritePlaceList);
    PPRelease(topSpotFavoritePlaceList);
    PPRelease(topHotelFavoritePlaceList);
    PPRelease(topRestaurantFavoritePlaceList);
    PPRelease(topShoppingFavoritePlaceList);
    PPRelease(topEntertainmentFavoritePlaceList);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self createRightBarButton];
    
    [buttonHolderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"options_bg2.png"]]];

    self.myFavPlaceListController =[[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController supportPullDownToRefresh:NO supportPullUpToLoadMore:NO pullDelegate:nil] autorelease];
    [myFavPlaceListController showInView:myFavPlaceListView];    
    
    PlaceListController *topController =[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController supportPullDownToRefresh:NO supportPullUpToLoadMore:NO pullDelegate:nil];
    
    self.topFavPlaceListController = topController;
    [topController release];
    [topFavPlaceListController showInView:topFavPlaceListView];
    
    self.myAllFavoritePlaceList = [[PlaceStorage favoriteManager] allPlacesSortByLatest];
    if ([myAllFavoritePlaceList count] != 0) {
        [self clickMyFavorite:nil];
    }else {
        [self clickTopFavorite:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)showPlaces{
    if (self.myFavoriteButton.selected == YES) {
        self.myFavPlaceListView.hidden = NO;
        self.topFavPlaceListView.hidden = YES;
        
        [self.myFavPlaceListController setPlaceList:self.showMyList];
        if ([self.showMyList count] == 0 ) {
            [self.myFavPlaceListController hideTipsOnTableView];
            [self.myFavPlaceListController showTipsOnTableView:NSLS(@"暂无收藏信息")];
        }else {
            [self.myFavPlaceListController hideTipsOnTableView];
        }
    }
    else {
        self.myFavPlaceListView.hidden = YES;
        self.topFavPlaceListView.hidden = NO;
        [self.topFavPlaceListController setPlaceList:self.showTopList];
    }
}

- (void)viewDidUnload
{
    [self setButtonHolderView:nil];
    [self setMyFavPlaceListView:nil];
    [self setMyFavPlaceListController:nil];
    [self setTopFavPlaceListController:nil];
    [self setShowMyList:nil];
    [self setTopFavPlaceListView:nil];
    [self setTopFavPlaceListController:nil];
    [self setShowTopList:nil];
    [self setMyFavoriteButton:nil];
    [self setTopFavoriteButton:nil];
    [self setDeleteButton:nil];
    [self setMyAllFavoritePlaceList:nil];
    [self setTopAllFavoritePlaceList:nil];
    [self setTopSpotFavoritePlaceList:nil];
    [self setTopHotelFavoritePlaceList:nil];
    [self setTopRestaurantFavoritePlaceList:nil];
    [self setTopShoppingFavoritePlaceList:nil];
    [self setTopEntertainmentFavoritePlaceList:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

#define RIGHT_BUTTON_VIEW_WIDTH     230
#define RIGHT_BUTTON_VIEW_HIGHT     30
#define BUTTON_WIDTH                80
#define BUTTON_HIGHT                30
#define DELETE_IMAGE_WIDTH         22
#define DELETE_IMAGE_HIGHT         22
- (void)createRightBarButton
{
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHT_BUTTON_VIEW_WIDTH, RIGHT_BUTTON_VIEW_HIGHT)];
    
    UIButton *mfbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    self.myFavoriteButton = mfbtn;
    [mfbtn release];
    
    self.myFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.myFavoriteButton setTitle:NSLS(@"我的收藏") forState:UIControlStateNormal];
    [self.myFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [self.myFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateSelected];
    [self.myFavoriteButton addTarget:self action:@selector(clickMyFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.myFavoriteButton];
    
    UIButton *tfbtn = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_WIDTH, 0, BUTTON_WIDTH, BUTTON_HIGHT)];
    self.topFavoriteButton = tfbtn;
    [tfbtn release];
    self.topFavoriteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.topFavoriteButton setTitle:NSLS(@"收藏排行") forState:UIControlStateNormal];
    [self.topFavoriteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [self.topFavoriteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [self.topFavoriteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateSelected];
    [self.topFavoriteButton addTarget:self action:@selector(clickTopFavorite:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.topFavoriteButton];
    
    UIButton *dbtn = [[UIButton alloc] initWithFrame:CGRectMake(RIGHT_BUTTON_VIEW_WIDTH - 46, 0, 50, 34)];
    self.deleteButton = dbtn;
    [dbtn release];
    
    UIImageView *delImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete.png"]];
    delImageView.frame = CGRectMake(14, 4, DELETE_IMAGE_WIDTH, DELETE_IMAGE_HIGHT);
    [self.deleteButton addSubview:delImageView];
    [delImageView release];
    [self.deleteButton addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:self.deleteButton];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}

- (void)loadTopFavorite:(int)type
{
    [[PlaceService defaultService] findTopFavoritePlaces:self type:type];
}


#pragma mark - deletePlaceDelegate 
- (void)deletedPlace:(Place *)place
{
    [[PlaceService defaultService] deletePlaceFromFavorite:self place:place];
    [[PlaceStorage favoriteManager] deletePlace:place];
    self.myAllFavoritePlaceList = [[PlaceStorage favoriteManager] allPlacesSortByLatest];
    
    if ([self.myFavPlaceListController.dataList count] == 0) {
        [self.myFavPlaceListController hideTipsOnTableView];
        [self.myFavPlaceListController showTipsOnTableView:NSLS(@"暂无收藏信息")];
    }else {
        [self.myFavPlaceListController hideTipsOnTableView];
    }
}

#pragma mark - PlaceServiceDelegate 
- (void)finishDeleteFavourite:(NSNumber *)resultCode count:(NSNumber *)count
{
    
}

- (void)finishFindTopFavoritePlaces:(NSArray *)list type:(int)type result:(int)result
{    
    if (result != ERROR_SUCCESS ) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
    }
    
    switch (type) {
        case OBJECT_LIST_TOP_FAVORITE_ALL:
            self.topAllFavoritePlaceList = list;
            break;
            
        case OBJECT_LIST_TOP_FAVORITE_SPOT:
            self.topSpotFavoritePlaceList = list;
            break;
            
        case OBJECT_LIST_TOP_FAVORITE_HOTEL:
            self.topHotelFavoritePlaceList = list;
            break;
            
        case OBJECT_LIST_TOP_FAVORITE_RESTAURANT:
            self.topRestaurantFavoritePlaceList = list;
            break;
            
        case OBJECT_LIST_TOP_FAVORITE_SHOPPING:
            self.topShoppingFavoritePlaceList = list;
            break;
            
        case OBJECT_LIST_TOP_FAVORITE_ENTERTAINMENT:
            self.topEntertainmentFavoritePlaceList = list;
            break;
        
        default:
            break;
    }
    
    self.showTopList = list;
    [self showPlaces];
}

#pragma -mark BarButton action
- (void)clickDelete:(id)sender
{
    canDelete = !canDelete;
    [self.myFavPlaceListController canDeletePlace:canDelete delegate:self];
}

- (void)clickMyFavorite:(id)sender
{
    self.myAllFavoritePlaceList = [[PlaceStorage favoriteManager] allPlacesSortByLatest];
    
    myFavoriteButton.selected = YES;
    topFavoriteButton.selected = NO;
    deleteButton.hidden = NO;
    
    self.myFavPlaceListView.hidden = NO;
    self.topFavPlaceListView.hidden = YES;
    
    [self clickAll:nil];
}

- (void)clickTopFavorite:(id)sender
{
    myFavoriteButton.selected = NO;
    topFavoriteButton.selected = YES;
    deleteButton.hidden = YES;
    
    self.myFavPlaceListView.hidden = YES;
    self.topFavPlaceListView.hidden = NO;
    
    [self.myFavPlaceListController canDeletePlace:NO delegate:nil];
    [self clickAll:nil];
}

#pragma mark - filter button action
- (IBAction)clickAll:(id)sender
{
    [self setSelectedBtn:PlaceCategoryTypePlaceAll];

    if (self.myFavoriteButton.selected == YES) {
        self.showMyList = myAllFavoritePlaceList;
        [self showPlaces];
    }
    else {
        if (topAllFavoritePlaceList == nil) {
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_ALL];
        }
        else {
            self.showTopList = topAllFavoritePlaceList;
            [self showPlaces];
        }
    }
}

- (IBAction)clickSpot:(id)sender
{ 
    [self setSelectedBtn:PlaceCategoryTypePlaceSpot];

    if (myFavoriteButton.selected == YES) {
        self.showMyList = [self filterFromMyFavorite:PlaceCategoryTypePlaceSpot];
        [self showPlaces];
    }
    else {
        if(topSpotFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_SPOT];
        }else {
            self.showTopList = topSpotFavoritePlaceList;
            [self showPlaces];
        }
    }
}

- (IBAction)clickHotel:(id)sender
{
    [self setSelectedBtn:PlaceCategoryTypePlaceHotel];

    if (myFavoriteButton.selected == YES) {
        self.showMyList = [self filterFromMyFavorite:PlaceCategoryTypePlaceHotel];
        [self showPlaces];
    }
    
    else {
        if(topHotelFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_HOTEL];
        }else {
            self.showTopList = topHotelFavoritePlaceList;
            [self showPlaces];
        }
    }
}

- (IBAction)clickRestaurant:(id)sender
{    
    [self setSelectedBtn:PlaceCategoryTypePlaceRestraurant];

    if (myFavoriteButton.selected == YES) {
        self.showMyList = [self filterFromMyFavorite:PlaceCategoryTypePlaceRestraurant];
        [self showPlaces];
    }
    
    else {
        if(topRestaurantFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_RESTAURANT];
        }
        else {
            self.showTopList = topRestaurantFavoritePlaceList;
            [self showPlaces]; 
        }
    }
}

- (IBAction)clickShopping:(id)sender
{
    [self setSelectedBtn:PlaceCategoryTypePlaceShopping];

    if (myFavoriteButton.selected == YES) {
        self.showMyList = [self filterFromMyFavorite:PlaceCategoryTypePlaceShopping];
        [self showPlaces];
    }
    
    else {
        if(topShoppingFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_SHOPPING];
        }else {
            self.showTopList = topShoppingFavoritePlaceList;
            [self showPlaces];
        }
    }
}

- (IBAction)clickEntertainment:(id)sender
{
    [self setSelectedBtn:PlaceCategoryTypePlaceEntertainment];
    
    if (myFavoriteButton.selected == YES) {
        self.showMyList = [self filterFromMyFavorite:PlaceCategoryTypePlaceEntertainment];
        [self showPlaces];
    }
    
    else {
        if(topEntertainmentFavoritePlaceList == nil){
            [self loadTopFavorite:OBJECT_LIST_TOP_FAVORITE_ENTERTAINMENT];
        }
        else {
            self.showTopList = topEntertainmentFavoritePlaceList;
            [self showPlaces];
        }
    }
}

- (void)setSelectedBtn:(int)categoryId
{
    for (UIView *subView in [buttonHolderView subviews]) {
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

- (NSArray*)filterFromMyFavorite:(int)categoryId
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place in myAllFavoritePlaceList) {
        if (place.categoryId == categoryId){
            [array addObject:place];
        }
    }
    return array;
}


@end
