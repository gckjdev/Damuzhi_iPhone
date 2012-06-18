//
//  CommonPlaceListController.h
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "PlaceService.h"
#import "SelectController.h"
#import "CityOverviewService.h"
#import "SelectedItemIdsManager.h"
#import "PlaceListController.h"

#define WIDTH_OF_FILTER_BUTTON 52
#define HEIGHT_OF_FILTER_BUTTON 27
#define DISTANCE_BETWEEN_BUTTONS 5

#define SORT_BUTTON_TAG 99

@class PlaceListController;

@protocol PlaceListFilterProtocol <NSObject>

@optional
- (void)createFilterButtons:(UIView*)superView controller:(PPTableViewController*)controller;
- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController;
+ (NSObject<PlaceListFilterProtocol>*)createFilter;

- (int)getCategoryId;
- (NSString*)getCategoryName;

- (NSArray*)filterAndSotrPlaceList:(NSArray*)placeList selectedItems:(SelectedItemIds*)selectedItemIds;

@end

@interface CommonPlaceListController : PPTableViewController <PlaceServiceDelegate, CityOverviewServiceDelegate, SelectControllerDelegate, PullToRefrshDelegate>

@property (retain, nonatomic) IBOutlet UIView *buttonHolderView;
@property (retain, nonatomic) IBOutlet UIView *placeListHolderView;
@property (retain, nonatomic) IBOutlet UIButton *modeButton;

- (id)initWithFilterHandler:(NSObject<PlaceListFilterProtocol>*)handler;
- (IBAction)clickMapButton:(id)sender;

@end
