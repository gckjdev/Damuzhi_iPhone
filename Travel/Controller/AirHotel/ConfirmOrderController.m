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
#import "UPPayPluginUtil.h"
#import "AirHotelOrderDetailController.h"
#import "TravelNetworkConstants.h"

@interface ConfirmOrderController ()

@property (retain, nonatomic) AirHotelOrder_Builder *airHotelOrderBuilder;
@property (retain, nonatomic) NSMutableArray *airOrderBuilders;
@property (retain, nonatomic) NSMutableArray *hotelOrderBuilders;
@property (retain, nonatomic) NSIndexPath *currentIndexPath;
@property (assign, nonatomic) BOOL isMember;
@property (retain, nonatomic) Person *contactPerson;
@property (assign, nonatomic) int departCityId;
@property (retain, nonatomic) AirHotelOrder *resultOrder;
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
{
    PPDebug(@"orderDone result:%d, resultInfo:%@, orderId:%d", result, resultInfo, orderId);
    [self hideActivity];
    if (result == 0) {
        [self popupMessage:NSLS(@"预订成功") title:nil];
        
        [_airOrderBuilders removeAllObjects];
        [_hotelOrderBuilders removeAllObjects];
        [self clearPersons];
        
        [[AirHotelService defaultService] findOrder:orderId delegate:self];
    } else {
        [self setOrderData];
        [self popupMessage:NSLS(@"预订失败") title:nil];
    }
}

- (void)findOrderDone:(int)result order:(AirHotelOrder *)order
{
    self.resultOrder = order;
    if (result == 0) {
        if (order.orderStatus == StatusUnpaid) {//未支付
            [self showActivity];
            [[AirHotelService defaultService] findOrderPaymentInfo:order.orderId delegate:self];
        } else {
            AirHotelOrderDetailController *controller = [[AirHotelOrderDetailController alloc] initWithOrder:order];
            controller.isPopToRoot = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}

- (void)findOrderPaymentInfoDone:(int)result paymentInfo:(NSString *)paymentInfo
{
    [self hideActivity];
    
    if (result == 0) {
        [self showActivityWithText:NSLS(@"请在30分钟内完成支付，正在跳转支付页面")];
        [NSTimer scheduledTimerWithTimeInterval: 2.0
                                         target: self
                                       selector: @selector(handleTimer:)
                                       userInfo: paymentInfo
                                        repeats: NO];
    } else {
        [self popupMessage:NSLS(@"查找支付信息错误") title:nil];
    }
}

- (void)handleTimer:(NSTimer *)aTimer
{
    [self hideActivity];
    NSString *paymentInfo = (NSString *)[aTimer userInfo];
    [UPPayPluginUtil test:paymentInfo SystemProvide:UNION_PAY_SYSTEM_PROVIDE SPID:UNION_PAY_AP_ID withViewController:self Delegate:self];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [MakeOrderHeader getHeaderViewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MakeOrderHeader *header = [MakeOrderHeader createHeaderView];
    if (section == SECTION_AIR && [_airOrderBuilders count] > 0) {
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

- (void)updatePrice
{
    AirHotelManager *manager = [AirHotelManager defaultManager];
    double airPrice = [manager calculateAirTotalPrice:_airOrderBuilders];
    double hotelPrice = [manager calculateHotelTotalPrice:_hotelOrderBuilders];
    self.airPirceLabel.text = [PriceUtils priceToStringCNY:airPrice];
    self.hotelPriceLabel.text = [PriceUtils priceToStringCNY:hotelPrice];
    
    double shouldPayPrice = airPrice;
    if ([[AppManager defaultManager] isChinaCity:[[AppManager defaultManager] getCurrentCityId]]) {
        self.hotelPayModeLabel.text = NSLS(@"到店支付");
    } else {
        shouldPayPrice += hotelPrice;
        self.hotelPayModeLabel.text = NSLS(@"在线支付");
    }
    
    if (shouldPayPrice == 0) {
        self.shouldPayPriceHolderView.hidden = YES;
    } else {
        self.shouldPayPriceHolderView.hidden = NO;
    }
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
            [_contactPersonButton setTitle:[NSString stringWithFormat:@"%@，%@",_contactPerson.name,_contactPerson.phone] forState:UIControlStateNormal];
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
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark UPPayPluginDelegate
-(void)UPPayPluginResult:(NSString*)result
{
    //success、fail、cancel
    PPDebug(@"UPPayPluginResult:%@", result);
    
    if ([result isEqualToString:@"success"]) {
        [[AirHotelService defaultService] findOrder:_resultOrder.orderId delegate:self];
    } else {
        AirHotelOrderDetailController *controller = [[AirHotelOrderDetailController alloc] initWithOrder:_resultOrder];
        controller.isPopToRoot = YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

@end
