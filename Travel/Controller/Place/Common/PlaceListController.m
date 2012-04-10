//
//  PlaceListController.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceListController.h"
#import "Place.pb.h"
#import "PlaceManager.h"
#import "CommonPlaceDetailController.h"
#import "PlaceMapViewController.h"
#import "LogUtil.h"
#import "PlaceCell.h"
#import "PlaceStorage.h"
#import "AppManager.h"

@interface PlaceListController () 

@property (assign, nonatomic) BOOL canDelete;

- (void)updateViewByMode;

@end

@implementation PlaceListController

@synthesize locationLabel = _locationLabel;
@synthesize mapHolderView = _mapHolderView;
@synthesize superController = _superController;
@synthesize mapViewController = _mapViewController;
@synthesize canDelete;
@synthesize deletePlaceDelegate;

- (void)dealloc
{
    [_mapViewController release];
    [_locationLabel release];
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

    // create & add map view
    self.mapHolderView.hidden = YES;
    self.mapViewController = [[[PlaceMapViewController alloc] init] autorelease];
    self.mapViewController.view.frame = self.mapHolderView.bounds;
    [self.mapHolderView addSubview:self.mapViewController.view];
    [self updateViewByMode];
    
    [self initLocationManager];
    [self startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // save to current location
    self.currentLocation = newLocation;
	
	// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:kTimeOutObjectString];
	
	// IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
	[self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
	
    [self.dataTableView reloadData];
}


- (void)canDeletePlace:(BOOL)isCan delegate:(id<DeletePlaceDelegate>)delegateValue
{
    self.canDelete = isCan;
    [self.dataTableView setEditing:isCan];
    self.deletePlaceDelegate = delegateValue;
    [self.dataTableView reloadData];
}

- (void)viewDidUnload
{
    [self setLocationLabel:nil];
    [self setMapHolderView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (PlaceListController*)createController:placeList
                               superView:(UIView*)superView
                         superController:(PPViewController*)superController
{
    PlaceListController* controller = [[[PlaceListController alloc] init] autorelease];
    controller.view.frame = superView.bounds;
    controller.superController = superController;
    controller.mapViewController.superController = superController;
    [superView addSubview:controller.view];
    return controller;
}

- (void)setAndReloadPlaceList:(NSArray*)list
{
    self.dataList = list;
    [self.dataTableView reloadData];
    [self.mapViewController setPlaces:list];
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
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
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
    
    UIImageView *view = [[UIImageView alloc] init];
    [view setImage:[UIImage imageNamed:@"li_bg.png"]];
    [placeCell setBackgroundView:view];
    [view release];
    [placeCell setCellDataByPlace:place currentLocation:self.currentLocation];
    
    if (canDelete) {
        placeCell.priceLable.hidden = YES;
        placeCell.favoritesView.hidden = YES;
        placeCell.areaLable.hidden= YES;
        placeCell.distanceLable.hidden = YES;
    }else {
        placeCell.priceLable.hidden = NO;
        placeCell.favoritesView.hidden = NO;
        placeCell.areaLable.hidden= NO;
        placeCell.distanceLable.hidden = NO;
    }
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[[dataList objectAtIndex:[indexPath row]]name]);
    
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlaceList:dataList selectedIndex:[indexPath row]];
    
    [self.superController.navigationController pushViewController:controller animated:YES];
    [controller release];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (deletePlaceDelegate && [deletePlaceDelegate respondsToSelector:@selector(deletedPlace:)]){
        [deletePlaceDelegate deletedPlace:[dataList objectAtIndex:[indexPath row]]];
    }
    
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
    [mutableDataList removeObjectAtIndex:indexPath.row];
    self.dataList = mutableDataList;
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (canDelete) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)updateViewByMode
{    
    if (_showMap){
        _mapHolderView.hidden = NO;
        dataTableView.hidden = YES;
    }
    else{
        _mapHolderView.hidden = YES;
        dataTableView.hidden = NO;
    }    
}

- (void)switchToMapMode
{
    _showMap = YES;
    [self updateViewByMode];
}

- (void)switchToListMode
{
    _showMap = NO;
    [self updateViewByMode];
}

@end
