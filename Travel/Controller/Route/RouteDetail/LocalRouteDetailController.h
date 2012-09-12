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

@class LocalRoute;

@interface LocalRouteDetailController : PPViewController <RouteServiceDelegate, UIActionSheetDelegate, LocalRouteIntroductionControllerDelegage>

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *agencyNameLabel;
@property (retain, nonatomic) IBOutlet UIView *contentHolderView;
@property (retain, nonatomic) IBOutlet UIButton *introductionButton;

- (id)initWithLocalRouteId:(int)routeId;


@end
