//
//  LocalRouteListController.m
//  Travel
//
//  Created by 小涛 王 on 12-9-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalRouteListController.h"
#import "AppManager.h"

#define EACH_COUNT 20

@interface LocalRouteListController ()
{
    int _cityId;
    int _start;
    AppManager *_appManager;
    RouteService *_routeService;
}

@property (retain, nonatomic) NSArray *agencyList;
@property (retain, nonatomic) NSDictionary *agencyDic;

@end

@implementation LocalRouteListController
@synthesize agencyList = _agencyList;
@synthesize agencyDic = _agencyDic;

- (void)dealloc
{
    [_agencyList release];
    [_agencyDic release];
    [super dealloc];
}

- (id)initWithCityId:(int)cityId
{
    if (self = [super init]) {
        _cityId = cityId;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _appManager = [AppManager defaultManager];
    _routeService = [RouteService defaultService];
    self.dataList = [NSArray array];
    
    [_routeService findLocalRoutes:_cityId 
                             start:_start
                             count:EACH_COUNT 
                    needStatistics:NO
                    viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount 
                   list:(NSArray *)list 
{
    
    self.dataList = [dataList arrayByAddingObjectsFromArray:list];     
    self.agencyList = [_appManager getAgencyListFromLocalRouteList:self.dataList];
    self.agencyDic = [_appManager getAgencyDicFromAgencyList:self.agencyList
                                              localRouteList:self.dataList];
    
    
    
}

@end
