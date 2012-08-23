//
//  PlaceListController.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "CityOverviewService.h"
#import "PlaceService.h"

@class PlaceMapViewController;
@class Place;

@protocol PlaceListControllerDelegate <NSObject>

@optional
- (void)deletedPlace:(Place *)place;
- (void)didUpdateToLocation;
- (void)didFailUpdateLocation;

@end

@protocol PullDelegate <NSObject>
@optional
- (void)didPullDownToRefresh;
- (void)didPullUpToLoadMore;

@end

@interface PlaceListController : PPTableViewController <MKMapViewDelegate, CityOverviewServiceDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) id<PlaceListControllerDelegate> aDelegate;
@property (assign, nonatomic) id<PullDelegate> pullDelegate;

@property (assign, nonatomic) int alertViewType;
@property (assign, nonatomic) int isNearby;


- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController 
               supportPullDownToRefresh:(BOOL)supportPullDownToRefresh
                supportPullUpToLoadMore:(BOOL)supportPullUpToLoadMore
                           pullDelegate:(id<PullDelegate>)pullDelegate;



- (void)showInView:(UIView*)superView;
- (void)setPlaceList:(NSArray*)placeList;

- (void)switchToMapMode;
- (void)switchToListMode;

- (void)canDeletePlace:(BOOL)isCan delegate:(id<PlaceListControllerDelegate>)delegate;

@end
