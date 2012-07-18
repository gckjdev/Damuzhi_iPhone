//
//  OrderListController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderListController.h"
#import "ImageManager.h"
#import "UserManager.h"
#import "PPNetworkRequest.h"
#import "TimeUtils.h"
#import "CommonRouteDetailController.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"

#import "RouteFeekbackController.h"

#define HEIGHT_HEADER_VIEW 44
#define TAG_HEADER_VIEW_BG_IMAGE_VIEW 102


@interface OrderListController ()

@property (assign, nonatomic) int orderType;
@property (retain, nonatomic) NSMutableArray *sectionStat;
@end

@implementation OrderListController

@synthesize orderType = _orderType;
@synthesize sectionStat = _sectionStat;

- (void)dealloc
{
    [_sectionStat release];
    [super dealloc];
}

- (id)initWithOrderType:(int)orderType
{
    if (self = [super init]) {
        self.orderType = orderType;
        self.sectionStat = [[[NSMutableArray alloc] init] autorelease];
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.title = @"订单详情";
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set navigation bar buttons
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"咨询") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    
    if ([[UserManager defaultManager] isLogin]) {
        [[OrderService defaultService] findOrderUsingLoginId:[[UserManager defaultManager] loginId] 
                                                       token:[[UserManager defaultManager] token] 
                                                   orderType:_orderType 
                                                    delegate:self];
    }else {
        [[OrderService defaultService] findOrderUsingUserId:[[UserManager defaultManager] getUserId] 
                                                  orderType:_orderType
                                                   delegate:self];
    }
}
-(void)clickConsult:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in [[AppManager defaultManager] getServicePhoneList]){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[[[AppManager defaultManager] getServicePhoneList] count]];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    [UIUtils makeCall:[[[AppManager defaultManager] getServicePhoneList] objectAtIndex:buttonIndex]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataList count];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 * [[_sectionStat objectAtIndex:section] boolValue];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCell getCellIdentifier]];
    if (cell == nil) {
        cell = [OrderCell createCell:self];   
    }
    
    OrderCell *orderCell = (OrderCell *)cell;
    orderCell.delegate = self;

	[orderCell setCellData:[dataList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [OrderCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_HEADER_VIEW;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerViewWithFrame:CGRectMake(0, 0, 302, HEIGHT_HEADER_VIEW) forSection:section];
}

#define HEIGHT_IMAGE_VIEW 8
#define WIDTH_IMAGE_VIEW 8
- (UIView *)headerViewWithFrame:(CGRect)frame forSection:(NSInteger)section
{
    UIButton *view = [[[UIButton alloc] initWithFrame:frame] autorelease];
    
    [view addTarget:self action:@selector(clickSectionHeaderView:) forControlEvents:UIControlEventTouchUpInside];
    view.tag = section;
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    bgImageView.tag = TAG_HEADER_VIEW_BG_IMAGE_VIEW;
    
    if (section >=1 && section == [dataList count] -1 && [[_sectionStat objectAtIndex:section] boolValue] == YES) {
        bgImageView.image = [[ImageManager defaultManager] orderListHeaderView:(section-1) rowCount:[dataList count]];
    }else {
        bgImageView.image = [[ImageManager defaultManager] orderListHeaderView:section rowCount:[dataList count]];
    }
    [view addSubview:bgImageView];
    [bgImageView release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, HEIGHT_HEADER_VIEW/2-HEIGHT_IMAGE_VIEW/2+1, WIDTH_IMAGE_VIEW, HEIGHT_IMAGE_VIEW)];
    imageView.image = [[ImageManager defaultManager] orangePoint];
    [view addSubview:imageView];
    [imageView release];
    
    UILabel *routeIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, 160, HEIGHT_HEADER_VIEW)];
    routeIdLabel.font = [UIFont systemFontOfSize:15];
    routeIdLabel.backgroundColor = [UIColor clearColor];
    int orderId = [[dataList objectAtIndex:section] orderId];
    routeIdLabel.text = [NSString stringWithFormat:NSLS(@"订单编号：%d"), orderId];
    [view addSubview:routeIdLabel];
    [routeIdLabel release];
    
    UILabel *bookDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, HEIGHT_HEADER_VIEW)] autorelease];
    NSDate *bookDate = [NSDate dateWithTimeIntervalSince1970:[[dataList objectAtIndex:section] bookDate]];
    bookDateLabel.backgroundColor = [UIColor clearColor];
    bookDateLabel.font = [UIFont systemFontOfSize:15];
    bookDateLabel.text = dateToStringByFormat(bookDate, @"MM月dd日");
    bookDateLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    [view addSubview:bookDateLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, HEIGHT_HEADER_VIEW/2-22/2, 22, 22)];
    arrowImageView.image = [[ImageManager defaultManager] arrowImage];
    [view addSubview:arrowImageView];
    [arrowImageView release];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)findRequestDone:(int)resultCode
                   list:(NSArray *)list
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络弱，暂时无法获取订单列表") title:nil];
        return;
    }
    
    if ([list count] == 0) {
        [self showTipsOnTableView:NSLS(@"您没有下过订单")];
        return;
    }
    
    [self updateSectionStatWithSectionCount:[list count]];
    self.dataList = list;

    [dataTableView reloadData];
}

- (void)updateSectionStatWithSectionCount:(int)sectionCount
{
    [_sectionStat removeAllObjects];
    for (int i = 0; i < sectionCount; i++) {
        [_sectionStat addObject:[NSNumber numberWithBool:YES]];
    }
}

- (void)clickSectionHeaderView:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL open = [self isSectionOpen:button.tag];
    
    [self setSection:button.tag Open:!open];
}

- (BOOL)isSectionOpen:(NSInteger)section
{
    if ([_sectionStat count] > section) {
        return [[_sectionStat objectAtIndex:section] boolValue];
    }
    
    return NO;
}

- (void)setSection:(NSInteger)section Open:(BOOL)open
{
    if ([_sectionStat count] > section) {
        [_sectionStat removeObjectAtIndex:section];
        NSNumber *num = [NSNumber numberWithBool:open];
        [_sectionStat insertObject:num atIndex:section];
        
        [self.dataTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }    
}


- (void)didClickRouteDetail:(int)routeId
{
    CommonRouteDetailController *controller = [[CommonRouteDetailController alloc] initWithRouteId:routeId routeType:[self routeType]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (int)routeType
{
    int routeType = 0;
    switch (_orderType) {
        case OBJECT_LIST_PACKAGE_TOUR_ORDER:
            routeType = OBJECT_LIST_ROUTE_PACKAGE_TOUR;
            break;
            
        case OBJECT_LIST_UNPACKAGE_TOUR_ORDER:
            routeType = OBJECT_LIST_ROUTE_UNPACKAGE_TOUR;
            break;
            
        case OBJECT_LIST_SELF_GUIDE_TOUR_ORDER:
            routeType = OBJECT_LIST_ROUTE_SELF_GUIDE_TOUR;
            break;
            
        default:
            break;
    }
    
    return routeType;
}




- (void)didClickRouteFeekback:(int)routeId
{
    RouteFeekbackController *controller = [[RouteFeekbackController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
