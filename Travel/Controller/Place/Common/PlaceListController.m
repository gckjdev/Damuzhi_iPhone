//
//  PlaceListController.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceListController.h"
#import "Place.pb.h"
#import "CommonPlaceDetailController.h"
#import "PlaceMapViewController.h"
#import "LogUtil.h"
#import "PlaceCell.h"
#import "PlaceStorage.h"
#import "AppManager.h"
#import "UIImageUtil.h"
#import "AppService.h"
#import "MapUtils.h"
#import "PPApplication.h"
#import "Reachability.h"
#import "AppUtils.h"
#import "ImageManager.h"
#import "PlaceMapAnnotation.h"
#import "UIViewUtils.h"

#define TAG_USER_LOCATE_DENY_ALERT_VIEW 111


@interface PlaceListController () 
{
    BOOL _showMap;
    BOOL _firstIn;
    MKCoordinateSpan _span;
}

@property (assign, nonatomic) BOOL canDelete;
@property (retain, nonatomic) UINavigationController *superNavigationController;
@property (retain, nonatomic) UIButton *locateButton;
@property (retain, nonatomic) UIImageView *bottomImageview;

@end

@implementation PlaceListController

@synthesize superNavigationController = _superNavigationController;
@synthesize canDelete = _canDelete;
@synthesize mapView = _mapView;
@synthesize aDelegate = _aDelegate;
@synthesize pullDelegate = _pullDelegate;
@synthesize locateButton = _locateButton;
@synthesize alertViewType = _alertViewType;
@synthesize isNearby = _isNearby;
@synthesize bottomImageview = _bottomImageview;

- (void)dealloc
{
    [GlobalGetImageCache() cancelLoadingObjects];
    [_superNavigationController release];
    [_mapView release];
    [_locateButton release];
    [_bottomImageview release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;   
    
    _span = MKCoordinateSpanMake(0.028, 0.028);
    [MapUtils setMapSpan:_mapView span:_span];
    
    [self addMyLocationBtnTo:_mapView];
    
    
    if (!self.supportRefreshFooter && !self.supportRefreshHeader) {
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)] autorelease];
        [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
        [self.dataTableView addSubview:imageView];
    }
    
    [self switchToListMode];
    self.dataTableView.backgroundColor = [UIColor colorWithRed:220/255.0 green:224/255.0 blue:227/255.0 alpha:1.0];
}

#pragma mark For Sub Class to override and implement
- (void) reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource"); 
    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(didPullDownToRefresh)]) {
        [_pullDelegate didPullDownToRefresh];
    }
}

