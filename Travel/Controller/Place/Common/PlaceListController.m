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

@interface PlaceListController () 
{
    BOOL _showMap;
}

@property (assign, nonatomic) BOOL canDelete;

@property (retain, nonatomic) PlaceMapViewController *mapViewController;
@property (assign, nonatomic) UINavigationController *superNavigationController;

- (void)reloadDataTableView;

@end

@implementation PlaceListController

@synthesize mapHolderView = _mapHolderView;
@synthesize superNavigationController = _superNavigationController;
@synthesize mapViewController = _mapViewController;
@synthesize canDelete = _canDelete;
@synthesize deletePlaceDelegate = _deletePlaceDelegate;
@synthesize pullDownDelegate = _pullDownDelegate;

- (void)dealloc
{
    [GlobalGetImageCache() cancelLoadingObjects];
    PPRelease(_mapViewController);
    [_mapHolderView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showMap = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapViewController = [[[PlaceMapViewController alloc] initWithSuperNavigationController:_superNavigationController] autorelease];
    [_mapViewController showInView:_mapHolderView];

    [self switchToListMode];
}

#pragma mark For Sub Class to override and implement
- (void) reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource"); 
    if (_pullDownDelegate && [_pullDownDelegate respondsToSelector:@selector(didPullDown)]) {
        [_pullDownDelegate didPullDown];
    }
}

- (void)canDeletePlace:(BOOL)isCan delegate:(id<DeletePlaceDelegate>)deleteDelegate
{
    self.canDelete = isCan;
    [self.dataTableView setEditing:isCan animated:YES];
    self.deletePlaceDelegate = deleteDelegate;
    [self.dataTableView reloadData];
}

- (void)viewDidUnload
{
    [self setMapHolderView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController 
                  wantPullDownToRefresh:(BOOL)wantPullDownToRefresh 
                       pullDownDelegate:(id<PullToRefrshDelegate>)pullDownDelegate
{
    self = [super init];
    if (self) {
        self.superNavigationController = superNavigationController;
        self.supportRefreshHeader = wantPullDownToRefresh;
        self.pullDownDelegate = pullDownDelegate;
    }
    
    return self;
}

- (void)showInView:(UIView*)superView 
{    
    [self.view setFrame:superView.bounds];
    [superView addSubview:self.view];
}

- (void)setPlaceList:(NSArray*)placeList
{
    if (placeList == self.dataList) {
        return;
    }
    
    self.dataList = placeList;
    [self reloadDataTableView];

    if (_showMap) {
        [_mapViewController setPlaces:self.dataList];
    }else {
//        [self reloadDataTableView];
    }
}

#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 76;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
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

        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[UIImage strectchableImageName:@"li_bg.png"]];
        [cell setBackgroundView:view];
        [view release];
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
    
    if (_deletePlaceDelegate && [_deletePlaceDelegate respondsToSelector:@selector(deletedPlace:)]){
        [_deletePlaceDelegate deletedPlace:delPlace];
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
    _mapHolderView.hidden = NO;
    
//    [_mapViewController showUserLocation:YES];
    [_mapViewController setPlaces:self.dataList];
}

- (void)switchToListMode
{
    _showMap = NO;
    
    dataTableView.hidden = NO;
    _mapHolderView.hidden = YES;
    
    [_mapViewController showUserLocation:NO];
    [self reloadDataTableView];
}

- (void)reloadDataTableView
{
    [self.dataTableView reloadData];
    
    if ([self.dataList count] == 0) {
        [self showTipsOnTableView:NSLS(@"未找到相关信息")];
    }else {
        [self hideTipsOnTableView];
    }
}

- (void)hideRefreshHeaderViewAfterLoading
{
    if (self.superNavigationController) {
        // after finish loading data, please call the following codes
//        [refreshHeaderView setCurrentDate];  	
        [self dataSourceDidFinishLoadingNewData];
    }
}

@end
