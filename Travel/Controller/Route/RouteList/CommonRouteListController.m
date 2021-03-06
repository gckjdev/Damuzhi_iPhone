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
#import "CommonRouteListFilter.h"
#import "ImageManager.h"
#import "SelectedItemIdsManager.h"
#import "CommonRouteDetailController.h"
#import "AppConstants.h"
#import "SelectCityController.h"
#import "Item.h"
#import "FollowRouteController.h"
#import "AppDelegate.h"
#import "FontSize.h"
#define TAG_DEPART_CITY_LABEL 18
#define TAG_AGENCY_LABEL 19
#define TAG_ROUTE_COUNT_LABEL 20

#define HEIGHT_STATISTICS_VIEW 20
#define HEIGHT_FILTER_HOLDER_VIEW 40

#define COUNT_EACH_FETCH 20

@interface CommonRouteListController ()

@property (assign, nonatomic) BOOL hasStatisticsView;

@property (assign, nonatomic) int departCityId;
@property (assign, nonatomic) int destinationCityId;
@property (assign, nonatomic) int start;
@property (assign, nonatomic) int totalCount;

@property (retain, nonatomic) RouteSelectedItemIds *selectedItemIds;

@property (retain, nonatomic) UIView *statisticsView;
@property (retain, nonatomic) UIView *buttonsHolderView;

@property (retain, nonatomic) NSObject<RouteListFilterProtocol> *filterHandler;

@property (retain, nonatomic) RouteStatistics *routeStatistics;

- (UIView*)genStatisticsView;
- (void)updateStatisticsData;
- (void)updateDepartCityButton;

@end

@implementation CommonRouteListController

@synthesize hasStatisticsView = _hasStatisticsView;

@synthesize departCityId = _departCityId;
@synthesize destinationCityId = _destinationCityId;
@synthesize start = _start;
@synthesize totalCount = _totalCount;

@synthesize selectedItemIds = _selectedItemIds;

@synthesize statisticsView = _statisticsView;
@synthesize buttonsHolderView = _buttonsHolderView;

@synthesize filterHandler = _filterHandler;

@synthesize routeStatistics = _routeStatistics;

#pragma mark - View lifecycle
- (void)dealloc
{
    [_selectedItemIds release];
    
    [_statisticsView release];
    [_buttonsHolderView release];
    [_filterHandler release];
    [_routeStatistics release];
    
    [super dealloc];
}

- (id)initWithFilterHandler:(NSObject<RouteListFilterProtocol>*)filterHandler
               DepartCityId:(int)departCityId
          destinationCityId:(int)destinationCityId
         hasStatisticsLabel:(BOOL)hasStatisticsLabel
{
    self = [super init];
    if (self) {
        self.filterHandler = filterHandler;
        self.departCityId = departCityId;
        self.destinationCityId = destinationCityId;
        self.hasStatisticsView = hasStatisticsLabel;
        
        self.dataList = [NSArray array];
        self.start = 0;
        
        self.supportRefreshHeader = YES;
        self.supportRefreshFooter = YES;
        self.footerRefreshType = AutoAndAddMore;
        self.footerLoadMoreTitle = NSLS(@"更多...");
        self.footerLoadMoreLoadingTitle = NSLS(@"正在加载...");
        
        self.selectedItemIds = [[SelectedItemIdsManager defaultManager] getRouteSelectedItems:[_filterHandler getRouteType]];
    }
    
    return self;
}

