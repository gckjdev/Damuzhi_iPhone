//
//  LocalRouteDetailController.h
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"

@class LocalRoute;

@interface LocalRouteDetailController : PPViewController

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *agencyNameLabel;
@property (retain, nonatomic) IBOutlet UIView *contentHolderView;

- (id)initWithLocalRoute:(int)routeId;


@end
