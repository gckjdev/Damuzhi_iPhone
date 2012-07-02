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


#define ALERT_TYPE_WITH_NEVER_REMIND_BUTTON 1
#define ALERT_TYPE_WITHOUT_NEVER_REMIND_BUTTON 2

@class PlaceMapViewController;
@class Place;

@protocol PlaceListControllerDelegate <NSObject>

@optional
- (void)deletedPlace:(Place *)place;
//- (void)didUpdateToLocation;
//- (void)didFailUpdateLocation;

@end

@protocol PullToRefrshDelegate <NSObject>
@optional
- (void)didPullDown;

@end

@interface PlaceListController : PPTableViewController <MKMapViewDelegate, CityOverviewServiceDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) id<PlaceListControllerDelegate> aDelegate;
@property (assign, nonatomic) id<PullToRefrshDelegate> pullDownDelegate;

@property (assign, nonatomic) int alertViewType;

- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController 
                  wantPullDownToRefresh:(BOOL)wantPullDownToRefresh
                       pullDownDelegate:(id<PullToRefrshDelegate>)pullDownDelegate;



- (void)showInView:(UIView*)superView;
- (void)setPlaceList:(NSArray*)placeList;

- (void)switchToMapMode;
- (void)switchToListMode;

- (void)canDeletePlace:(BOOL)isCan delegate:(id<PlaceListControllerDelegate>)delegate;

@end
