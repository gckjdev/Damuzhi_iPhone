//
//  RouteFeekback.m
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteFeekbackController.h"
#import "Package.pb.h"
#import "PPNetworkRequest.h"
#import "RouteFeekbackCell.h"
#import "ImageManager.h"
#import "UIViewUtils.h"
#import "AppManager.h"

#define TAG_DEPART_CITY_LABEL 18

#define EACH_COUNT 20

@interface RouteFeekbackController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int start;
@property (retain, nonatomic) NSMutableArray *allRouteFeekback;
@property (assign, nonatomic) int totalCount;
@property (assign, nonatomic) int departCityId;
@property (assign, nonatomic) int statisticsView;


- (void)updateStatisticsData;
@end

@implementation RouteFeekbackController

@synthesize routeId = _routeId;
@synthesize start = _start;
@synthesize allRouteFeekback = _allRouteFeekback;
@synthesize totalCount = _totalCount;
@synthesize departCityId = _departCityId;
@synthesize statisticsView = _statisticsView;


- (id)initWithRouteId:(int)routeId
{
    if (self = [super init]) {
        // Custom initialization
        self.routeId = routeId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询") 
                         imageName:@"topmenu_btn2.png"

                            action:@selector(query:)];
    self.navigationItem.title = NSLS(@"路线详情");
    
    dataTableView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1];
    
    [RouteService defaultService] ;
    
    
    [[RouteService defaultService] queryRouteFeekbacks:_routeId start:0 count:EACH_COUNT viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteFeekbackCell getCellHeight];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[RouteFeekbackCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteFeekbackCell createCell:self];		
    
        // Customize the appearance of table view cells at first time
    }
    
    int row = [indexPath row];	
    int count = [dataList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    
    RouteFeekbackCell* routeCell = (RouteFeekbackCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:row]];
    return cell;
}

// essential
- (void)updateStatisticsData
{

}

// RouteService delegate
- (void)findRequestDone:(int)result totalCount:(int)totalCount list:(NSArray *)routeFeekback
{
    [self dataSourceDidFinishLoadingNewData];
    [self dataSourceDidFinishLoadingMoreData];
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    if (_start == 0) {
        self.noMoreData = NO;
        [self.allRouteFeekback removeAllObjects];
        self.dataList = [NSArray array];
    }
  
    self.start += [routeFeekback count];
    self.totalCount = totalCount;
    
    [_allRouteFeekback addObjectsFromArray:routeFeekback];
    self.dataList = [dataList arrayByAddingObjectsFromArray:routeFeekback];     
    
    PPDebug(@"dalist count %d", [dataList count]);
    
    if (_start >= totalCount) {
        self.noMoreData = YES;
    }
    
    [self updateStatisticsData];
    
    [dataTableView reloadData];
}

-(void) showInView:(UIView *)superView
{
    [superView removeAllSubviews];
    
    self.view.frame = superView.bounds;
    [superView addSubview:self.view];
}

@end










