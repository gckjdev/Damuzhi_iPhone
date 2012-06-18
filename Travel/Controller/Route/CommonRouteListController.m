//
//  CommonRouteListController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonRouteListController.h"
#import "AppManager.h"
#import "PPNetworkRequest.h"
#import "RouteUtils.h"
#import "RouteListCell.h"

#define TAG_DEPART_CITY_LABEL 18
#define TAG_STATISTICS_LABEL 19

#define HEIGHT_STATISTICS_VIEW 30
#define HEIGHT_FILTER_HOLDER_VIEW 55

#define COUNT_EACH_FETCH 20

@interface CommonRouteListController ()

@property (retain, nonatomic) NSMutableArray *allRouteList;
@property (retain, nonatomic) NSMutableArray *routeList;
@property (assign, nonatomic) BOOL hasStatisticsView;

@property (assign, nonatomic) int departCityId;
@property (assign, nonatomic) int destinationCityId;
@property (assign, nonatomic) int start;
@property (assign, nonatomic) int totalCount;

@property (retain, nonatomic) UIView *statisticsView;
@property (retain, nonatomic) UIView *buttonsHolderView;

@property (retain, nonatomic) NSObject<RouteListFilterProtocol> *filterHandler;

- (UIView*)genStatisticsView;
- (void)updateStatisticsData;

@end

@implementation CommonRouteListController

@synthesize allRouteList = _allRouteList;
@synthesize routeList = _routeList;
@synthesize hasStatisticsView = _hasStatisticsView;

@synthesize departCityId = _departCityId;
@synthesize destinationCityId = _destinationCityId;
@synthesize start = _start;
@synthesize totalCount = _totalCount;

@synthesize statisticsView = _statisticsView;
@synthesize buttonsHolderView = _buttonsHolderView;

@synthesize filterHandler = _filterHandler;

#pragma mark - View lifecycle
- (void)dealloc
{
    [_allRouteList release];
    [_routeList release];
    [_statisticsView release];
    [_buttonsHolderView release];
    [_filterHandler release];
    
    [super dealloc];
}

- (id)initWithFilterHandler:(NSObject<RouteListFilterProtocol>*)filterHandler
               DepartCityId:(int)departCityId
          destinationCityId:(int)destinationCityId
         hsaStatisticsLabel:(BOOL)hasStatisticsLabel
{
    self = [super init];
    if (self) {
        self.filterHandler = filterHandler;
        self.departCityId = departCityId;
        self.destinationCityId = destinationCityId;
        self.hasStatisticsView = hasStatisticsLabel;
        self.allRouteList = [[[NSMutableArray alloc] init] autorelease];
        self.routeList = [[[NSMutableArray alloc] init] autorelease];
        self.start = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init UI Interface
    self.statisticsView = [self genStatisticsView];
    [self.view addSubview:_statisticsView];
    
    self.buttonsHolderView = [[[UIView alloc] initWithFrame:CGRectMake(0, _statisticsView.frame.size.height, self.view.frame.size.width, HEIGHT_FILTER_HOLDER_VIEW)] autorelease];
    [self.view addSubview:_buttonsHolderView];
    
    
    CGRect rect = CGRectMake(0, _buttonsHolderView.frame.origin.y + _buttonsHolderView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _buttonsHolderView.frame.size.height - _statisticsView.frame.size.height);
    self.dataTableView = [[[UITableView alloc] initWithFrame:rect] autorelease];
    [self.view addSubview:dataTableView];
    
//    // Init statistics data
//    [self setStatisticsDataWithDepartCityId:_departCityId
//                                  routeList:dataList
//                                 angencyDic:_angencyDic];
    
    // Init filter view
    [_filterHandler createFilterButtons:self.buttonsHolderView controller:self];

    // Find route list
    [_filterHandler findRoutesWithDepartCityId:_departCityId
                             destinationCityId:_destinationCityId 
                                         start:_start
                                         count:COUNT_EACH_FETCH 
                                viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _statisticsView = nil;
    _buttonsHolderView = nil;
}

#pragma mark - RouteServiceDelegate
- (void)findRequestDone:(int)result totalCount:(int)totalCount routeList:(NSArray *)routeList
{
    [self hideRefreshHeaderViewAfterLoading];
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    self.start += [routeList count];
    self.totalCount = totalCount;
    
    [_allRouteList addObjectsFromArray:routeList];
    [_routeList addObjectsFromArray:routeList];        
    
    [dataTableView reloadData];
}

#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteListCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_routeList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[RouteListCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteListCell createCell:self];				
        
        // Customize the appearance of table view cells at first time
    }
    
    int row = [indexPath row];	
    int count = [_routeList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    
    RouteListCell* routeCell = (RouteListCell*)cell;
    [routeCell setCellData:[_routeList objectAtIndex:row]];
    
    return cell;
}

#pragma mark - Internal methods
- (UIView*)genStatisticsView
{
    UIView *statisticsView = nil;
    if (_hasStatisticsView) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_STATISTICS_VIEW);
        statisticsView = [[[UILabel alloc] initWithFrame:rect] autorelease];
        
        CGRect rect1 = CGRectMake(0, 0, self.view.frame.size.width/3, HEIGHT_STATISTICS_VIEW);
        UILabel *label1 = [[UILabel alloc] initWithFrame:rect1];
        label1.backgroundColor = [UIColor clearColor];
        label1.tag = TAG_DEPART_CITY_LABEL;
        [_statisticsView addSubview:label1];
        [label1 release];
        
        CGRect rect2 = CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width*2/3, HEIGHT_STATISTICS_VIEW);
        UILabel *label2 = [[UILabel alloc] initWithFrame:rect2];
        label2.backgroundColor = [UIColor clearColor];
        label2.tag = TAG_STATISTICS_LABEL;
        [_statisticsView addSubview:label2];
        [label2 release];
    }
    
    return statisticsView;
}

- (void)updateStatisticsData
{
    
}

- (void)hideRefreshHeaderViewAfterLoading
{
    if (self.supportRefreshHeader) {
        // after finish loading data, please call the following codes
//        [refreshHeaderView setCurrentDate];  	
        [self dataSourceDidFinishLoadingNewData];
    }
}

- (void)fechMoreRouteList
{
    if (_start >= _totalCount) {
        return;
    }
    
    else {
        [_filterHandler findRoutesWithDepartCityId:_departCityId
                                 destinationCityId:_destinationCityId 
                                             start:_start
                                             count:COUNT_EACH_FETCH
                                    viewController:self];
    }
}

@end
