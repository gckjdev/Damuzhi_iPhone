//
//  LocalRouteListController.m
//  Travel
//
//  Created by 小涛 王 on 12-9-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalRouteListController.h"
#import "AppManager.h"
#import "FontSize.h"
#import "AppDelegate.h"
#import "RouteListCell.h"
#import "TouristRoute.pb.h"
#import "CommonWebController.h"
#import "AppUtils.h"
#import "UIViewUtils.h"
#import "LocalRouteDetailController.h"
#import "AppDelegate.h"
#import "CityManagementController.h"

#define EACH_COUNT 20
#define CELL_HERDER_HEIGHT 30

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
    
    
    self.navigationItem.titleView = [self createButtonView];
    dataTableView.backgroundColor = [UIColor colorWithRed:215/255.0 green:220/255.0 blue:226/255.0 alpha:1.0];

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

- (UIButton *)createButtonView
{
    NSString *currentCityName = [_appManager getCurrentCityName];
    NSString *buttonTitle = [NSString stringWithFormat:@"本地游 — %@",currentCityName];
    UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0,200,44)] autorelease];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"top_arrow.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)clickTitle:(id)sender
{
    //    CityManagementController *controller = [CityManagementController getInstance];
    //    [self.navigationController pushViewController:controller animated:YES];
    CityManagementController *controller = [[CityManagementController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.agencyDic objectForKey:[[self.agencyList objectAtIndex:section] name]] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.agencyList count];
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
    button.tag = section;
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:[self getSectionHeaderViewName:section] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickCellHeader:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    CGRect rect2 = CGRectMake(300, 0, 20, CELL_HERDER_HEIGHT);
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
    int row = [indexPath row];
    int section = [indexPath section];
    [cell setCellData:[self getRoute:row section:section]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    int routeId = [[self getRoute:row section:section] routeId];
    LocalRouteDetailController *controller = [[LocalRouteDetailController alloc]initWithLocalRouteId:routeId];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


-(TouristRoute *)getRoute:(int) row section:(int)section
{
    return  [[self.agencyDic objectForKey:[self getSectionHeaderViewName:section]] objectAtIndex:row];
}

-(NSString *) getSectionHeaderViewName:(int)section
{
    return [[self.agencyList objectAtIndex:section] name];
} 

-(void)clickCellHeader:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int section = button.tag;
    NSString *agencyName = [self getSectionHeaderViewName:section];
     CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:@"http://www.baidu.com"];
    controller.navigationItem.title = agencyName;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}


- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount 
                   list:(NSArray *)list 
{
    
    self.dataList = [dataList arrayByAddingObjectsFromArray:list];  
    self.agencyList = [_appManager getAgencyListFromLocalRouteList:self.dataList];
    self.agencyDic = [_appManager getAgencyDicFromAgencyList:self.agencyList
                                              localRouteList:self.dataList];
    
    [dataTableView reloadData];

}


- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}

@end