- (void)canDeletePlace:(BOOL)isCan delegate:(id<PlaceListControllerDelegate>)delegate
{
    self.canDelete = isCan;
    [self.dataTableView setEditing:isCan animated:YES];
    self.aDelegate = delegate;
    [self.dataTableView reloadData];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController 
               supportPullDownToRefresh:(BOOL)supportPullDownToRefresh
                supportPullUpToLoadMore:(BOOL)supportPullUpToLoadMore
                           pullDelegate:(id<PullDelegate>)pullDelegate
{
    self = [super init];
    if (self) {
        self.superNavigationController = superNavigationController;
        self.supportRefreshHeader = supportPullDownToRefresh;
        self.supportRefreshFooter = supportPullUpToLoadMore;
        self.footerRefreshType = AutoAndAddMore;
        self.footerLoadMoreTitle = NSLS(@"更多...");
        self.footerLoadMoreLoadingTitle = NSLS(@"加载中...");
        self.pullDelegate = pullDelegate;
        _firstIn = YES;
    }
    
    return self;
}

- (void)showInView:(UIView*)superView 
{   
    [superView removeAllSubviews];

    [self.view setFrame:superView.bounds];
    [superView addSubview:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_showMap && _locateButton.selected) {
        _mapView.showsUserLocation = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    _mapView.showsUserLocation = NO;
    [super viewDidDisappear:animated];
}


#define TAG_BOTTOM 12101301
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (self.noMoreData && scrollPosition < 0) {
        if ([self.dataTableView viewWithTag:TAG_BOTTOM] == nil) {
            
            if (self.bottomImageview == nil) {
                self.bottomImageview = [[[UIImageView alloc] init] autorelease];
                _bottomImageview.tag = TAG_BOTTOM;
                [_bottomImageview setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
            }
            CGFloat cHeight = dataTableView.contentSize.height;
            CGFloat fHeight = dataTableView.frame.size.height;
            CGFloat y = (cHeight > fHeight ? cHeight : fHeight);
            _bottomImageview.frame = CGRectMake(0, y, 320, 250);
            [dataTableView addSubview:_bottomImageview];
        }
    } else {
        [_bottomImageview removeFromSuperview];
    }
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return [PlaceCell getCellHeight];
}

- (Class)getClassByPlace:(Place*)place
{    
    return [PlaceCell class];
}

- (NSString*)getCellIdentifierByClass:(Class)class
{
    return [class getCellIdentifier];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}

    Place* place = [dataList objectAtIndex:row];
    Class placeClass = [self getClassByPlace:place];

    NSString *CellIdentifier = [self getCellIdentifierByClass:placeClass];
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) { 
		cell = [placeClass createCell:self];
	}
	
    PlaceCell *placeCell = (PlaceCell*)cell;
    
    [placeCell setCellDataByPlace:place currentLocation:[[AppService defaultService] currentLocation]];
    
    placeCell.frame = CGRectMake(100, 0, placeCell.frame.size.width, placeCell.frame.size.height);
    placeCell.contentView.frame = CGRectMake(100, 0, placeCell.contentView.frame.size.width, placeCell.contentView.frame.size.height);
    
    if (_canDelete) {
        placeCell.priceLable.hidden = YES;
        placeCell.favoritesView.hidden = YES;
        placeCell.areaLable.hidden= YES;
        placeCell.distanceLable.hidden = YES;
        placeCell.summaryView.frame = (CGRect){CGPointMake(10, 0), placeCell.summaryView.frame.size};
    }else {
        placeCell.priceLable.hidden = NO;
        placeCell.favoritesView.hidden = NO;
        placeCell.areaLable.hidden= NO;
        placeCell.distanceLable.hidden = NO;
        placeCell.summaryView.frame = (CGRect){CGPointMake(0, 0), placeCell.summaryView.frame.size};
    }

	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[dataList objectAtIndex:indexPath.row]];
    
    [_superNavigationController pushViewController:controller animated:YES];

    [controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *delPlace = (Place *)[dataList objectAtIndex:indexPath.row];
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
    [mutableDataList removeObjectAtIndex:indexPath.row];
    self.dataList = mutableDataList;
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if ([_aDelegate respondsToSelector:@selector(deletedPlace:)]){
        [_aDelegate deletedPlace:delPlace];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)switchToMapMode
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [AppUtils showAlertViewWhenLookingMapWithoutNetwork];
    }
    
    _showMap = YES;
    dataTableView.hidden = YES;
    _mapView.hidden = NO;
    
    _mapView.showsUserLocation = _locateButton.selected;
    [self reloadMap];
}

- (void)switchToListMode
{
    _showMap = NO;
    _mapView.showsUserLocation = _firstIn;
    
    dataTableView.hidden = NO;
    _mapView.hidden = YES;
    
    [self reloadTableView];
}

- (void)setPlaceList:(NSArray*)placeList
{
    if (placeList == self.dataList) {
        return;
    }
    
    self.dataList = placeList;
    
    if (_showMap) {
        [self reloadMap];
    }else {
        [self reloadTableView];
    }
    
    if (!self.supportRefreshFooter && !self.supportRefreshHeader) {
        CGFloat height = [placeList count] * [PlaceCell getCellHeight];
        CGFloat originY = height < self.dataTableView.frame.size.height ? self.dataTableView.frame.size.height : height;
        
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, originY, 320, 250)] autorelease];
        [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
        [self.dataTableView addSubview:imageView];
    }
    
    
    
//    [self addBottomImage];
}

//- (void)addBottomImage
//{
//    CGFloat offset = [PlaceCell getCellHeight] * [dataList count] < self.dataTableView.frame.size.height ? self.dataTableView.frame.size.height : [PlaceCell getCellHeight] * [dataList count];
//}

- (void)reloadMap
{   
    if (_locateButton.selected) {
        _mapView.showsUserLocation = NO;
        _mapView.showsUserLocation = YES;
    }
    [self loadAllAnnotations];
    [self gotoLocation];
}

- (void)gotoLocation
{
    if (_locateButton.selected) {
        CLLocation *location = [[AppService defaultService] currentLocation];
        [MapUtils gotoLocation:_mapView latitude:location.coordinate.latitude longitude:location.coordinate.longitude span:_span];
    }else {
        if ([dataList count] > 0) {
            Place *place = [dataList objectAtIndex:0];
            [MapUtils gotoLocation:_mapView latitude:place.latitude longitude:place.longitude span:_span];
        }
    }
}

- (void)reloadTableView
{
    [self.dataTableView reloadData];
    
    if ([self.dataList count] == 0) {
        [self showTipsOnTableView:NSLS(@"未找到相关信息")];
    }else {
        [self hideTipsOnTableView];
    }
    
}

