//
//  HotelOrderDetailCell.m
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "HotelOrderDetailCell.h"
#import "AirHotel.pb.h"
#import "LogUtil.h"
#import "AppManager.h"
#import "PriceUtils.h"

@implementation HotelOrderDetailCell

+ (NSString*)getCellIdentifier
{
    return @"HotelOrderDetailCell";
}

#define HEIGHT_BASIC    80
#define HEIGHT_TOP      40
#define PLACE           10.0
+ (CGFloat)getCellHeight:(AirHotelOrder *)airHotelOrde
{
    CGFloat height = HEIGHT_BASIC;
    for (HotelOrder *order in airHotelOrde.hotelOrdersList) {
        height += [OrderHotelView getCellHeightWithOrder:order];
        
        //PPDebug(@"OrderHotelView getCellHeight:%f", [OrderHotelView getCellHeightWithOrder:order]);
    }
    
    return height + PLACE;
}

- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde
{
    if (airHotelOrde.hotelPaymentMode == PaymentModeOnline) {
        self.paymentModeLabel.text = @"在线支付";
    } else {
        self.paymentModeLabel.text = @"到店支付";
    }
    
    CGFloat y = HEIGHT_TOP;
    for (HotelOrder *order in airHotelOrde.hotelOrdersList) {
        OrderHotelView *view = [OrderHotelView createOrderHotelView:delegate];
        [view setViewWithOrder:order];
        view.frame = CGRectMake(9, y, view.frame.size.width, view.frame.size.height);
        [self addSubview:view];
        y += [OrderHotelView getCellHeightWithOrder:order];
    }
    
    self.priceHolderView.frame = CGRectMake(self.priceHolderView.frame.origin.x, y, self.priceHolderView.frame.size.width, self.priceHolderView.frame.size.height);
    
    self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, self.holderView.frame.origin.y, self.holderView.frame.size.width, y + self.priceHolderView.frame.size.height);
    
    self.priceLabel.text= [PriceUtils priceToStringCNY:airHotelOrde.hotelPrice ];
}



- (void)dealloc {
    [_statusLabel release];
    [_priceLabel release];
    [_priceHolderView release];
    [_holderView release];
    [_paymentModeLabel release];
    [super dealloc];
}
@end
