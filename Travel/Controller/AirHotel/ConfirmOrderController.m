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
#import "PersonManager.h"
#import "AirHotelOrderDetailController.h"
#import "PayView.h"
#import "PersonsView.h"

@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *airHotelOrderBuilder;
@property (retain, nonatomic) NSMutableArray *airOrderBuilders;
@property (retain, nonatomic) NSMutableArray *hotelOrderBuilders;
@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) BOOL isMember;
@property (retain, nonatomic) Person *contactPerson;
@property (assign, nonatomic) int departCityId;
@property (retain, nonatomic) AirHotelOrder *resultOrder;
@property (assign, nonatomic) int resultOrderId;

@property (assign, nonatomic) int unionPayOrderNumber;
@end

@implementation ConfirmOrderController

- (void)dealloc
{
    [_airHotelOrderBuilder release];
    [_airOrderBuilders release];
    [_hotelOrderBuilders release];
    [_currentIndexPath release];
    [_contactPersonButton release];
    [_airPirceLabel release];
    [_hotelPriceLabel release];
    [_contactPerson release];
    [_airPriceHolderView release];
    [_hotelPriceHolderView release];
    [_shouldPayPriceLabel release];
    [_resultOrder release];
    [_hotelPayModeLabel release];
    [_shouldPayPriceHolderView release];
    [_orderButton release];
    [_passengerHolderView release];
    [_passengerButton release];
    [_contactHolderView release];
    [_footerView release];
    [_insuranceLabel release];
    [_sendTicketLabel release];
    [_insuranceButton release];
    [_sendTicketButton release];
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
        
        for (AirOrder_Builder *builder in _airOrderBuilders) {
            [builder clearPassengerList];
        }
        
        for (HotelOrder_Builder *builder in _hotelOrderBuilders) {
            [builder clearCheckInPersonsList];
        }
        
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
    [_airHotelOrderBuilder clearContactPerson];
    [_airHotelOrderBuilder clearAirPaymentMode];
    [_airHotelOrderBuilder clearHotelPaymentMode];
    [_airHotelOrderBuilder clearOrderType];
    
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
    
    if (_contactPerson) {
        [_airHotelOrderBuilder setContactPerson:_contactPerson];
    }
    
    if ([airOrderList count] > 0) {
        [_airHotelOrderBuilder setAirPaymentMode:PaymentModeOnline];
    }
    
    //机票
    [_airHotelOrderBuilder setOrderType:OrderTypeAir];
}

#define SECTION_AIR 0
- (NSUInteger)getAirSectionCount
{
    if ([_airOrderBuilders count] > 0) {
        return 1;
    }
    return 0;
}

#define FRAME_PRICE_HOLDER_VIEW CGRectMake(0, 12, 302, 30);
- (void)updateSite
{
    if ([_airOrderBuilders count] == 0) {
        self.airPriceHolderView.hidden = YES;
        self.hotelPriceHolderView.frame = FRAME_PRICE_HOLDER_VIEW;
    }
    
    if ([_hotelOrderBuilders count] == 0) {
        self.airPriceHolderView.frame = FRAME_PRICE_HOLDER_VIEW
        self.hotelPriceHolderView.hidden = YES;
    }
}

-(void)updateOrderButton
{
    if ([_airOrderBuilders count] > 0 ||
        ([_hotelOrderBuilders count] > 0 && [self isChinaHotel] == NO)) {
        [self.orderButton setTitle:NSLS(@"提交订单并支付") forState:UIControlStateNormal];
    } else {
        [self.orderButton setTitle:NSLS(@"确认提交订单") forState:UIControlStateNormal];
    }
    
    if ([_hotelOrderBuilders count] == 0) {
        self.airPriceHolderView.frame = FRAME_PRICE_HOLDER_VIEW
        self.hotelPriceHolderView.hidden = YES;
    }
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
    
    [self updateSite];
    [self updateOrderButton];
    [self updateFooterView];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
    [self updatePrice];
}

