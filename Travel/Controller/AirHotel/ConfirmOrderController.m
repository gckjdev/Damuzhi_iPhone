//
//  ConfirmOrderController.m
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "ConfirmOrderController.h"
#import "FontSize.h"
#import "AirHotel.pb.h"
#import "MakeOrderHeader.h"
#import "AirHotelManager.h"
#import "UserManager.h"
#import "CommonWebController.h"
#import "PriceUtils.h"
#import "CreditCardManager.h"
#import "AppManager.h"
#import "CommonPlaceDetailController.h"

@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *airHotelOrderBuilder;
@property (retain, nonatomic) NSMutableArray *airOrderBuilders;
@property (retain, nonatomic) NSMutableArray *hotelOrderBuilders;
@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) BOOL isMember;
@property (retain, nonatomic) Person *contactPerson;
@property (retain, nonatomic) PaymentInfo *paymentInfo;
@property (assign, nonatomic) int departCityId;
@end

@implementation ConfirmOrderController

- (void)dealloc
{
    [_airHotelOrderBuilder release];
    [_airOrderBuilders release];
    [_hotelOrderBuilders release];
    [_currentIndexPath release];
    [_contactPersonButton release];
    [_paymentButton release];
    [_airPirceLabel release];
    [_hotelPriceLabel release];
    [_contactPerson release];
    [_paymentInfo release];
    [super dealloc];
}

- (id)initWithAirOrderBuilders:(NSMutableArray *)airOrderBuilders
            hotelOrderBuilders:(NSMutableArray *)hotelOrderBuilders
                  departCityId:(int)departCityId
                      isMember:(BOOL)isMember
{
    self = [super init];
    if (self) {
        self.airOrderBuilders = airOrderBuilders;
        self.hotelOrderBuilders = hotelOrderBuilders;
        self.departCityId = departCityId;
        self.isMember = isMember;
        [self setOrderData];
    }
    return self;
}

- (void)setOrderData
{
    self.airHotelOrderBuilder = [[[AirHotelOrder_Builder alloc] init] autorelease];
    
    AirHotelManager *manager = [AirHotelManager defaultManager];
    
    NSArray *airOrderList = [manager airOrderListFromBuilderList:_airOrderBuilders];
    NSArray *hotelOrderList = [manager hotelOrderListFromBuilderList:_hotelOrderBuilders];
    
    [self.airOrderBuilders removeAllObjects];
    [self.airOrderBuilders addObjectsFromArray:[manager airOrderBuilderListFromOrderList:airOrderList]];
    
    [self.hotelOrderBuilders removeAllObjects];
    [self.hotelOrderBuilders addObjectsFromArray:[manager hotelOrderBuilderListFromOrderList:hotelOrderList]];
    
    //clear value
    [_airHotelOrderBuilder clearAirOrdersList];
    [_airHotelOrderBuilder clearHotelOrdersList];
    [_airHotelOrderBuilder clearArriveCityId];
    [_airHotelOrderBuilder clearLoginId];
    [_airHotelOrderBuilder clearToken];
    [_airHotelOrderBuilder clearUserId];
    
    //set value
    [_airHotelOrderBuilder addAllAirOrders:airOrderList];
    [_airHotelOrderBuilder addAllHotelOrders:hotelOrderList];
    [_airHotelOrderBuilder setDepartCityId:_departCityId];
    [_airHotelOrderBuilder setArriveCityId:[[AppManager defaultManager] getCurrentCityId]];
    if (_isMember) {
        [_airHotelOrderBuilder setLoginId:[[UserManager defaultManager] loginId]];
        [_airHotelOrderBuilder setToken:[[UserManager defaultManager] token]];
    } else {
        [_airHotelOrderBuilder setUserId:[[UserManager defaultManager] getUserId]];
    }
    
    [_airHotelOrderBuilder setContactPerson:_contactPerson];
    [_airHotelOrderBuilder setPaymentInfo:_paymentInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"确认预订");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
    [self updatePrice];
}

