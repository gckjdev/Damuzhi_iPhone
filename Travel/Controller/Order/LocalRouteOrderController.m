//
//  LocalRouteOrderController.m
//  Travel
//
//  Created by haodong on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteOrderController.h"
#import "NSDate+TKCategory.h"
#import "TKCalendarMonthView.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "ImageManager.h"
#import "UserManager.h"
#import "LoginController.h"
#import "TravelNetworkConstants.h"
#import "OrderListController.h"
#import "FontSize.h"
#import "RouteUtils.h"

@interface LocalRouteOrderController ()

@property (assign, nonatomic) int adult;
@property (assign, nonatomic) int children;
@property (retain, nonatomic) LocalRoute *route;
@property (retain, nonatomic) NSMutableArray *selectedAdultIdList;
@property (retain, nonatomic) NSMutableArray *selectedChildrenIdList;
@property (retain, nonatomic) NSDate *departDate;
@property (retain, nonatomic) NonMemberOrderController *nonMemberOrderController;
@property (retain, nonatomic) NSArray *phoneList;
@property (retain, nonatomic) Booking *selectedBooking;

- (void)setDirectionsCell:(PlaceOrderCell *)cell;
- (void)clickDepartDateButton;
- (void)clickAdultButton;
- (void)clickChildrenButton;
- (void)clickMemberBookButton;
- (void)clickNonMemberBookButton;

@end

#define TITLE_ROUTE_NAME    NSLS(@"线路名称 :")
//#define TITLE_DEPART_PLACE  NSLS(@"出发地点 :")
#define TITLE_DEPART_DATE   NSLS(@"出发日期 :")
#define TITLE_PEOPLE_NUMBER NSLS(@"出游人数 :")
#define TITLE_PRICE         NSLS(@"参考价格 :")
#define TITLE_DIRECTIONS    NSLS(@"说明:")

#define DEPARTDATA_TEXT_COLOR [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0]

@implementation LocalRouteOrderController
@synthesize adult = _adult;
@synthesize children = _children;
@synthesize route = _route;
@synthesize selectedAdultIdList = _selectedAdultIdList;
@synthesize selectedChildrenIdList = _selectedChildrenIdList;
@synthesize departDate = _departDate;
@synthesize nonMemberOrderController = _nonMemberOrderController;
@synthesize phoneList = _phoneList;
@synthesize selectedBooking = _selectedBooking;

- (void)dealloc
{
    PPRelease(_route);
    PPRelease(_selectedAdultIdList);
    PPRelease(_selectedChildrenIdList);
    PPRelease(_departDate);
    PPRelease(_phoneList);
    PPRelease(_nonMemberOrderController);
    PPRelease(_selectedBooking);
    [super dealloc];
}


