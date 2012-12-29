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

@implementation AirOrderDetailCell

- (void)dealloc {
    [_statusLabel release];
    [_passengerHolderView release];
    [_footerView release];
    [_insuranceLabel release];
    [_sendTickeLabel release];
    [_priceLabel release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"AirOrderDetailCell";
}

+ (CGFloat)getCellHeight
{
    return 216.0f;
}

- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde
{
    AirOrder *airOrder = nil;
    if ([[airHotelOrde airOrdersList] count] > 0) {
        airOrder = [airHotelOrde airOrdersAtIndex:0];
    }
    //to do set status
    //self.statusLabel.text =
    
    int count = [airOrder.passengerList count];
    NSString *onePrce = [PriceUtils priceToStringCNY:airOrder.flight.insuranceFee];
    self.insuranceLabel.text = [NSString stringWithFormat:@"%d份，%@/份",count, onePrce];
    
    self.sendTickeLabel.text = (airOrder.sendTicket ? @"需要" : @"不需要");
    self.priceLabel.text = [PriceUtils priceToStringCNY:airHotelOrde.airPrice];
}

@end
