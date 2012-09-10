//
//  LocalRouteDetailController.m
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteDetailController.h"
#import "TouristRoute.pb.h"

@interface LocalRouteDetailController ()

@property (assign, nonatomic) int routeId;

@end

@implementation LocalRouteDetailController
@synthesize routeNameLabel = _routeNameLabel;
@synthesize routeIdLabel = _routeIdLabel;
@synthesize agencyNameLabel = _agencyNameLabel;
@synthesize contentHolderView = _contentHolderView;
@synthesize routeId = _routeId;

- (void)dealloc
{
    [_routeNameLabel release];
    [_routeIdLabel release];
    [_agencyNameLabel release];
    [_contentHolderView release];
    [super dealloc];
}

- (id)initWithLocalRoute:(int)routeId
{
    self = [super init];
    if (self) {
        self.routeId = routeId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setRouteIdLabel:nil];
    [self setAgencyNameLabel:nil];
    [self setContentHolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