- (id)initWithRoute:(LocalRoute *)route 
{
    if (self = [super init]) {
        self.route = route;
        self.selectedAdultIdList = [[[NSMutableArray alloc] init] autorelease];
        self.selectedChildrenIdList = [[[NSMutableArray alloc] init] autorelease];
        self.adult = 1;
        self.children = 0;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"线路预订";
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询")
                          fontSize:FONT_SIZE 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    self.phoneList = [NSArray arrayWithObjects:_route.contactPhone, nil];
    [self.selectedAdultIdList addObject:[NSNumber numberWithInt:_adult]];
    [self.selectedChildrenIdList addObject:[NSNumber numberWithInt:_children]];
    
    NSArray *mutableArray = [NSArray arrayWithObjects:TITLE_ROUTE_NAME, TITLE_DEPART_DATE, TITLE_PEOPLE_NUMBER, TITLE_PRICE, TITLE_DIRECTIONS,nil];

    self.dataList = mutableArray;
}


-(void)clickConsult:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for(NSString* title in self.phoneList){
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:NSLS(@"返回")];
    [actionSheet setCancelButtonIndex:[self.phoneList count]];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    [UIUtils makeCall:[self.phoneList objectAtIndex:buttonIndex]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellTitle = [dataList objectAtIndex:indexPath.row];
    if ([cellTitle isEqualToString:TITLE_DIRECTIONS]) {
        return 130;
    }else {
        return [PlaceOrderCell getCellHeight];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count] ;
}

#define BUTTON_WIDTH_DEPART_PLACE   170
#define BUTTON_WIDTH_DEPART_DATE    170
#define BUTTON_HEIGHT_DEPART_DATE   28
#define BUTTON_WIDTH_PEOPLE         74

#define BUTTON_WIDTH_BOOK           130
#define BUTTON_HEIGHT_BOOK          27
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [PlaceOrderCell getCellIdentifier];
    PlaceOrderCell *cell = (PlaceOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [PlaceOrderCell createCell:self];
    }
    [cell setCellWithIndexPath:indexPath];
    
    cell.pointImageView.hidden = NO;
    cell.titleLabel.hidden = NO;
    cell.contentLabel.hidden = NO;
    cell.leftButton.hidden = YES;
    cell.rightButton.hidden = YES;
    cell.pointImageView.image = [UIImage imageNamed:@"line_p1.png"];
    cell.contentLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1];
    
    NSString *cellTitle = [dataList objectAtIndex:indexPath.row];
    cell.titleLabel.text = cellTitle;
    
    if ([cellTitle isEqualToString:TITLE_ROUTE_NAME]) {
        cell.pointImageView.image = [UIImage imageNamed:@"line_p2.png"];
        cell.contentLabel.text = _route.name;
        cell.contentLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:47.0/255.0 blue:67.0/255.0 alpha:1];
    }
    else if ([cellTitle isEqualToString:TITLE_DEPART_DATE]) {
        cell.leftButton.hidden = NO;
        [cell.leftButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        CGRect departFrame = cell.leftButton.frame;
        cell.leftButton.frame = CGRectMake(departFrame.origin.x, departFrame.origin.y, BUTTON_WIDTH_DEPART_DATE, departFrame.size.height);
        
        if (_departDate) {
            [cell.leftButton setTitle:dateToChineseString(_departDate) forState:UIControlStateNormal];
            [cell.leftButton setTitleColor:DEPARTDATA_TEXT_COLOR forState:UIControlStateNormal];
        } else {
            [cell.leftButton setTitle:NSLS(@"请选择出发日期") forState:UIControlStateNormal];
        }
        
    }
    else if ([cellTitle isEqualToString:TITLE_PEOPLE_NUMBER]) {
        cell.contentLabel.hidden = YES;
        cell.leftButton.hidden = NO;
        cell.rightButton.hidden = NO;
        [cell.leftButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        [cell.leftButton setTitleColor:DEPARTDATA_TEXT_COLOR forState:UIControlStateNormal];
        [cell.rightButton setTitleColor:DEPARTDATA_TEXT_COLOR forState:UIControlStateNormal];
        
        [cell.leftButton setTitle:[NSString stringWithFormat:NSLS(@"成人%d位"), _adult] forState:UIControlStateNormal];
        [cell.rightButton setTitle:[NSString stringWithFormat:NSLS(@"儿童%d位"), _children] forState:UIControlStateNormal]; 
    }
    else if ([cellTitle isEqualToString:TITLE_PRICE]){
        if (_selectedBooking == nil && [_route.bookingsList count] > 0 ) {
            self.selectedBooking = [_route.bookingsList objectAtIndex:0];
        }
        int money = _selectedBooking.childrenPrice * _children + _selectedBooking.adultPrice * _adult;
        
        cell.contentLabel.text = [NSString stringWithFormat:@"%@%d",_route.currency, money];
        
        cell.contentLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:48.0/255.0 blue:25.0/255.0 alpha:1];
    }
    else if ([cellTitle isEqualToString:TITLE_DIRECTIONS]){
        [self setDirectionsCell:cell];
    }
    
    return cell;
}