- (CGFloat)offsetStartLoadMoreData
{
    return 0;
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


- (void)viewDidLoad
{

    self.title = [_filterHandler getRouteTypeName];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    // Init UI Interface
    
    [self setNavigationRightButton:NSLS(@"我的关注") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickMyFollow:)];
    
    self.statisticsView = [self genStatisticsView];
    [self.view addSubview:_statisticsView];
    [_statisticsView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] statisticsBgImage]]];
    
    self.buttonsHolderView = [[[UIView alloc] initWithFrame:CGRectMake(0, _statisticsView.frame.size.height, self.view.frame.size.width, HEIGHT_FILTER_HOLDER_VIEW)] autorelease];
    _buttonsHolderView.backgroundColor = [UIColor whiteColor];
    
    
    
    _buttonsHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] filterBtnsHolderViewBgImage]];
    
    [self.view addSubview:_buttonsHolderView];
    if (self.hasStatisticsView ) {
        UIImageView *lineView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 300, 2)] autorelease];
        [lineView setImage:[[ImageManager defaultManager] lineImage]];
        //    [_statisticsView addSubview:lineView];
        [_buttonsHolderView addSubview:lineView];
        //    // Init statistics data
        [self updateStatisticsData];
    }

    CGRect rect = CGRectMake(0, _buttonsHolderView.frame.origin.y + _buttonsHolderView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _buttonsHolderView.frame.size.height - _statisticsView.frame.size.height);
    self.dataTableView.frame = rect;    
    
    // Init filter view
    [_filterHandler createFilterButtons:self.buttonsHolderView controller:self];

    // Find route list
    [_filterHandler findRoutesWithStart:_start 
                                  count:COUNT_EACH_FETCH 
                   RouteSelectedItemIds:_selectedItemIds 
                         needStatistics:YES 
                         viewController:self];
    
    dataTableView.backgroundColor = [UIColor whiteColor];
    
    [self updateDepartCityButton];
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
- (void)findRequestDone:(int)result
             totalCount:(int)totalCount 
                   list:(NSArray *)routeList 
             statistics:(RouteStatistics *)statistics
{
    if (_routeStatistics == nil) {
        self.routeStatistics = statistics;
    }
    
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
    } else {
        if (_start == 0) {
            self.noMoreData = NO;
            self.dataList = [NSArray array];
        }
        
        self.start += [routeList count];
        self.totalCount = totalCount;
        
        self.dataList = [dataList arrayByAddingObjectsFromArray:routeList];     
        
        
        if (_start >= totalCount) {
            self.noMoreData = YES;
        }
        
        if (_hasStatisticsView) {
            [self updateStatisticsData];
        }
        
        [dataTableView reloadData];
    }
    
    if ([self.dataList count] == 0) {
        self.noMoreData = YES;
        [self showTipsOnTableView:NSLS(@"未找到相关信息")];
    }else {
        [self hideTipsOnTableView];
    }
    
    [self dataSourceDidFinishLoadingNewData];
    [self dataSourceDidFinishLoadingMoreData];
}

#pragma mark - TableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteListCell getCellHeight];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [dataList count];
//}

// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[RouteListCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteListCell createCell:self];		
    }
    
    int row = [indexPath row];	
    int count = [dataList count];
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    
    RouteListCell* routeCell = (RouteListCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int routeId = [[dataList objectAtIndex:indexPath.row] routeId];
    
    CommonRouteDetailController *controller = [[CommonRouteDetailController alloc] initWithRouteId:routeId routeType:[_filterHandler getRouteType]];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}


#pragma mark - Internal methods

#define WIDTH_DEPART_ICON 9
#define HEIGHT_DEPART_ICON 11

#define WIDTH_AGENCY_ICON 9
#define HEIGHT_AGENCY_ICON 9

#define WIDTH_ROUTE_COUNT_ICON 9
#define HEIGHT_ROUTE_COUNT_ICON 9

#define FONT_STATISTICS_TEXT [UIFont systemFontOfSize:12]