- (void)clickBack:(id)sender
{
    [self clearPersons];
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
    
    if (_contactPerson == nil) {
        [self popupMessage:NSLS(@"没有选择联系人") title:nil];
        return;
    }
    
    [self setOrderData];
        
    NSString *message = NSLS(@"是否预订？");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle: NSLS(@"取消")otherButtonTitles:NSLS(@"确定"),nil];
    [alert show];
    [alert release];
}

- (void)clearPersons
{
    if (_isMember == NO) {
        [[PersonManager defaultManager:PersonTypePassenger isMember:NO] deleteAllPersons];
        [[PersonManager defaultManager:PersonTypeCheckIn isMember:NO] deleteAllPersons];
        [[PersonManager defaultManager:PersonTypeContact isMember:NO] deleteAllPersons];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods
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
#pragma mark AirHotelServiceDelegate methods
- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo
          orderId:(int)orderId
          needPay:(BOOL)needPay
{
    PPDebug(@"orderDone result:%d, resultInfo:%@, orderId:%d", result, resultInfo, orderId);
    [self hideActivity];
    
    self.resultOrderId = orderId;
    if (result == 0) {        
        [_airOrderBuilders removeAllObjects];
        [_hotelOrderBuilders removeAllObjects];
        [self clearPersons];
        
        if (needPay) {
            [self showActivityWithText:NSLS(@"正在获取交易流水号...")];
            [[AirHotelService defaultService] findPaySerialNumber:orderId delegate:self];
        } else {
            [self showActivityWithText:NSLS(@"正在生成订单...")];
            [[AirHotelService defaultService] findOrder:orderId delegate:self];
        }
    } else {
        [self setOrderData];
        [self popupMessage:NSLS(@"预订失败") title:nil];
    }
}

- (void)findOrderDone:(int)result order:(AirHotelOrder *)order
{
    [self hideActivity];
    self.resultOrder = order;
    if (result == 0) {
        AirHotelOrderDetailController *controller = [[AirHotelOrderDetailController alloc] initWithOrder:_resultOrder];
        controller.isPopToRoot = YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

- (void)findPaySerialNumberDone:(int)result
                     resultInfo:(NSString *)resultInfo
                   serialNumber:(NSString *)serialNumber
                    orderNumber:(int)orderNumber
{
    [self hideActivity];
    
    if (result == 0) {
        self.unionPayOrderNumber = orderNumber;
        PayView *payView = [PayView createPayView];
        [payView show:NSLS(@"订单提交成功，请在30分钟内完成支付")
         serialNumber:serialNumber
           controller:self
             delegate:self];
    } else {
        [self popupMessage:NSLS(@"获取交易流水号失败") title:nil];
        [self showActivityWithText:NSLS(@"正在生成订单...")];
        [[AirHotelService defaultService] findOrder:_resultOrderId delegate:self];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR  && [_airOrderBuilders count] > 0) {
        CGFloat height = [ConfirmAirCell getCellHeight:_airOrderBuilders];
        return  height;
    } else {
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [self getAirSectionCount]];
        CGFloat height = [ConfirmHotelCell getCellHeight:builder];
        return height;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [MakeOrderHeader getHeaderViewHeight];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];
//    if (section == SECTION_AIR && [_airOrderBuilders count] > 0) {
//        [header setViewWithDelegate:nil
//                            section:section
//                 airHotelHeaderType:AirHeader
//                 isHideFilterButton:YES
//                selectedButtonIndex:0
//                  isHideCloseButton:YES
//                            isClose:YES
//                 isHideDeleteButton:YES];
//    } else {
//        [header setViewWithDelegate:nil
//                            section:section
//                 airHotelHeaderType:HotelHeader
//                 isHideFilterButton:YES
//                selectedButtonIndex:0
//                  isHideCloseButton:YES
//                            isClose:YES
//                 isHideDeleteButton:YES];
//    }
//    return header;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footer = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//    return footer;
//}

#pragma mark - 
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self getAirSectionCount] + [_hotelOrderBuilders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_AIR  && [_airOrderBuilders count] > 0) {
        NSString *identifier = [ConfirmAirCell getCellIdentifier];
        ConfirmAirCell *cell = (ConfirmAirCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmAirCell createCell:self];
        }
        [cell setCellWithAirOrderBuilders:_airOrderBuilders indexPath:indexPath];
        
        return cell;
    } else{
        NSString *identifier = [ConfirmHotelCell getCellIdentifier];
        ConfirmHotelCell *cell = (ConfirmHotelCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [ConfirmHotelCell createCell:self];
        }
        
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [self getAirSectionCount]];
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

- (BOOL)isChinaHotel
{
    return [[AppManager defaultManager] isChinaCity:[[AppManager defaultManager] getCurrentCityId]];
}

- (void)updatePrice
{
    AirHotelManager *manager = [AirHotelManager defaultManager];
    double airPrice = [manager calculateAirTotalPrice:_airOrderBuilders];
    double hotelPrice = [manager calculateHotelTotalPrice:_hotelOrderBuilders];
    self.airPirceLabel.text = [PriceUtils priceToStringCNY:airPrice];
    self.hotelPriceLabel.text = [PriceUtils priceToStringCNY:hotelPrice];
    
    double shouldPayPrice = airPrice;
    if ([self isChinaHotel]) {
        self.hotelPayModeLabel.text = NSLS(@"到店支付");
    } else {
        shouldPayPrice += hotelPrice;
        self.hotelPayModeLabel.text = NSLS(@"在线支付");
    }
    
//    if (shouldPayPrice == 0) {
//        self.shouldPayPriceHolderView.hidden = YES;
//    } else {
//        self.shouldPayPriceHolderView.hidden = NO;
//    }
    self.shouldPayPriceLabel.text = [PriceUtils priceToStringCNY:shouldPayPrice];
}


#pragma mark -
#pragma mark ConfirmAirCellDelegate method
- (void)didClickInsuranceButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected
{
    for (AirOrder_Builder *builder in _airOrderBuilders) {
        [builder setInsurance:isSelected];
    }
    [self updatePrice];
}

- (void)didClickSendTicketButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected
{
    for (AirOrder_Builder *builder in _airOrderBuilders) {
        [builder setSendTicket:isSelected];
    }
    [self updatePrice];
}

- (void)didClickPassengerButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypePassenger selectCount:100 delegate:self title:NSLS(@"选择登机人") isSelect:YES isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark OrderFlightViewDelegate method
- (void)didClickRescheduleButton:(NSString *)url
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:url];
    controller.navigationItem.title = NSLS(@"退改签详情");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -
#pragma mark ConfirmHotelCellDelegate method
- (void)didClickCheckInPersonButton:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [self getAirSectionCount]];
    int totalCount = 0;
    for (HotelOrderRoomInfo *info in builder.roomInfosList) {
        totalCount += info.count;
    }
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypeCheckIn selectCount:totalCount delegate:self title:NSLS(@"入住人选择") isSelect:YES isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didClickShowHotelDetailButton:(NSIndexPath *)indexPath
{
    HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:indexPath.section - [self getAirSectionCount]];
    
    [self showActivityWithText:NSLS(@"数据加载中...")];
    [[PlaceService defaultService] findPlace:builder.hotelId viewController:self];
}