- (void)clickBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)clickOrderButton:(id)sender {
    if ([_airOrderBuilders count] == 0 && [_hotelOrderBuilders count] == 0) {
        [self popupMessage:NSLS(@"没有制定任何订单") title:nil];
        return;
    }
    
    for (AirOrder_Builder *builder in _airOrderBuilders) {
        if ([[builder passengerList] count] == 0 ) {
            [self popupMessage:NSLS(@"没有添加登机人") title:nil];
            return;
        }
    }
    
    for (HotelOrder_Builder *builder in _hotelOrderBuilders) {
        if ([[builder checkInPersonsList] count] == 0) {
            [self popupMessage:NSLS(@"没有添加入住人") title:nil];
            return;
        }
    }
    
    if ([_airHotelOrderBuilder hasContactPerson] == NO) {
        [self popupMessage:NSLS(@"没有选择联系人") title:nil];
        return;
    }
    
    if ([_airHotelOrderBuilder hasPaymentInfo] == NO) {
        [self popupMessage:NSLS(@"没有选择支付方式") title:nil];
        return;
    }
    
    [self setOrderData];
        
    NSString *message = NSLS(@"是否预订？");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle: NSLS(@"取消")otherButtonTitles:NSLS(@"确定"),nil];
    [alert show];
    [alert release];
    
    //for test
//    AirHotelOrderListController *controller = [[[AirHotelOrderListController alloc] init] autorelease];
//    controller.isPopToRoot = YES;
//    controller.delegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
    //controller.dataList = [NSArray arrayWithObjects:order, nil];
}

#pragma mark -
#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)theAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == theAlertView.cancelButtonIndex) {
        return;
    } else{
        AirHotelOrder *order = [_airHotelOrderBuilder build];
        [self showActivityWithText:NSLS(@"正在预订...")];
        [[AirHotelService defaultService] order:order delegate:self];
    }
}

#pragma mark - 
#pragma AirHotelServiceDelegate methods
- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo
{
    PPDebug(@"orderDone result:%d, resultInfo:%@", result, resultInfo);
    [self hideActivity];
    if (result == 0) {
        [self popupMessage:NSLS(@"预订成功") title:nil];
        
        [_airOrderBuilders removeAllObjects];
        [_hotelOrderBuilders removeAllObjects];
        
        AirHotelOrderListController *controller = [[[AirHotelOrderListController alloc] init] autorelease];
        controller.delegate = self;
        controller.isPopToRoot = YES;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self setOrderData];
        [self popupMessage:NSLS(@"预订失败") title:nil];
    }
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_airOrderBuilders count]) {
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:indexPath.section];
        
        CGFloat height = [ConfirmAirCell getCellHeight:[builder.passengerList count]];
        return  height;
    } else {
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [_airOrderBuilders count]];
        CGFloat height = [ConfirmHotelCell getCellHeight:builder];
        return height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [MakeOrderHeader getHeaderViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];
    if (section < [_airOrderBuilders count]) {
        [header setViewWithDelegate:nil
                            section:section
                 airHotelHeaderType:AirHeader
                 isHideFilterButton:YES
                selectedButtonIndex:0
                  isHideCloseButton:YES
                            isClose:YES
                 isHideDeleteButton:YES];
    } else {
        [header setViewWithDelegate:nil
                            section:section
                 airHotelHeaderType:HotelHeader
                 isHideFilterButton:YES
                selectedButtonIndex:0
                  isHideCloseButton:YES
                            isClose:YES
                 isHideDeleteButton:YES];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    return footer;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_airOrderBuilders count] + [_hotelOrderBuilders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_airOrderBuilders count]) {
        NSString *identifier = [ConfirmAirCell getCellIdentifier];
        ConfirmAirCell *cell = (ConfirmAirCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmAirCell createCell:self];
        }
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:indexPath.section];
        [cell setCellWithAirOrderBuilder:builder indexPath:indexPath];
        
        return cell;
    } else{
        NSString *identifier = [ConfirmHotelCell getCellIdentifier];
        ConfirmHotelCell *cell = (ConfirmHotelCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmHotelCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [_airOrderBuilders count]];
        [cell setCellWith:builder indexPath:indexPath];
        return cell;
    }
}

