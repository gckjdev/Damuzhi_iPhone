//
//  PlaceOrderController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PlaceOrderController.h"
#import "NSDate+TKCategory.h"
#import "TKCalendarMonthView.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "ImageManager.h"
#import "UserManager.h"
#import "LoginController.h"
#import "TravelNetworkConstants.h"


@interface PlaceOrderController ()

@property (assign, nonatomic) int routeType;
@property (assign, nonatomic) int adult;
@property (assign, nonatomic) int children;
@property (assign, nonatomic) int packageId;
@property (retain, nonatomic) TouristRoute *route;
@property (retain, nonatomic) NSMutableArray *selectedAdultIdList;
@property (retain, nonatomic) NSMutableArray *selectedChildrenIdList;
@property (retain, nonatomic) NSDate *departDate;
@property (retain, nonatomic) NonMemberOrderController *nonMemberOrderController;
@property (retain, nonatomic) NSArray *phoneList;

- (void)setDirectionsCell:(PlaceOrderCell *)cell;
- (void)clickDepartDateButton;
- (void)clickAdultButton;
- (void)clickChildrenButton;
- (void)clickMemberBookButton;
- (void)clickNonMemberBookButton;

@end


#define TITLE_ROUTE_NAME    NSLS(@"线路名称 :")
#define TITLE_ROUTE_ID      NSLS(@"线路编号 :")
#define TITLE_PACKAGE_ID    NSLS(@"套餐编号 :")
#define TITLE_DEPART_CITY   NSLS(@"出发城市 :")
#define TITLE_DEPART_DATE   NSLS(@"出发日期 :")
#define TITLE_PEOPLE_NUMBER NSLS(@"出游人数 :")
#define TITLE_PRICE         NSLS(@"参考价格 :")
#define TITLE_DIRECTIONS    NSLS(@"说明:")

@implementation PlaceOrderController

@synthesize routeType = _routeType;
@synthesize adult = _adult;
@synthesize children = _children;
@synthesize packageId = _packageId;
@synthesize route = _route;
@synthesize selectedAdultIdList = _selectedAdultIdList;
@synthesize selectedChildrenIdList = _selectedChildrenIdList;
@synthesize departDate = _departDate;
@synthesize nonMemberOrderController = _nonMemberOrderController;
@synthesize phoneList = _phoneList;

- (void)dealloc
{
    PPRelease(_route);
    PPRelease(_selectedAdultIdList);
    PPRelease(_selectedChildrenIdList);
    PPRelease(_departDate);
    PPRelease(_phoneList);
    [super dealloc];
}


- (id)initWithRoute:(TouristRoute *)route 
          routeType:(int)routeType
          packageId:(int)packageId
{
    if (self = [super init]) {
        self.route = route;
        self.routeType = routeType;
        self.packageId = packageId;
        self.selectedAdultIdList = [NSMutableArray array];
        self.selectedChildrenIdList = [NSMutableArray array];
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
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"咨询") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickConsult:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    self.phoneList = [NSArray arrayWithObjects:_route.contactPhone, nil];
    [_selectedAdultIdList addObject:[NSNumber numberWithInt:_adult]];
    [_selectedChildrenIdList addObject:[NSNumber numberWithInt:_children]];
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:TITLE_ROUTE_NAME, TITLE_ROUTE_ID, TITLE_PACKAGE_ID, TITLE_DEPART_CITY, TITLE_DEPART_DATE, TITLE_PEOPLE_NUMBER, TITLE_PRICE, TITLE_DIRECTIONS,nil];
    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        [mutableArray removeObject:TITLE_PACKAGE_ID];
    }
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