#pragma mark -
#pragma mark PlaceServiceDelegate method
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
#pragma mark SelectPersonControllerDelegate method
- (void)finishSelectPerson:(SelectPersonViewType)personType objectList:(NSArray *)objectList
{
    if (personType == ViewTypeContact) {
        if ([objectList count] > 0) {
            Person *person = (Person *)[objectList objectAtIndex:0];
            self.contactPerson = person;
            
            [_contactPersonButton setTitleColor:[UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_contactPersonButton setTitle:[NSString stringWithFormat:@"%@ , %@",_contactPerson.name,_contactPerson.phone] forState:UIControlStateNormal];
        }
    } else if (personType == ViewTypeCreditCard) {
        
    } else if (personType == ViewTypeCheckIn) {
        HotelOrder_Builder *builder = [_hotelOrderBuilders objectAtIndex:_currentIndexPath.section - [self getAirSectionCount]];
        [builder clearCheckInPersonsList];
        [builder addAllCheckInPersons:objectList];
    } else if (personType == ViewTypePassenger) {
        for (AirOrder_Builder *builder in _airOrderBuilders) {
            [builder clearPassengerList];
            [builder addAllPassenger:objectList];
        }
        [self updateFooterView];
    }
}

- (void)viewDidUnload {
    [self setContactPersonButton:nil];
    [self setAirPirceLabel:nil];
    [self setHotelPriceLabel:nil];
    [self setAirPriceHolderView:nil];
    [self setHotelPriceHolderView:nil];
    [self setShouldPayPriceLabel:nil];
    [self setHotelPayModeLabel:nil];
    [self setShouldPayPriceHolderView:nil];
    [self setOrderButton:nil];
    [self setPassengerHolderView:nil];
    [self setPassengerButton:nil];
    [self setContactHolderView:nil];
    [self setFooterView:nil];
    [self setInsuranceLabel:nil];
    [self setSendTicketLabel:nil];
    [self setInsuranceButton:nil];
    [self setSendTicketButton:nil];
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString*)result
{
    //for test query pay result
    [[AirHotelService defaultService] queryPayOrder:_unionPayOrderNumber];
    
    //success、fail、cancel
    PPDebug(@"UPPayPluginResult:%@", result);
    [self showActivityWithText:NSLS(@"正在生成订单...")];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(handleTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)handleTimer:(id)sender
{
    [[AirHotelService defaultService] findOrder:_resultOrderId delegate:self];
}

#define PLACE_TOP_PERSONS   8
- (void)updateFooterView
{
    //set persons
    for(UIView *subview in [self.passengerHolderView subviews]) {
        if ([subview isKindOfClass:[PersonsView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    AirOrder_Builder *oneBuilder = nil;
    if ([_airOrderBuilders count] > 0) {
        oneBuilder = [_airOrderBuilders objectAtIndex:0];
    }
    
    PersonsView *personsView = [PersonsView createCheckInPersonLabels:oneBuilder.passengerList type:PersonListTypePassenger];
    personsView.frame = CGRectMake(0, PLACE_TOP_PERSONS, personsView.frame.size.width, personsView.frame.size.height);
    
    [self.passengerHolderView insertSubview:personsView belowSubview:_passengerButton];
    
    //set frame
    CGFloat y = 10;
    self.passengerHolderView.frame = CGRectMake(_passengerHolderView.frame.origin.x, y, _passengerHolderView.frame.size.width, personsView.frame.size.height + 2*PLACE_TOP_PERSONS);
    y += _passengerHolderView.frame.size.height;
    self.contactHolderView.frame = CGRectMake(_contactHolderView.frame.origin.x, y, _contactHolderView.frame.size.width, _contactHolderView.frame.size.height);
    
    self.footerView.frame = CGRectMake(_footerView.frame.origin.x, _footerView.frame.origin.y, _footerView.frame.size.width, y + _contactHolderView.frame.size.height + 10);
    self.dataTableView.tableFooterView = _footerView;
    
    //set value
    if ([oneBuilder.passengerList count] > 0) {
        [self.passengerButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.passengerButton setTitle:@"添加登机人" forState:UIControlStateNormal];
    }
    
    self.insuranceLabel.text = [NSString stringWithFormat:@"%@/份", [PriceUtils priceToStringCNY:oneBuilder.flight.insuranceFee]];
    self.sendTicketLabel.text = [NSString stringWithFormat:@"报销凭证(快递费%@元)",[PriceUtils priceToString:oneBuilder.flight.sendTicketFee]];
    
    self.insuranceButton.selected = oneBuilder.insurance;
    self.sendTicketButton.selected = oneBuilder.sendTicket;
}

- (IBAction)clickPassengerButton:(id)sender {
    
    SelectPersonController *controller = [[[SelectPersonController alloc] initWithType:ViewTypePassenger selectCount:100 delegate:self title:NSLS(@"选择登机人") isSelect:YES isMember:_isMember] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickInsuranceButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    for (AirOrder_Builder *builder in _airOrderBuilders) {
        [builder setInsurance:button.selected];
    }
    [self updatePrice];
}

- (IBAction)clicksendTicketButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    for (AirOrder_Builder *builder in _airOrderBuilders) {
        [builder setSendTicket:button.selected];
    }
    [self updatePrice];
}

@end