- (IBAction)clickContactPersonButton:(id)sender {
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypeContact
                                                                           selectCount:1
                                                                              delegate:self
                                                                                 title:NSLS(@"联系人选择")
                                                                              isSelect:YES
                                                                              isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickPaymentButton:(id)sender {
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypeCreditCard
                                                                           selectCount:1
                                                                              delegate:self
                                                                                 title:NSLS(@"信用卡支付")
                                                                              isSelect:YES
                                                                              isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updatePrice
{
    AirHotelManager *manager = [AirHotelManager defaultManager];
    
    self.airPirceLabel.text = [manager calculateAirTotalPrice:_airOrderBuilders];
    self.hotelPriceLabel.text = [manager calculateHotelTotalPrice:_hotelOrderBuilders];
}


#pragma mark -
#pragma ConfirmAirCellDelegate method
- (void)didClickInsuranceButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected
{
    if (indexPath.section < [_airOrderBuilders count]) {
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:indexPath.section];
        [builder setInsurance:isSelected];
        [dataTableView reloadData];
    }
}

- (void)didClickSendTicketButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected
{
    if (indexPath.section < [_airOrderBuilders count]) {
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:indexPath.section];
        [builder setSendTicket:isSelected];
        [dataTableView reloadData];
    }
}

- (void)didClickPassengerButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypePassenger selectCount:100 delegate:self title:NSLS(@"选择登机人") isSelect:YES isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickRescheduleButton:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_airOrderBuilders count]) {
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:indexPath.section];
        
        NSString *url = nil;
        for (FlightSeat *seat in builder.flight.flightSeatsList) {
            if ([seat.code isEqualToString:builder.flightSeatCode]) {
                url = seat.reschedule;
                break;
            }
        }
        
        CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:url];
        controller.navigationItem.title = NSLS(@"退改签详情");
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark -
#pragma ConfirmHotelCellDelegate method
- (void)didClickCheckInPersonButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [_airOrderBuilders count]];
    int totalCount = 0;
    for (HotelOrderRoomInfo *info in builder.roomInfosList) {
        totalCount += info.count;
    }
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypeCheckIn selectCount:totalCount delegate:self title:NSLS(@"入住人选择") isSelect:YES isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickShowHotelDetailButton:(NSIndexPath *)indexPath
{
    HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [_airOrderBuilders count]];
    
    [self showActivityWithText:NSLS(@"数据加载中...")];
    [[PlaceService defaultService] findPlace:builder.hotelId viewController:self];
}

#pragma mark -
#pragma PlaceServiceDelegate method
- (void)findRequestDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place
{
    [self hideActivity];
    if (resultCode != 0) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    
    CommonPlaceDetailController *controller = [[[CommonPlaceDetailController alloc] initWithPlace:place] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma SelectPersonControllerDelegate method
- (void)finishSelectPerson:(SelectPersonViewType)personType objectList:(NSArray *)objectList
{
    if (personType == ViewTypeContact) {
        if ([objectList count] > 0) {
            Person *person = (Person *)[objectList objectAtIndex:0];
            self.contactPerson = person;
            
            [_contactPersonButton setTitleColor:[UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_contactPersonButton setTitle:[NSString stringWithFormat:@"%@，%@",_contactPerson.name,_contactPerson.phone] forState:UIControlStateNormal];
        }
    } else if (personType == ViewTypeCreditCard) {
        if ([objectList count] > 0) {
            CreditCard *creditCard = (CreditCard *)[objectList objectAtIndex:0];
            
            PaymentInfo_Builder *pib = [[[PaymentInfo_Builder alloc] init] autorelease];
            [pib setPaymentType:PaymentTypeCreditCard];
            [pib setCreditCard:creditCard];
            PaymentInfo *paymentInfo = [pib build];
            self.paymentInfo = paymentInfo;
            
            [_paymentButton setTitleColor:[UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_paymentButton setTitle:NSLS(@"信用卡") forState:UIControlStateNormal];
        }
    } else if (personType == ViewTypeCheckIn) {
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:_currentIndexPath.section - [_airOrderBuilders count]];
        [builder clearCheckInPersonsList];
        [builder addAllCheckInPersons:objectList];
    } else if (personType == ViewTypePassenger) {
        AirOrder_Builder *builder = [_airOrderBuilders objectAtIndex:_currentIndexPath.section];
        [builder clearPassengerList];
        [builder addAllPassenger:objectList];
    }
}

#pragma mark -
#pragma AirHotelOrderListControllerDelegate method
- (void)didClickBackButton
{
    
}

- (void)viewDidUnload {
    [self setContactPersonButton:nil];
    [self setPaymentButton:nil];
    [self setAirPirceLabel:nil];
    [self setHotelPriceLabel:nil];
    [super viewDidUnload];
}

@end
