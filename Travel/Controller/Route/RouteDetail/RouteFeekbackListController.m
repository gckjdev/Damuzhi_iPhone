//
//  RouteFeekback.m
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteFeekbackListController.h"
#import "Package.pb.h"
#import "PPNetworkRequest.h"
#import "RouteFeekbackCell.h"
#import "ImageManager.h"
#import "UIViewUtils.h"
#import "AppManager.h"
#import "FontSize.h"
#define TAG_DEPART_CITY_LABEL 18

#define EACH_COUNT 20

@interface RouteFeekbackListController ()

@property (assign, nonatomic) int routeId;
@property (assign, nonatomic) int start;
@property (retain, nonatomic) NSMutableArray *allRouteFeekback;
@property (assign, nonatomic) int totalCount;
@property (assign, nonatomic) int departCityId;
@property (assign, nonatomic) int statisticsView;


- (void)updateStatisticsData;
@end

@implementation RouteFeekbackListController


@synthesize routeId = _routeId;
@synthesize start = _start;
@synthesize allRouteFeekback = _allRouteFeekback;
@synthesize totalCount = _totalCount;
@synthesize departCityId = _departCityId;
@synthesize statisticsView = _statisticsView;

-(void)dealloc
{
    [_allRouteFeekback release];
    [super dealloc];
}

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
    self.supportRefreshHeader = YES;
    self.supportRefreshFooter = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn2.png"
                            action:@selector(query:)];
    
    self.navigationItem.title = NSLS(@"路线详情");
    
    
    dataTableView.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1]];

    [RouteService defaultService] ;
    
    [[RouteService defaultService] queryRouteFeekbacks:_routeId start:_start count:EACH_COUNT viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [RouteFeekbackCell getCellHeight];
    NSInteger row = [indexPath row];
    RouteFeekback *feekback = [self.dataList objectAtIndex:row];
    CGSize size = [feekback.content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(278, 1000) lineBreakMode:UILineBreakModeCharacterWrap];

    return size.height + 55;
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
    
    if ([dataList count] == 0) {
        [self showTipsOnTableView:@"暂无反馈信息"];
        return;
    }else {
        [self hideTipsOnTableView];
    }
    
    if (_start >= totalCount) {
        self.noMoreData = YES;
    }
    
    [self updateStatisticsData];
    
    [dataTableView reloadData];
    
}


- (void)fetchMoreFeedback
{
    if (_start >= _totalCount) {
        return;
    }
    else {
        [[RouteService defaultService] queryRouteFeekbacks:_routeId start:_start count:EACH_COUNT viewController:self];
    }
}

- (void)loadMoreTableViewDataSource
{
    [self fetchMoreFeedback];
}

- (void)reloadTableViewDataSource
{
    self.start = 0;
    // Find route list
    [[RouteService defaultService] queryRouteFeekbacks:_routeId start:_start count:EACH_COUNT viewController:self];
}

-(void) showInView:(UIView *)superView
{
//    [superView removeAllSubviews];
    
    self.view.frame = superView.bounds;
    [superView addSubview:self.view];
}

@end