#define BUTTON_WIDTH_DEPART_DATE    130
#define BUTTON_HEIGHT_DEPART_DATE   28
#define BUTTON_WIDTH_PEOPLE         74
#define BUTTON_HEIGHT_PEOPLE        28
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
    else if ([cellTitle isEqualToString:TITLE_ROUTE_ID]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"%d" ,_route.routeId]; 
    }
    else if ([cellTitle isEqualToString:TITLE_PACKAGE_ID]){
        cell.contentLabel.text = [NSString stringWithFormat:@"%d" ,_packageId]; 
    }
    else if ([cellTitle isEqualToString:TITLE_DEPART_CITY])
    {
        cell.contentLabel.text = [[AppManager defaultManager] getDepartCityName:_route.departCityId];
    }
    else if ([cellTitle isEqualToString:TITLE_DEPART_DATE]) {
        cell.contentLabel.hidden = YES;
        cell.leftButton.hidden = NO;
        [cell.leftButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        CGRect departFrame = cell.leftButton.frame;
        cell.leftButton.frame = CGRectMake(departFrame.origin.x, departFrame.origin.y, BUTTON_WIDTH_DEPART_DATE, departFrame.size.height);
        [cell.leftButton setTitle:dateToChineseString(_departDate) forState:UIControlStateNormal];
    }
    else if ([cellTitle isEqualToString:TITLE_PEOPLE_NUMBER]) {
        cell.contentLabel.hidden = YES;
        cell.leftButton.hidden = NO;
        cell.rightButton.hidden = NO;
        [cell.leftButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        [cell.rightButton setBackgroundImage:[[ImageManager defaultManager] selectDownImage] forState:UIControlStateNormal];
        
        [cell.leftButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"成人%d位"), _adult]] forState:UIControlStateNormal];
        [cell.rightButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:NSLS(@"儿童%d位"), _children]] forState:UIControlStateNormal]; 
    }
    else if ([cellTitle isEqualToString:TITLE_PRICE]){
        cell.contentLabel.text = _route.price;
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
    MonthViewController *controller = [[[MonthViewController alloc] initWithBookings:_route.bookingsList routeType:_routeType] autorelease];   
    [controller.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    controller.aBgView.backgroundColor = [UIColor colorWithRed:220/255. green:219/255. blue:223/255.0 alpha:1];
    controller.aDelegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)clickAdultButton
{
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildAdultItemList]  selectedItemIds:_selectedAdultIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)clickChildrenButton
{
    SelectController *controller = [[SelectController alloc] initWithTitle:NSLS(@"出游人数")
                                                                  itemList:[[AppManager defaultManager] buildChildrenItemList]  selectedItemIds:_selectedChildrenIdList
                                                              multiOptions:NO 
                                                               needConfirm:NO 
                                                             needShowCount:NO];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)clickMemberBookButton
{
    
    if (_departDate == nil) {
        [self popupMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    UserManager *manager = [UserManager defaultManager];
    if ([[UserManager defaultManager] isLogin]) {
        OrderService *service = [OrderService defaultService];
        [service placeOrderUsingLoginId:[manager loginId] 
                                  token:[manager token]
                                routeId:_route.routeId 
                              packageId:_packageId
                             departDate:_departDate
                                  adult:_adult 
                               children:_children 
                          contactPerson:nil
                              telephone:nil
                               delegate:self];
    } else {
        LoginController *controller  = [[LoginController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


- (void)clickNonMemberBookButton
{
    
    if (_departDate == nil) {
        [self popupMessage:NSLS(@"请选择出发日期") title:nil];
        return;
    }
    
    if (_nonMemberOrderController == nil) {
        NonMemberOrderController *controller = [[NonMemberOrderController alloc] initWithRoute:_route 
                                                                                    departDate:_departDate 
                                                                                         adult:_adult 
                                                                                      children:_children];
        controller.delegate = self;
        self.nonMemberOrderController = controller;
        [controller release];
    }
    
    [self.navigationController pushViewController:_nonMemberOrderController animated:YES];
}


#pragma mark - MonthViewControllerDelegate methods
- (void)didSelecteDate:(NSDate *)date
{
    self.departDate = date;
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
        if ( result == 0) {
            [self popupMessage:NSLS(@"预订成功") title:nil];
        } else {
            [self popupMessage:resultInfo title:nil];
        }
    }else {
        [self popupMessage:NSLS(@"网络弱，请稍后再试") title:nil];
    }
}


#pragma mark - NonMemberOrderDelegate
- (void)didclickSubmit:(NSString *)contactPerson telephone:(NSString *)telephone
{
    UserManager *manager = [UserManager defaultManager];
    
    OrderService *service = [OrderService defaultService];
    [service placeOrderUsingUserId:[manager getUserId]  
                           routeId:_route.routeId  
                         packageId:_packageId 
                        departDate:_departDate 
                             adult:_adult 
                          children:_children 
                     contactPerson:contactPerson 
                         telephone:telephone 
                          delegate:self];
}


@end
