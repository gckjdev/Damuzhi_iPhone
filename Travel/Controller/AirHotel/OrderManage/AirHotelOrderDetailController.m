//
//  AirHotelOrderDetailController.m
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "AirHotelOrderDetailController.h"
#import "AirHotelOrderDetailTopCell.h"
#import "AirHotel.pb.h"
#import "FontSize.h"
#import "PlaceService.h"
#import "CommonPlaceDetailController.h"
#import "CommonWebController.h"
#import "AirHotelManager.h"
#import "PriceUtils.h"
#import "TimeUtils.h"
#import "AppUtils.h"

@interface AirHotelOrderDetailController ()
@property (retain, nonatomic) AirHotelOrder *airHotelOrder;
@property (assign, nonatomic) int unionPayOrderNumber;
@end

@implementation AirHotelOrderDetailController

- (void)dealloc
{
    [_airHotelOrder release];
    [_footerView release];
    [_shouldPayPriceLabel release];
    [_payButton release];
    [_priceTitleLabel release];
    [super dealloc];
}

- (id)initWithOrder:(AirHotelOrder *)airHotelOrder
{
    self = [super init];
    if (self) {
        self.airHotelOrder = airHotelOrder;
    }
    return self;
}

#define MARK_TOP_SECTON     @"top"
#define MARK_AIR_SECTION    @"air"
#define MARK_HOTEL_SECTION  @"hotel"
- (void)setDefaultData
{
    double totalPrice = 0;
    if ([self hasAir:_airHotelOrder]) {
        totalPrice += _airHotelOrder.airPrice;
    }
    
    if (_airHotelOrder.hotelPaymentMode == PaymentModeOnline) {
        totalPrice += _airHotelOrder.hotelPrice;
    }
    
    self.shouldPayPriceLabel.text = [PriceUtils priceToStringCNY:totalPrice];
    
    
    
    if (_airHotelOrder.orderStatus != StatusUnpaid) {
        self.payButton.hidden = YES;
        self.priceTitleLabel.textAlignment = NSTextAlignmentRight;
        self.shouldPayPriceLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.payButton.hidden = NO;
        self.priceTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.shouldPayPriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    //set dataList
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    [mutableArray addObject:MARK_TOP_SECTON];
    if ([self hasAir:_airHotelOrder]) {
        [mutableArray addObject:MARK_AIR_SECTION];
    }
    if ([self hasHotel:_airHotelOrder]) {
        [mutableArray addObject:MARK_HOTEL_SECTION];
    }
    self.dataList = mutableArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"机票订单详情");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
    
    [self setDefaultData];
}

- (void)clickBack:(id)sender
{
    if (_isPopToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)hasAir:(AirHotelOrder *)order
{
    if ([[order airOrdersList] count] > 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)hasHotel:(AirHotelOrder *)order
{
    if ([[order hotelOrdersList] count] > 0)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [dataList objectAtIndex:indexPath.row];
    if ([mark isEqualToString:MARK_TOP_SECTON]) {
        NSString *identifier = [AirHotelOrderDetailTopCell getCellIdentifier];
        AirHotelOrderDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [AirHotelOrderDetailTopCell createCell:self];
        }
        [cell setCellWithOrder:_airHotelOrder];
        return cell;
    }
    
    else if ([mark isEqualToString:MARK_AIR_SECTION]){
        NSString *identifier = [AirOrderDetailCell getCellIdentifier];
        AirOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [AirOrderDetailCell createCell:self];
        }
        [cell setCellWithOrther:_airHotelOrder];
        return cell;
    }
    
    else if ([mark isEqualToString:MARK_HOTEL_SECTION]){
        NSString *identifier = [HotelOrderDetailCell getCellIdentifier];
        HotelOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [HotelOrderDetailCell createCell:self];
        }
        [cell setCellWithOrther:_airHotelOrder];
        return cell;
    }
    
    return nil;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [dataList objectAtIndex:indexPath.row];
    if ([mark isEqualToString:MARK_TOP_SECTON]) {
        return [AirHotelOrderDetailTopCell getCellHeight:_airHotelOrder];
    }
    
    else if ([mark isEqualToString:MARK_AIR_SECTION]){
        return [AirOrderDetailCell getCellHeight:_airHotelOrder];
    }
    
    else if ([mark isEqualToString:MARK_HOTEL_SECTION]){
        return [HotelOrderDetailCell getCellHeight:_airHotelOrder];
    }
    
    return 0;
}

