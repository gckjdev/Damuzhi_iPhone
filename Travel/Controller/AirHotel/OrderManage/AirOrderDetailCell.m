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

#define HEIGHT_TOP      40
+ (CGFloat)getCellHeight
{
    return 400.0f;
}

- (CGRect)updateOriginY:(UIView *)view originY:(CGFloat )originY
{
    return CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height);
}

- (CGRect)updateHeight:(UIView *)view height:(CGFloat )height
{
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde
{
     CGFloat y = HEIGHT_TOP;
    for (AirOrder * airOrder in airHotelOrde.airOrdersList) {
        OrderFlightView *view = [OrderFlightView createOrderFlightView:delegate];
        [view setViewWithOrder:airOrder];
        view.frame = CGRectMake(9, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        y += view.frame.size.height;
    }
    
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, y, self.footerView.frame.size.width, self.footerView.frame.size.height);
    
    AirOrder *airOrder = nil;
    if ([[airHotelOrde airOrdersList] count] > 0) {
        airOrder = [airHotelOrde airOrdersAtIndex:0];
    }
    
    
    PersonsView *personsView = [PersonsView createCheckInPersonLabels:airOrder.passengerList];
    //spersonsView.backgroundColor = [UIColor blueColor];
    self.passengerHolderView.frame = [self updateHeight:self.passengerHolderView height:personsView.frame.size.height];
    [self.passengerHolderView addSubview:personsView];
    self.priceHolderView.frame = [self updateOriginY:self.priceHolderView originY:_passengerHolderView.frame.origin.y + _passengerHolderView.frame.size.height];
    
    self.footerView.frame = [self updateHeight:self.footerView height:_priceHolderView.frame.origin.y + _priceHolderView.frame.size.height];
    self.holderView.frame = [self updateHeight:self.holderView height:self.footerView.frame.origin.y + self.footerView.frame.size.height];
    
    if (airHotelOrde.airPaymentStatus == AirPaymentStatusAirPaymentFinish) {
        self.statusLabel.text = NSLS(@"已支付");
    } else {
        self.statusLabel.text = NSLS(@"未支付");
    }
    
    if (airOrder.insurance) {
        int count = [airOrder.passengerList count];
        NSString *onePrce = [PriceUtils priceToStringCNY:airOrder.flight.insuranceFee];
        self.insuranceLabel.text = [NSString stringWithFormat:@"%d份，%@/份",count, onePrce];
    } else {
        self.insuranceLabel.text = NSLS(@"不需要");
    }
    
    self.sendTickeLabel.text = (airOrder.sendTicket ? NSLS(@"需要") : NSLS(@"不需要") );
    self.priceLabel.text = [PriceUtils priceToStringCNY:airHotelOrde.airPrice];
}

@end