- (UIView*)genStatisticsView
{
    UIView *statisticsView = nil;
    if (_hasStatisticsView) {
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_STATISTICS_VIEW);
        statisticsView = [[[UILabel alloc] initWithFrame:rect] autorelease];
        
        CGFloat origin_x = 10;
        UIImageView *departIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(origin_x, HEIGHT_STATISTICS_VIEW/2-HEIGHT_DEPART_ICON/2 + 2, WIDTH_DEPART_ICON, HEIGHT_DEPART_ICON)] autorelease];
        [departIcon setImage:[[ImageManager defaultManager] departIcon]];
        [statisticsView addSubview:departIcon];
        
        origin_x = departIcon.frame.origin.x + departIcon.frame.size.width + 3;
        CGRect rect1 = CGRectMake(origin_x, 2, 80, HEIGHT_STATISTICS_VIEW);
        UILabel *departCityLabel = [[UILabel alloc] initWithFrame:rect1];
        departCityLabel.backgroundColor = [UIColor clearColor];
        departCityLabel.tag = TAG_DEPART_CITY_LABEL;
        departCityLabel.font = FONT_STATISTICS_TEXT;
        [statisticsView addSubview:departCityLabel];
        [departCityLabel release];
        
        origin_x = 160;
        UIImageView *agencyIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(origin_x, HEIGHT_STATISTICS_VIEW/2-HEIGHT_AGENCY_ICON/2 + 2, WIDTH_AGENCY_ICON, HEIGHT_AGENCY_ICON)] autorelease];
        [agencyIcon setImage:[[ImageManager defaultManager] angencyIcon]];
        [statisticsView addSubview:agencyIcon];
        
        origin_x = agencyIcon.frame.origin.x + agencyIcon.frame.size.width + 3;
        CGRect rect2 = CGRectMake(origin_x, statisticsView.frame.size.height/2-HEIGHT_STATISTICS_VIEW/2 + 2, 70, HEIGHT_STATISTICS_VIEW);
        UILabel *agencyLabel = [[UILabel alloc] initWithFrame:rect2];
        agencyLabel.backgroundColor = [UIColor clearColor];
        agencyLabel.tag = TAG_AGENCY_LABEL;
        agencyLabel.font = FONT_STATISTICS_TEXT;
        [statisticsView addSubview:agencyLabel];
        [agencyLabel release];
        
        origin_x = 245;
        UIImageView *routeCountIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(origin_x, statisticsView.frame.size.height/2-HEIGHT_ROUTE_COUNT_ICON/2 + 2, WIDTH_ROUTE_COUNT_ICON, HEIGHT_ROUTE_COUNT_ICON)] autorelease];
        [routeCountIcon setImage:[[ImageManager defaultManager] routeCountIcon]];
        [statisticsView addSubview:routeCountIcon];
        
        origin_x = routeCountIcon.frame.origin.x + routeCountIcon.frame.size.width + 3;
        CGRect rect3 = CGRectMake(origin_x, statisticsView.frame.size.height/2-HEIGHT_STATISTICS_VIEW/2 + 2, 60, HEIGHT_STATISTICS_VIEW);
        UILabel *routeCountLabel = [[UILabel alloc] initWithFrame:rect3];
        routeCountLabel.backgroundColor = [UIColor clearColor];
        routeCountLabel.tag = TAG_ROUTE_COUNT_LABEL;
        routeCountLabel.font = FONT_STATISTICS_TEXT;
        [statisticsView addSubview:routeCountLabel];
        [routeCountLabel release];
    }
    
    return statisticsView;
}

- (void)updateStatisticsData
{
    NSString *departCityName = [[AppManager defaultManager] getDepartCityName:_departCityId];
    UILabel *departCityLabel = (UILabel *)[_statisticsView viewWithTag:TAG_DEPART_CITY_LABEL];
    [departCityLabel setText:[NSString stringWithFormat:@"%@出发", departCityName]];
    
    int agencyCount = 0;
    if ([[_selectedItemIds.agencyIds objectAtIndex:0] intValue] == ALL_CATEGORY) {
        agencyCount = [[[AppManager defaultManager] getAgencyItemList:_routeStatistics.agencyStatisticsList] count] - 1;
    }else {
        [_selectedItemIds.agencyIds count];
    }
    UILabel *agencyLabel = (UILabel *)[_statisticsView viewWithTag:TAG_AGENCY_LABEL];
    [agencyLabel setText:[NSString stringWithFormat:@"%d个旅行社", agencyCount]];
    
    UILabel *routeCountLabel = (UILabel *)[_statisticsView viewWithTag:TAG_ROUTE_COUNT_LABEL];
    [routeCountLabel setText:[NSString stringWithFormat:@"%d条线路", [dataList count]]];
}

- (void)fechMoreRouteList
{
    if (_start >= _totalCount) {
        self.noMoreData = YES;
        [self dataSourceDidFinishLoadingMoreData];
        return;
    }
    
    else {
        [_filterHandler findRoutesWithStart:_start 
                                      count:COUNT_EACH_FETCH 
                       RouteSelectedItemIds:_selectedItemIds 
                             needStatistics:NO 
                             viewController:self];
    }
}

- (void)reloadTableViewDataSource
{
    self.start = 0;
    // Find route list
    [_filterHandler findRoutesWithStart:_start 
                                  count:COUNT_EACH_FETCH 
                   RouteSelectedItemIds:_selectedItemIds 
                         needStatistics:NO
                         viewController:self];
}

