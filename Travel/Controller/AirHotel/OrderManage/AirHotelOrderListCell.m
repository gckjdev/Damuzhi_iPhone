//
//  AirHotelOrderListCell.m
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "AirHotelOrderListCell.h"
#import "AirHotel.pb.h"
#import "LocaleUtils.h"
#import "AirHotelManager.h"
#import "LogUtil.h"
#import "PriceUtils.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "RoomInfoView.h"

@interface AirHotelOrderListCell()
@property (retain, nonatomic) AirHotelOrder *airHotelOrder;
@property (retain, nonatomic) AirOrder *airOrder;
@property (retain, nonatomic) HotelOrder *hotelOrder;
@end

@implementation AirHotelOrderListCell

- (void)dealloc {
    [_airHotelOrder release];
    [_airOrder release];
    [_hotelOrder release];
    
    [_orderIdLabel release];
    [_orderStatusLabel release];
    [_flightTypeLabel release];
    [_flightDateLabel release];
    [_planeTypeLabel release];
    [_seatLabel release];
    [_departAirportLabel release];
    [_airlineAndFlightNumberLabel release];
    [_departTimeLabel release];
    [_arriveTimeLabel release];
    [_arriveAirportLabel release];
    [_hotelNameLabel release];
    [_hotelPriceLabel release];
    [_hotelDateLabel release];
    [_airPriceLabel release];
    [_airHolderView release];
    [_hotelHolderView release];
    [_arrowImageView release];
    [_roomInfoHolderView release];
    [_middleSolidLineView release];
    [_middleDottedLineImageView release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"AirHotelOrderListCell";
}

#define HEIGHT_TOP  39

+ (CGFloat)getCellHeight:(AirHotelOrder *)order
{
    return HEIGHT_TOP + [self getAirHeight:order] + [self getHotelHeight:order];
}

#define HEIGHT_AIR  88
+ (CGFloat)getAirHeight:(AirHotelOrder *)order
{
    if ([order.airOrdersList count] > 0) {
        return HEIGHT_AIR;
    }
    return 0;
}

+ (CGFloat)getHotelHeight:(AirHotelOrder *)order
{
    if ([order.hotelOrdersList count] > 0) {
        HotelOrder *hotelOrder = [order.hotelOrdersList objectAtIndex:0];
        return 88 +  [RoomInfoView getHeight:hotelOrder.roomInfosList] - 25;
    }
    return 0;
}

- (void)updateHeader
{
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%d",self.airHotelOrder.orderId];
    
    AirHotelManager *manager = [AirHotelManager defaultManager];
    self.orderStatusLabel.text = [manager orderStatusName:self.airHotelOrder.orderStatus];
    self.orderStatusLabel.textColor = [manager orderStatusColor:self.airHotelOrder.orderStatus];
}

- (void)updateAirView
{
    if (_airOrder.flightType == 1 || _airOrder.flightType == 3
        ) {
        self.flightTypeLabel.text = NSLS(@"去程");
    } else {
        self.flightTypeLabel.text = NSLS(@"返程");
    }
    self.flightDateLabel.text = [[AirHotelManager defaultManager] dateIntToYearMonthDayWeekString2:_airOrder.flightDate];
    self.airPriceLabel.text = [PriceUtils priceToStringCNY:_airHotelOrder.airPrice];
    
    NSString *ariLine = [[AppManager defaultManager] getAirlineName:_airOrder.flight.airlineId];
    self.airlineAndFlightNumberLabel = [NSString stringWithFormat:@"%@ %@", ariLine, _airOrder.flightNumber];
    
    self.planeTypeLabel.text = [NSString stringWithFormat:@"机型:%@", _airOrder.flight.planeType];
    self.seatLabel.text = _airOrder.flightSeat.name;
    
    self.departAirportLabel.text = _airOrder.flight.departAirport;
    self.arriveAirportLabel.text = _airOrder.flight.arriveAirport;
    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:_airOrder.flight.departDate];
    NSString *departDateStr =  dateToChineseStringByFormat(departDate, @"HH:mm");
    self.departTimeLabel.text = departDateStr;
    
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:_airOrder.flight.arriveDate];
    NSString *arriveDateStr =  dateToChineseStringByFormat(arriveDate, @"HH:mm");
    self.arriveTimeLabel.text = arriveDateStr;
}

