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
#define CELL_HERDER_HEIGHT 33

@interface LocalRouteListController ()
{
    int _cityId;
    AppManager *_appManager;
    RouteService *_routeService;
}

@property (assign, nonatomic) int start;
@property (assign, nonatomic) int totalCount;
@property (retain, nonatomic) NSArray *agencyList;
@property (retain, nonatomic) NSDictionary *agencyDic;
@property (retain, nonatomic) UIButton *changeCitybutton;
@property (retain, nonatomic) UIImageView *bottomImageview;

@end

@implementation LocalRouteListController
@synthesize start = _start;
@synthesize totalCount = _totalCount;
@synthesize agencyList = _agencyList;
@synthesize agencyDic = _agencyDic;
@synthesize changeCitybutton = _changeCitybutton;
@synthesize bottomImageview = _bottomImageview;

- (void)dealloc
{
    [_agencyList release];
    [_agencyDic release];
    [_changeCitybutton release];
    [_bottomImageview release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.supportRefreshHeader = YES;
        self.supportRefreshFooter = YES;
        self.footerRefreshType = AutoAndAddMore;
        self.footerLoadMoreTitle = NSLS(@"更多...");
        self.footerLoadMoreLoadingTitle = NSLS(@"正在加载...");
    }
    
    return self;
}

#define WIDTH_TOP_ARRAW 14
#define HEIGHT_TOP_ARRAW 7
#define WIDTH_BLANK_OF_TITLE 14
- (void)viewDidLoad
{
    [super viewDidLoad];
    _appManager = [AppManager defaultManager];
    _routeService = [RouteService defaultService];
  
    _changeCitybutton = [[UIButton alloc] init];
    [_changeCitybutton addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _changeCitybutton;
    
    dataTableView.backgroundColor = [UIColor colorWithRed:215/255.0 green:220/255.0 blue:226/255.0 alpha:1.0];
    
    [self createButtonView];
    
    _start = 0;
    _cityId = [_appManager getCurrentCityId];
    [self findLocalRoutes];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillAppear:animated];
    
    PPDebug(@"cityid : %d", _cityId);
    PPDebug(@"getCurrentCityId : %d", [_appManager getCurrentCityId]);
    
    if (_cityId != [_appManager getCurrentCityId]) {
        _cityId = [_appManager getCurrentCityId];
        [self createButtonView];
        
        self.start = 0;
        [self findLocalRoutes];
        
        [_bottomImageview removeFromSuperview];
    }
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

- (void)hideTabBar:(BOOL)isHide
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideTabBar:isHide];
}

- (void)createButtonView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize withinSize = CGSizeMake(320, CGFLOAT_MAX);
    
    NSString *title = [NSString stringWithFormat:@"本地游 — %@", [[AppManager defaultManager] getCurrentCityName]];
    CGSize titleSize = [title sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeTailTruncation];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleSize.width+WIDTH_TOP_ARRAW+WIDTH_BLANK_OF_TITLE, titleSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    
    [button setImage:[UIImage imageNamed:@"top_arrow.png"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+WIDTH_BLANK_OF_TITLE, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -WIDTH_TOP_ARRAW-WIDTH_BLANK_OF_TITLE, 0, 0);
    
    //    button.titleLabel.shadowOffset = CGSizeMake(-1, -2);
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
    
    [button release];
}