- (void)pushDepartCitySelectController
{
    NSArray *itemList = [[AppManager defaultManager] getDepartCityItemList:_routeStatistics.departCityStatisticsList];
    SelectCityController *controller = [[SelectCityController alloc] initWithTitle:NSLS(@"出发城市") 
                                                                        regionList:nil 
                                                                          itemList:itemList
                                                                selectedItemIdList:_selectedItemIds.departCityIds 
                                                                              type:depart 
                                                                      multiOptions:NO
                                                                          delegate:self];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)pushDestinationCitySelectController
{
    NSArray *regionList = [[AppManager defaultManager] getRegions];
    NSArray *itemList = [[AppManager defaultManager] getDestinationCityItemList];
    [_selectedItemIds reset]; // reset to the default choice(choose all)
    SelectCityController *controller = [[SelectCityController alloc] initWithTitle:NSLS(@"目的城市") 
                                                                        regionList:regionList 
                                                                          itemList:itemList
                                                                selectedItemIdList:_selectedItemIds.destinationCityIds 
                                                                              type:destination
                                                                      multiOptions:YES
                                                                          delegate:self];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)pushAgencySelectController
{
     NSArray *itemList = [[AppManager defaultManager] getAgencyItemList:_routeStatistics.agencyStatisticsList];
    
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"旅行社选择")
                                                                  itemList:itemList
                                                           selectedItemIds:_selectedItemIds.agencyIds
                                                              multiOptions:YES 
                                                               needConfirm:YES
                                                             needShowCount:YES];
    
    
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)pushSortTypeSelectController
{
    NSArray *itemList = [[AppManager defaultManager] buildRouteSortItemList];
    
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"排序")
                                                                  itemList:itemList
                                                           selectedItemIds:_selectedItemIds.sortIds
                                                              multiOptions:NO 
                                                               needConfirm:YES
                                                             needShowCount:NO];
    
    
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)loadMoreTableViewDataSource
{
    [self fechMoreRouteList];
}

- (void)clickFitlerButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case TAG_FILTER_BTN_DEPART_CITY:
            [self pushDepartCitySelectController];
            break;
            
        case TAG_FILTER_BTN_CLASSIFY:
            [self pushRouteSelectController];
            break;
        case TAG_FILTER_BTN_DESTINATION_CITY:
            [self pushDestinationCitySelectController];
            break;
            
        case TAG_SORT_BTN:
            [self pushSortTypeSelectController];
            break;
        case TAG_FILTER_BTN_AGENCY:
            [self pushAgencySelectController];
            break;

        default:
            break;
    }
}



- (void)pushRouteSelectController
{    
    RouteSelectController *controller = [[[RouteSelectController alloc] initWithRouteType:[_filterHandler getRouteType] selectedItemIds:_selectedItemIds] autorelease];
    controller.aDelegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickBack:(id)sender
{
    [_selectedItemIds reset]; 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickMyFollow:(id)sender
{
    FollowRouteController *controller  = [[FollowRouteController alloc] initWithRouteType:[_filterHandler getRouteType]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)updateDepartCityButton
{
    NSNumber *cityId = (NSNumber *)[_selectedItemIds.departCityIds objectAtIndex:0];
    NSString *departCityName = [[AppManager defaultManager] getDepartCityName:[cityId intValue]];
    if ([cityId intValue] == ALL_CATEGORY) {
        departCityName = @"全部";
    }
    NSString *buttonTitle = [NSString stringWithFormat:NSLS(@"出发:%@"), departCityName];
    UIButton *button = (UIButton *)[self.buttonsHolderView viewWithTag:TAG_FILTER_BTN_DEPART_CITY];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
}

#pragma mark - SelectControllerDelegate method
- (void)didSelectFinish:(NSArray*)selectedItems
{
    self.start = 0;
    
    [_filterHandler findRoutesWithStart:_start 
                                  count:COUNT_EACH_FETCH 
                   RouteSelectedItemIds:_selectedItemIds 
                         needStatistics:NO 
                         viewController:self]; 
}

#pragma mark - SelectCityDelegate methods
- (void)didSelectCity:(NSArray *)selectedItemList
{
    self.start = 0;
    
    [_filterHandler findRoutesWithStart:_start 
                                  count:COUNT_EACH_FETCH 
                   RouteSelectedItemIds:_selectedItemIds 
                         needStatistics:NO 
                         viewController:self];
    [self updateDepartCityButton];
}

#pragma mark - 
#pragma mark: Implementation of RouteSelectControllerDelegate.
- (void)didClickFinish
{
    self.start = 0;

    [_filterHandler findRoutesWithStart:_start 
                                  count:COUNT_EACH_FETCH 
                   RouteSelectedItemIds:_selectedItemIds 
                         needStatistics:NO 
                         viewController:self];
}



@end
