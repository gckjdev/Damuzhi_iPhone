//
//  LocalRouteListController.m
//  Travel
//
//  Created by 小涛 王 on 12-9-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalRouteListController.h"
#import "AppManager.h"
<<<<<<< HEAD
#import "FontSize.h"
#import "AppDelegate.h"
#import "RouteListCell.h"
#define EACH_COUNT 20
#define CELL_HERDER_HEIGHT 30
=======

#define EACH_COUNT 20

>>>>>>> c8a7910... Merge remote-tracking branch 'origin/version1.x' into version1.x
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
    
    self.navigationItem.title = [NSString stringWithFormat:@"本地游 - ..."];
    dataTableView.backgroundColor = [UIColor orangeColor];

    _appManager = [AppManager defaultManager];
    _routeService = [RouteService defaultService];
    self.dataList = [NSArray array];
    
    [_routeService findLocalRoutes:_cityId 
                             start:_start
                             count:EACH_COUNT 
                    needStatistics:NO
                    viewController:self];
}

<<<<<<< HEAD
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CELL_HERDER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteListCell getCellHeight];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect1 = CGRectMake(0, 0, 320, CELL_HERDER_HEIGHT);
    UIView *view = [[UIView alloc]initWithFrame:rect1];
    UIButton *button = [[UIButton alloc]initWithFrame:rect1];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"哈哈，美国" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickCellHeader:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    CGRect rect2 = CGRectMake(280, 0, 30, CELL_HERDER_HEIGHT);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect2];
    imageView.image = [UIImage imageNamed:@"heart@2x.png"];
    [view addSubview:imageView];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteListCell *cell = (RouteListCell *)[tableView dequeueReusableCellWithIdentifier:[RouteListCell getCellIdentifier]];
    if (nil == cell) {
        cell = [RouteListCell createCell:self];
    }
//    int row = [indexPath row];
//    [cell setCellData:[dataList objectAtIndex:row]];
    [cell setCellData:nil];
    return cell;

    
}

-(void)clickCellHeader:(id)sender
{
    [self popupMessage:@"已经点击" title:nil];
}


- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount 
                   list:(NSArray *)list 
             statistics:(RouteStatistics *)statistics
=======
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount 
                   list:(NSArray *)list 
>>>>>>> c8a7910... Merge remote-tracking branch 'origin/version1.x' into version1.x
{
    
    self.dataList = [dataList arrayByAddingObjectsFromArray:list];     
    self.agencyList = [_appManager getAgencyListFromLocalRouteList:self.dataList];
    self.agencyDic = [_appManager getAgencyDicFromAgencyList:self.agencyList
                                              localRouteList:self.dataList];
<<<<<<< HEAD

    
    
}




- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [self hideTabBar:NO];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [self hideTabBar:YES];
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
=======
    
    
    
>>>>>>> c8a7910... Merge remote-tracking branch 'origin/version1.x' into version1.x
}

@end
