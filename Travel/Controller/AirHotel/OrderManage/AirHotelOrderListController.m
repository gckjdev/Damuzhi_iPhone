//
//  AirHotelOrderListController.m
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "AirHotelOrderListController.h"
#import "UserManager.h"
#import "AirHotel.pb.h"
#import "AirHotelOrderListCell.h"
#import "FontSize.h"

#import "PriceUtils.h"
#import "TimeUtils.h"

@interface AirHotelOrderListController ()
@property (retain, nonatomic) NSMutableArray *orderList;
@end

@implementation AirHotelOrderListController

- (void)dealloc
{
    [_orderList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLS(@"机+酒订单");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.view.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:239.0/255.0 blue:247.0/255.0 alpha:1];
    
    [self findOrderList];
}

- (void)clickBack:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didClickBackButton)]) {
        [_delegate didClickBackButton];
    }
    
    if (_isPopToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)findOrderList
{
    [self showActivityWithText:NSLS(@"数据加载中...")];
    
    if ([[UserManager defaultManager] isLogin]) {
        [[AirHotelService defaultService] findOrdersUsingLoginId:[[UserManager defaultManager] loginId] token:[[UserManager defaultManager] token] delegate:self];
    } else {
        [[AirHotelService defaultService] findOrdersUsingUserId:[[UserManager defaultManager] getUserId] delegate:self];
    }
}

- (void)debugData
{
    for (AirHotelOrder *order in _orderList) {
        PPDebug(@"*********************");
        PPDebug(@"orderId:%d", order.orderId);
        PPDebug(@"orderStatus:%d", order.orderStatus);
//        PPDebug(@"depart cityId:%d", order.departCityId);
//        PPDebug(@"arrive cityId:%d", order.arriveCityId);
//        PPDebug(@"contactPerson name:%@", order.contactPerson.name);
//        PPDebug(@"contactPerson phone:%@", order.contactPerson.phone);
//        PPDebug(@"airOrders count:%d", [order.airOrdersList count]);
//        PPDebug(@"hotelOrders count:%d", [order.hotelOrdersList count]);
//        PPDebug(@"hotel totalPrice:%@", [PriceUtils priceToStringCNY:order.hotelPrice]);
//        
//        for (HotelOrder *hotelOrder in order.hotelOrdersList) {
//            NSDate *checkIndDate = [NSDate dateWithTimeIntervalSince1970:hotelOrder.checkInDate];
//            NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:hotelOrder.checkOutDate];
//            PPDebug(@"hotel checkIn:%@", dateToChineseStringByFormat(checkIndDate, @"yyyy-MM-dd"));
//            PPDebug(@"hotel checkOut:%@", dateToChineseStringByFormat(checkOutDate, @"yyyy-MM-dd"));
//            
//            PPDebug(@"hotel hotelId:%d", hotelOrder.hotelId);
//            PPDebug(@"hotel name:%@", hotelOrder.hotel.name);
//            PPDebug(@"hotel roomInfosCount:%d", [hotelOrder.roomInfosList count]);
//            
//            for (HotelRoom *room in hotelOrder.hotel.roomsList) {
//                PPDebug(@"roomId:%d", room.roomId);
//                PPDebug(@"roomName:%@", room.name);
//            }
//            
//            for (HotelOrderRoomInfo *info in hotelOrder.roomInfosList) {
//                PPDebug(@"selectedRoomId:%d", info.roomId);
//                PPDebug(@"selectedRoomCount:%d", info.count);
//            }
//        }
        
        for (AirOrder *airOrder in order.airOrdersList) {

        }
    }
}

#pragma mark - 
#pragma AirHotelServiceDelegate methods
- (void)findOrdersDone:(int)result orderList:(NSArray *)orderList
{
    [self hideActivity];
    [self hideTipsOnTableView];
    if (result == 0 && [orderList count] > 0) {
        self.orderList = [NSMutableArray arrayWithArray:orderList];
        [dataTableView reloadData];
    }else{
        [self showTipsOnTableView:@"没有找到您预订的机+酒订单"];
    }
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_orderList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [AirHotelOrderListCell getCellIdentifier];
    AirHotelOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [AirHotelOrderListCell createCell:self];
    }
    AirHotelOrder *order = [_orderList objectAtIndex:indexPath.row];
    
    [cell setCellWithOrder:order];
    
    return cell;
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirHotelOrder *order = [_orderList objectAtIndex:indexPath.row];
    return [AirHotelOrderListCell getCellHeight:order] + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AirHotelOrder *order = [_orderList objectAtIndex:indexPath.row];
    AirHotelOrderDetailController *controller = [[[AirHotelOrderDetailController alloc] initWithOrder:order] autorelease];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma AirHotelOrderDetailControllerDelegate methods
- (void)didUpdateOrder:(AirHotelOrder *)order
{
    int index = 0;
    for (AirHotelOrder *oneOrder in _orderList) {
        if (order.orderId == oneOrder.orderId) {
            break;
        }
        index ++;
    }
    
    [_orderList removeObjectAtIndex:index];
    [_orderList insertObject:order atIndex:index];
    [dataTableView reloadData];
}

@end