- (void)setDirectionsCell:(PlaceOrderCell *)cell
{
    cell.pointImageView.hidden = YES;
    cell.leftButton.hidden = NO;
    cell.rightButton.hidden = NO;
    
    CGRect bookFrame =  CGRectMake(16, 12, BUTTON_WIDTH_BOOK, BUTTON_HEIGHT_BOOK);
    cell.leftButton.frame = bookFrame;
    cell.rightButton.frame = CGRectOffset(bookFrame, bookFrame.size.width + 8, 0);
    [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"line_btn1.png"] forState:UIControlStateNormal];
    [cell.rightButton setBackgroundImage:[UIImage imageNamed:@"line_btn1.png"] forState:UIControlStateNormal];
    
    cell.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cell.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cell.leftButton setTitle:NSLS(@"会员确认预订") forState:UIControlStateNormal];
    [cell.rightButton setTitle:NSLS(@"非会员确认预订") forState:UIControlStateNormal];
    
    if ([[UserManager defaultManager]isLogin]) {
        cell.rightButton.hidden = YES;
        cell.leftButton.center = CGPointMake(160, cell.leftButton.center.y);
        cell.titleLabel.hidden = YES;
    }
    
    [cell.leftButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.rightButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    cell.leftButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    cell.rightButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    cell.leftButton.contentEdgeInsets = UIEdgeInsetsZero;
    cell.rightButton.contentEdgeInsets = UIEdgeInsetsZero;
    
    [cell.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGRect directionsFrame = CGRectMake(14, 54, 274, 60);
    cell.contentLabel.frame = directionsFrame;
    cell.contentLabel.text = NSLS(@"说明:\n预订成功后，系统将会发送短信通知您订单预订情况，稍后客服会通过电话联系您确认订单。");
    cell.contentLabel.font = [UIFont systemFontOfSize:13];
    cell.contentLabel.textColor = [UIColor colorWithRed:95.0/255.0 green:95.0/255.0 blue:95.0/255.0 alpha:1];
    cell.contentLabel.numberOfLines = 0;
}


#pragma mark - PlaceOrderCellDelegate methods
- (void)didClickLeftButton:(NSIndexPath *)aIndexPath
{
    NSString *cellTitle = [dataList objectAtIndex:aIndexPath.row];
    if ([cellTitle isEqualToString:TITLE_DEPART_DATE]) {
        [self clickDepartDateButton];
    }
    else if([cellTitle isEqualToString:TITLE_PEOPLE_NUMBER]){
        [self clickAdultButton];
    }
    else if ([cellTitle isEqualToString:TITLE_DIRECTIONS])
    {
        [self clickMemberBookButton];
    }
}


- (void)didClickRightButton:(NSIndexPath *)aIndexPath
{
    NSString *cellTitle = [dataList objectAtIndex:aIndexPath.row];
    if([cellTitle isEqualToString:TITLE_PEOPLE_NUMBER]){
        [self clickChildrenButton];
    } 
    else if ([cellTitle isEqualToString:TITLE_DIRECTIONS])
    {
        [self clickNonMemberBookButton];
    }
}


#pragma button actions
- (void)clickDepartDateButton
{
    PPDebug(@"clickDepartDateButton count:%d", [_route.bookingsList count]);
    
    //_route.currency;
    
    MonthViewController *controller = [[[MonthViewController alloc] initWithBookings:_route.bookingsList currency:_route.currency] autorelease];
    [controller.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    controller.aBgView.backgroundColor = [UIColor colorWithRed:220/255. green:219/255. blue:223/255.0 alpha:1];
    controller.aDelegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)clickAdultButton
{
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildAdultItemList]  
                                                           selectedItemIds:_selectedAdultIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    controller.cellTextColor = DEPARTDATA_TEXT_COLOR;
    
     [UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)clickChildrenButton
{
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildChildrenItemList]  
                                                           selectedItemIds:_selectedChildrenIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    controller.cellTextColor = DEPARTDATA_TEXT_COLOR;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)clickMemberBookButton
{
    if (_departDate == nil) {
        [self popupMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    if (![[UserManager defaultManager] isLogin]) {
        LoginController *controller = [[LoginController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        return;
    }
    
    NSString *message = NSLS(@"是否预订？");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLS(@"确定") otherButtonTitles:NSLS(@"取消"),nil];
    [alert show];
    [alert release];
    
}






//- (void) alertView:(UIAlertView *)alertView1 clickedButtonAtIndex:(NSInteger)buttonIndex    //wrong
- (void)alertView:(UIAlertView *)alertView1 didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    NSString * str1 = [alertView1 buttonTitleAtIndex:buttonIndex];
    NSString * str2 = [NSString stringWithFormat:@"确定"];
    
    
    if ([str1 isEqualToString: str2]) 
    {  
        UserManager *manager = [UserManager defaultManager];
        OrderService *service = [OrderService defaultService];
        
        [service localRouteOrderUsingLoginId:[manager loginId]  
                                       token:[manager token] 
                                     routeId:_route.routeId  
                               departPlaceId:0
                                  departDate:_departDate 
                                       adult:_adult 
                                    children:_children 
                               contactPerson:nil 
                                   telephone:nil 
                                    delegate:self];
    }
}



- (void)clickNonMemberBookButton
{
    
    if (_departDate == nil) {
        [self popupMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    if (_nonMemberOrderController == nil) {
        NonMemberOrderController *controller = [[NonMemberOrderController alloc] initWithLocalRoute:_route 
                                                                                          routeType:OBJECT_LIST_LOCAL_ROUTE 
                                                                                      departPlaceId:0 
                                                                                         departDate:_departDate 
                                                                                              adult:_adult 
                                                                                           children:_children];
        self.nonMemberOrderController = controller;
        [controller release];

    }
    [self.navigationController pushViewController:_nonMemberOrderController animated:YES];
}


- (DepartPlace *)findDepartPlace:(int)departPlaceId
{
    for (DepartPlace *departPlace in _route.departPlacesList) {
        if (departPlace.departPlaceId == departPlaceId) {
            return departPlace;
        }
    }
    
    return nil;
}

#pragma mark - MonthViewControllerDelegate methods
- (void)didSelecteDate:(NSDate *)date
{
    self.departDate = date;
    self.selectedBooking = [RouteUtils bookingOfDate:date bookings:_route.bookingsList];
    [dataTableView reloadData];
}

#pragma mark - SelectControllerDelegate
- (void)didSelectFinish:(NSArray*)selectedItems
{
    self.adult = [[_selectedAdultIdList objectAtIndex:0] intValue];
    self.children = [[_selectedChildrenIdList objectAtIndex:0] intValue];
    [dataTableView reloadData];
}


#pragma mark - OrderServiceDelegate methods
- (void)placeOrderDone:(int)resultCode result:(int)result reusultInfo:(NSString *)resultInfo
{
    if (resultCode == 0) {
        if ( result == 0) {;
            [self popupMessage:NSLS(@"已成功提交意向订单") title:nil];
            
            OrderListController *controller = [[OrderListController alloc] initWithOrderType:OBJECT_LIST_LOCAL_ROUTE_ORDER];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            
        } else {
            [self popupMessage:resultInfo title:nil];
        }
    }else {
        [self popupMessage:NSLS(@"网络弱，请稍后再试") title:nil];
    }
}



@end