- (void)clickTitle:(id)sender
{
    CityManagementController *controller = [CityManagementController getInstance];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#define TAG_BOTTOM 12101101
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    [super scrollViewDidScroll:scrollView];
    
    CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
    if (self.noMoreData && scrollPosition <= 0) {
        if ([self.dataTableView viewWithTag:TAG_BOTTOM] == nil) {
            
            if (self.bottomImageview == nil) {
                self.bottomImageview = [[[UIImageView alloc] init] autorelease];
                _bottomImageview.tag = TAG_BOTTOM;
                [_bottomImageview setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
            }
            CGFloat cHeight = dataTableView.contentSize.height;
            CGFloat fHeight = dataTableView.frame.size.height;
            CGFloat y = (cHeight > fHeight ? cHeight : fHeight);
            _bottomImageview.frame = CGRectMake(0, y, 320, 250);
            [dataTableView addSubview:_bottomImageview];
        }
    } else {
        [_bottomImageview removeFromSuperview];
    }
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
    UIView *view = [[[UIView alloc]initWithFrame:rect1]autorelease];
    UIButton *button = [[[UIButton alloc]initWithFrame:rect1]autorelease];
    
    button.tag = section;
    [button setTitleColor:[UIColor colorWithRed:255/255.0 green:99/255.0 blue:5/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(1, 0);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];

    [button setBackgroundImage:[UIImage imageNamed:@"line_top_bg@2x.png"] forState:UIControlStateNormal];

    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    
    [button setTitle:[self getSectionHeaderViewName:section] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickCellHeader:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    CGRect rect2 = CGRectMake(300, 8, 8, 16);
    UIImageView *imageViewArrow = [[[UIImageView alloc]initWithFrame:rect2]autorelease];
    imageViewArrow.image = [UIImage imageNamed:@"go_btn_local@2x.png"];
    [view addSubview:imageViewArrow];
    
    CGRect rect3 = CGRectMake(0, CELL_HERDER_HEIGHT, 320, 4);
    UIImageView *imageViewShadow = [[[UIImageView alloc]initWithFrame:rect3]autorelease];
    imageViewShadow.image = [UIImage imageNamed:@"line_top_shadow@2x.png"];
    [view addSubview:imageViewShadow];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    LocalRoute *localRoute = (LocalRoute *)[self getRoute:row section:section];
    
    LocalRouteDetailController *controller = [[LocalRouteDetailController alloc] initWithLocalRouteId:localRoute.routeId detailUrl:localRoute.detailUrl];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (LocalRoute *)getRoute:(int) row section:(int)section
{
    return  [[self.agencyDic objectForKey:[self getSectionHeaderViewName:section]] objectAtIndex:row];
}

- (NSString *)getSectionHeaderViewName:(int)section
{
    return [[self.agencyList objectAtIndex:section] name];
} 

- (void)clickCellHeader:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int section = button.tag;
    Agency * agency = [self.agencyList objectAtIndex:section];
    
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:agency.url];
    PPDebug(@"hahahahx is %@", agency.url);
    
    controller.navigationItem.title = NSLS(@"旅行社介绍");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)currentCityDidChange:(int)newCityId
{    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setSeletedTabbarIndex:0];
}


- (void )findLocalRoutes
{ 
    [_routeService findLocalRoutes:_cityId 
                             start:_start
                             count:EACH_COUNT 
                    needStatistics:NO
                    viewController:self];
}

- (void)findRequestDone:(int)result 
             totalCount:(int)totalCount 
                   list:(NSArray *)list 
{
    if (_start == 0) {
        self.dataList = [NSArray array];
    }
    
    self.dataList = [dataList arrayByAddingObjectsFromArray:list];
    self.agencyList = [_appManager getAgencyListFromLocalRouteList:self.dataList];
    self.agencyDic = [_appManager getAgencyDicFromAgencyList:self.agencyList
                                              localRouteList:self.dataList];
    
    self.start += [list count];
    self.totalCount = totalCount;
    
    if (_start >= totalCount) {
        self.noMoreData = YES;
    }else {
        self.noMoreData = NO;
    }
    
    [dataTableView reloadData];
    
    
    
    if ([self.dataList count] == 0) {
        self.noMoreData = YES;
        [self showTipsOnTableView:NSLS(@"该城市暂未开通本地游线路")];
    }else {
        [self hideTipsOnTableView];
    }
    
    [self dataSourceDidFinishLoadingNewData];
    [self dataSourceDidFinishLoadingMoreData];
}

 
- (void)loadMoreTableViewDataSource
{
    if (_start >= _totalCount) {
        self.noMoreData = YES;
        [self dataSourceDidFinishLoadingMoreData];
        return;
    }
    
    else {
        [self findLocalRoutes];
    }
}

- (void)reloadTableViewDataSource
{
    self.start = 0;
    
    [self findLocalRoutes];
}



@end
