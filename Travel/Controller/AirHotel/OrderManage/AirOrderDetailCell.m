//
//  AirOrderDetailCell.m
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "AirOrderDetailCell.h"
#import "AirHotel.pb.h"
#import "PriceUtils.h"
#import "LocaleUtils.h"
#import "PersonsView.h"
#import "LogUtil.h"

@implementation AirOrderDetailCell

- (void)dealloc {
    [_statusLabel release];
    [_passengerHolderView release];
    [_insuranceLabel release];
    [_sendTickeLabel release];
    [_priceLabel release];
    [_footerView release];
    [_priceHolderView release];
    [_holderView release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"AirOrderDetailCell";
}

+ (CGFloat)getCellHeight:(AirHotelOrder *)airHotelOrde
{
    NSUInteger passengerCount = 0;
    if ([[airHotelOrde airOrdersList] count] > 0) {
        AirOrder *airOrder = [airHotelOrde airOrdersAtIndex:0];
        passengerCount = [airOrder.passengerList count];
    }
    
    if (passengerCount == 0) {
        passengerCount = 1;
    }
    
    return [airHotelOrde.airOrdersList count] * [OrderFlightView getViewHeight] + 24 * (passengerCount -1) + 85;
}

- (CGRect)updateOriginY:(UIView *)view originY:(CGFloat )originY
{
    return CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height);
}

- (CGRect)updateHeight:(UIView *)view height:(CGFloat )height
{
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

#define PACE_TICKET_AND_PASSENGER  10
- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde
{
    CGFloat y = 0;
    for (AirOrder * airOrder in airHotelOrde.airOrdersList) {
        OrderFlightView *view = [OrderFlightView createOrderFlightView:delegate];
        [view setViewWithOrder:airOrder];
        view.frame = CGRectMake(0, y, view.frame.size.width, view.frame.size.height);
        [self.holderView addSubview:view];
        y += view.frame.size.height;
    }
    self.holderView.frame = [self updateHeight:self.holderView height:y];
    
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, y + PACE_TICKET_AND_PASSENGER, self.footerView.frame.size.width, self.footerView.frame.size.height);
    
    AirOrder *airOrder = nil;
    if ([[airHotelOrde airOrdersList] count] > 0) {
        airOrder = [airHotelOrde airOrdersAtIndex:0];
    }
    
    PersonsView *personsView = [PersonsView createCheckInPersonLabels:airOrder.passengerList type:PersonListTypePassenger];
    
    self.passengerHolderView.frame = [self updateHeight:self.passengerHolderView height:personsView.frame.size.height];
    
    [self.passengerHolderView addSubview:personsView];
    self.priceHolderView.frame = [self updateOriginY:self.priceHolderView originY:_passengerHolderView.frame.origin.y + _passengerHolderView.frame.size.height];
    
    self.footerView.frame = [self updateHeight:self.footerView height:_priceHolderView.frame.origin.y + _priceHolderView.frame.size.height];
    
    self.statusLabel.text = NSLS(@"在线支付");
    
    if (airOrder.insurance) {
        int count = [airOrder.passengerList count] * [airHotelOrde.airOrdersList count];
        NSString *onePrce = [PriceUtils priceToStringCNY:airOrder.flight.insuranceFee];
        self.insuranceLabel.text = [NSString stringWithFormat:@"%d份，%@/份",count, onePrce];
    } else {
        self.insuranceLabel.text = NSLS(@"不需要");
    }
    
    self.sendTickeLabel.text = (airOrder.sendTicket ? NSLS(@"需要") : NSLS(@"不需要") );
    self.priceLabel.text = [PriceUtils priceToStringCNY:airHotelOrde.airPrice];
}

@end
