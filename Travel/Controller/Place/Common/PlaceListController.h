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

@protocol PullToRefrshDelegate <NSObject>
@optional
- (void)didPullDown;

@end

@interface PlaceListController : PPTableViewController <CityOverviewServiceDelegate>

@property (retain, nonatomic) IBOutlet UIView *mapHolderView;
@property (assign, nonatomic) id<PlaceListControllerDelegate> aDelegate;
@property (assign, nonatomic) id<PullToRefrshDelegate> pullDownDelegate;

- (id)initWithSuperNavigationController:(UINavigationController*)superNavigationController 
                  wantPullDownToRefresh:(BOOL)wantPullDownToRefresh
                       pullDownDelegate:(id<PullToRefrshDelegate>)pullDownDelegate;

- (void)showInView:(UIView*)superView;
- (void)setPlaceList:(NSArray*)placeList;

- (void)switchToMapMode;
- (void)switchToListMode;

- (void)canDeletePlace:(BOOL)isCan delegate:(id<PlaceListControllerDelegate>)delegate;

@end