#pragma mark -
#pragma OrderHotelViewDelegate method
- (void)didClickHotelButton:(int)hotelId
{
    [self showActivityWithText:NSLS(@"数据加载中...")];
    [[PlaceService defaultService] findPlace:hotelId viewController:self];
}


- (void)findRequestDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
                  place:(Place *)place
{    [self hideActivity];
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
#pragma mark OrderFlightViewDelegate method
- (void)didClickRescheduleButton:(NSString *)url
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:url];
    controller.navigationItem.title = NSLS(@"退改签详情");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)viewDidUnload {
    [self setFooterView:nil];
    [self setShouldPayPriceLabel:nil];
    [self setPayButton:nil];
    [self setPriceTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)clickPayButton:(id)sender {
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    if (nowTimeInterval - [AppUtils standardTimeFromBeijingTime:_airHotelOrder.orderDate] > 30 * 60) {
        UIAlertView *theAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLS(@"订单已取消，请重新提交订单") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [theAlertView show];
        [theAlertView release];
        return;
    }
    
    [self showActivityWithText:NSLS(@"正在获取交易流水号...")];
    [[AirHotelService defaultService] findPaySerialNumber:_airHotelOrder.orderId
                                                  delegate:self];
}

#pragma mark -
#pragma mark AirHotelServiceDelegate method
- (void)findPaySerialNumberDone:(int)result
                     resultInfo:(NSString *)resultInfo
                   serialNumber:(NSString *)serialNumber
                    orderNumber:(int)orderNumber
{
    [self hideActivity];
    if (result == 0) {
        NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
        int remainMinute = (30 * 60 - (nowTimeInterval - [AppUtils standardTimeFromBeijingTime:_airHotelOrder.orderDate]) ) / 60;
        if (remainMinute == 0) {
            remainMinute = 1;
        } else if (remainMinute > 30) {
            remainMinute = 30;
        }
        
        self.unionPayOrderNumber = orderNumber;
        PayView *payView = [PayView createPayView];
        [payView show:[NSString stringWithFormat:@"请在%d分钟内完成支付", remainMinute]
         serialNumber:serialNumber
           controller:self
             delegate:self];
    } else {
        [self popupMessage:NSLS(@"获取交易流水号错误") title:nil];
    }
}

- (void)findOrderDone:(int)result order:(AirHotelOrder *)order
{
    [self hideActivity];
    if (result == 0) {
        self.airHotelOrder = order;
        [self setDefaultData];
        [self.dataTableView reloadData];
        
        if ([_delegate respondsToSelector:@selector(didUpdateOrder:)]) {
            [_delegate didUpdateOrder:order];
        }
    }
}

#pragma mark -
#pragma mark UPPayPluginDelegate
//-(void)UPPayPluginResult:(NSString*)result
//{
//    //value is @"success" or @"fail" or @"cancel"
//    
//    PPDebug(@"UPPayPluginResult:%@", result);
//    if ([result isEqualToString:@"success"]) {
//        //for test query pay result
//        [[AirHotelService defaultService] queryPayOrder:_unionPayOrderNumber];
//        
//        [self showActivityWithText:NSLS(@"已经完成支付，正在刷新订单...")];
//        [NSTimer scheduledTimerWithTimeInterval:1.0
//                                         target:self
//                                       selector:@selector(handleTimer:)
//                                       userInfo:nil
//                                        repeats:NO];
//    } else if ([result isEqualToString:@"fail"]){
//        [self popupMessage:NSLS(@"支付失败") title:nil];
//    } else if ([result isEqualToString:@"cancel"]){
//        [self popupMessage:NSLS(@"已取消支付") title:nil];
//    }
//}

- (void)handleTimer:(id)sender
{
    [[AirHotelService defaultService] findOrder:_airHotelOrder.orderId delegate:self];
}

#pragma mark -
#pragma UmpayDelegate methods
- (void)onPayResult:(NSString*)orderId
         resultCode:(NSString*)resultCode
      resultMessage:(NSString*)resultMessage
{
    PPDebug(@"onPayResult orderId:%@ resultCode:%@ resultMessage:%@", orderId, resultCode, resultMessage);
    
    if ([resultCode isEqualToString:@"0000"]) {
        [self showActivityWithText:NSLS(@"已经完成支付，正在刷新订单...")];
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(handleTimer:)
                                       userInfo:nil
                                        repeats:NO];
    } else if ([resultCode isEqualToString:@"1002"]){
        [self popupMessage:NSLS(@"支付失败") showSeconds:2];
    } else if ([resultCode isEqualToString:@"1001"]){
        [self popupMessage:NSLS(@"已取消支付") showSeconds:2];
    }
}

@end
