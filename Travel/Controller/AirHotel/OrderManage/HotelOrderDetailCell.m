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

+ (CGFloat)getCellHeight:(AirHotelOrder *)airHotelOrde
{
    CGFloat height = HEIGHT_BASIC;
    for (HotelOrder *order in airHotelOrde.hotelOrdersList) {
        height += [OrderHotelView getCellHeightWithOrder:order];
        
        //PPDebug(@"OrderHotelView getCellHeight:%f", [OrderHotelView getCellHeightWithOrder:order]);
    }
    
    return height;
}

- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde
{
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
    
    AppManager *manager = [AppManager defaultManager];
    int currentCiytId = [manager getCurrentCityId];
    NSString *currency = [manager getCurrencySymbol:currentCiytId];
    self.priceLabel.text= [PriceUtils priceToString:airHotelOrde.hotelPrice currency:currency];
}



- (void)dealloc {
    [_statusLabel release];
    [_priceLabel release];
    [_priceHolderView release];
    [_holderView release];
    [super dealloc];
}
@end