- (void)addMyLocationBtnTo:(UIView*)view
{
    self.locateButton = [[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-35, 342, 31, 31)] autorelease];            
    
    [_locateButton setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [_locateButton setImage:[UIImage imageNamed:@"locate_jt.png"] forState:UIControlStateSelected];
    
    [_locateButton addTarget:self action:@selector(clickMyLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_locateButton];
}

- (void)clickMyLocationBtn:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        _mapView.showsUserLocation = YES;       
    }else {
        _mapView.showsUserLocation = NO;
        Place *place = [dataList objectAtIndex:0];
        [MapUtils gotoLocation:_mapView latitude:place.latitude longitude:place.longitude span:_span];
    }
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.028, 0.028);
    [MapUtils setMapSpan:_mapView span:span];
}

#define TOLERANCE 0.000001

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    PPDebug(@"current location: %f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    CLLocation *currentLocation1 = [[AppService defaultService] currentLocation];
    
    PPDebug(@"my location: %f, %f", currentLocation1.coordinate.latitude, currentLocation1.coordinate.longitude);
    
    float distance  = [userLocation.location distanceFromLocation:currentLocation1];
    
    PPDebug(@"distance = %f", distance);
    
    if (_firstIn && (userLocation.location.coordinate.latitude - 0.000000) < TOLERANCE && (userLocation.location.coordinate.longitude - 0.000000) < TOLERANCE) {
        return;
    }
    
    if (_isNearby && !_firstIn && distance < 100.0) {
        return;
    }
    
    [[AppService defaultService] setCurrentLocation:userLocation.location];
    
    if (_showMap) {
        [MapUtils gotoLocation:mapView latitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude span:_span];
    }else {
        [self reloadTableView];
    }
    
    if ([_aDelegate respondsToSelector:@selector(didUpdateToLocation)]) {
        [_aDelegate didUpdateToLocation];
    }

    if (_firstIn) {
        _firstIn = NO;
        _mapView.showsUserLocation = NO;
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [[AppService defaultService] setCurrentLocation:nil];
    [self reloadTableView];
    
    PPDebug(@"error domain: %@", error.domain);
//    PPDebug(@"error code: %@", error.code);
    
    if (error.domain != kCLErrorDomain) {
        return;
    }
    
    if (error.code == kCLErrorDenied) {
        if (!_isNearby) {
            [AppUtils showAlertViewWhenUserDenyLocatedServiceWithTag:TAG_USER_LOCATE_DENY_ALERT_VIEW delegate:self];

        }else {
            [AppUtils showAlertViewWhenUserDenyLocatedService];
        }
    }else {
        [AppUtils showAlertViewWhenCannotLocateUserLocation];
    }
    
    if ([_aDelegate respondsToSelector:@selector(didFailUpdateLocation)]) {
        [_aDelegate didFailUpdateLocation];
    }
    
    _mapView.showsUserLocation = NO;
    
    if (_firstIn) {
        _firstIn = NO;
    }
}

- (void)loadAllAnnotations
{    
    NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
    if ([dataList count] > 0) {
        for (Place *place in dataList) {
            if ([MapUtils isValidLatitude:[place latitude] Longitude:[place longitude]]) {
                PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc]initWithPlace:place];
                [mapAnnotations addObject:placeAnnotation];
                [placeAnnotation release];
            }
        } 
    }
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:mapAnnotations];
    [mapAnnotations release];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our custom annotations
    if([annotation isKindOfClass:[PlaceMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* annotationIdentifier = @"mapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
            
            NSInteger tag = [dataList indexOfObject:placeAnnotation.place];
            NSString *fileName = [AppUtils getCategoryPinIcon:placeAnnotation.place.categoryId];
            [MapUtils showCallout:annotationView imageName:fileName tag:tag target:self];
            
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
            
        }
        return pinView;
        
    }
    
    return nil;
}

//The event handling method
- (void)notationAction:(id)sender
{        
    UIButton *button = sender;
    NSInteger index = button.tag;
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc]initWithPlace:[dataList objectAtIndex:index]];
    [_superNavigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark: implementation of alert view delegate.

- (void)alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView1.tag) {
        case TAG_USER_LOCATE_DENY_ALERT_VIEW:
            if (buttonIndex == 1) {
                [AppUtils enableShowUserLocateDenyAlert:NO];
            }
            break;
            
        default:
            break;
    }
}

- (void)loadMoreTableViewDataSource
{
    if ([_pullDelegate respondsToSelector:@selector(didPullUpToLoadMore)]) {
        [_pullDelegate didPullUpToLoadMore];
    }
}


@end
