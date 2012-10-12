//
//  LocalRouteDetailController.h
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"
#import "RouteService.h"
#import "LocalRouteIntroductionController.h"
#import "PlaceService.h"

@class LocalRoute;

@interface LocalRouteDetailController : PPViewController <RouteServiceDelegate, UIActionSheetDelegate, LocalRouteIntroductionControllerDelegage, PlaceServiceDelegate>

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *agencyNameLabel;
@property (retain, nonatomic) IBOutlet UIView *contentHolderView;
@property (retain, nonatomic) IBOutlet UIButton *introductionButton;

- (id)initWithLocalRouteId:(int)routeId;

- (id)initWithLocalRouteId:(int)routeId detailUrl:(NSString *)detailUrl;

@end