- (CGRect)updateOriginY:(UIView *)view originY:(CGFloat )originY
{
    return CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height);
}

- (CGRect)updateHeight:(UIView *)view height:(CGFloat )height
{
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

- (void)updateHotelView
{
    self.hotelNameLabel.text = _hotelOrder.hotel.name;
    self.hotelPriceLabel.text = [PriceUtils priceToStringCNY:_airHotelOrder.hotelPrice];
    
    //set rooms
    for(UIView *subview in [self.roomInfoHolderView subviews]) {
        [subview removeFromSuperview];
    }
    RoomInfoView *roomInfoView = [RoomInfoView createRoomInfo:_hotelOrder.roomInfosList roomList:_hotelOrder.hotel.roomsList isHidePrice:YES];
    
    self.roomInfoHolderView.frame = [self updateHeight:self.roomInfoHolderView height:roomInfoView.frame.size.height];
    [self.roomInfoHolderView addSubview:roomInfoView];
    
    //update size
    self.hotelDateLabel.frame = [self updateOriginY:self.hotelDateLabel originY:self.roomInfoHolderView.frame.origin.y + self.roomInfoHolderView.frame.size.height];
    self.hotelHolderView.frame =[self updateHeight:self.hotelHolderView height:self.hotelDateLabel.frame.origin.y + self.hotelDateLabel.frame.size.height];
    
    //set date
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:_hotelOrder.checkInDate];
    NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:_hotelOrder.checkOutDate];
    NSString *checkInDateString = dateToStringByFormat(checkInDate, @"yyyy年MM月dd日");
    NSString *checkOutDateString = dateToStringByFormat(checkOutDate, @"MM月dd日");
    NSTimeInterval diff = [checkOutDate timeIntervalSinceDate:checkInDate];
    NSInteger dayCount =  diff / 60 / 60 / 24;
    
    self.hotelDateLabel.text =[NSString stringWithFormat:@"%@ - %@ (%d晚)", checkInDateString, checkOutDateString, dayCount];
}

- (void)setCellWithOrder:(AirHotelOrder *)order
{
    self.airHotelOrder = order;
    self.airOrder = nil;
    self.hotelOrder = nil;
    
    [self updateHeader];
    
    if ([[order hotelOrdersList] count] > 0 ) {
        self.hotelHolderView.hidden = NO;
        self.middleSolidLineView.hidden = YES;
        self.middleDottedLineImageView.hidden = NO;
        
        self.hotelOrder = [[order hotelOrdersList] objectAtIndex:0];
        [self updateHotelView];
    } else {
        self.hotelHolderView.hidden = YES;
        self.middleSolidLineView.hidden = NO;
        self.middleDottedLineImageView.hidden = YES;
    }
    
    
    if ([[order airOrdersList] count] > 0) {
        self.airHolderView.hidden = NO;
        self.hotelHolderView.frame = [self updateOriginY:self.hotelHolderView originY:HEIGHT_TOP + HEIGHT_AIR];
        
        self.airOrder = [[order airOrdersList] objectAtIndex:0];
        [self updateAirView];
    } else {
        self.airHolderView.hidden = YES;
        self.hotelHolderView.frame = [self updateOriginY:self.hotelHolderView originY:HEIGHT_TOP];
    }
    
    
    if ([[order hotelOrdersList] count] > 0 && [[order airOrdersList] count] > 0) {
        self.arrowImageView.frame = [self updateOriginY:self.arrowImageView originY:116];
    } else {
        CGFloat totalHeight = [AirHotelOrderListCell getCellHeight:order];
        self.arrowImageView.frame = [self updateOriginY:self.arrowImageView originY:HEIGHT_TOP + 0.5 * (totalHeight - HEIGHT_TOP) - 10];
    }
    
    if ([[order hotelOrdersList] count] == 0 && [[order airOrdersList] count] == 0) {
        self.arrowImageView.hidden = YES;
    }
}

@end
