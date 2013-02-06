//
//  AirHotelOrderDetailTopCell.m
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "AirHotelOrderDetailTopCell.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "AppUtils.h"

@implementation AirHotelOrderDetailTopCell

+ (NSString*)getCellIdentifier
{
    return @"AirHotelOrderDetailTopCell";
}

#define HEIGHT_BAISC    140.0
#define HEIGHT_HOLDER_VIEW  22.0

+ (CGFloat)getCellHeight:(AirHotelOrder *)order
{
    if ([AirHotelOrderDetailTopCell hasAirOrder:order]) {
        return HEIGHT_BAISC;
    }
    return HEIGHT_BAISC - 2 * HEIGHT_HOLDER_VIEW;
}

+ (BOOL)hasAirOrder:(AirHotelOrder *)order
{
    if ([order.airOrdersList count] > 0) {
        return YES;
    }
    return NO;
}

+ (AirOrder *)getGoAirOrder:(AirHotelOrder *)order
{
    AirOrder *goAirOrder = nil;
    for (AirOrder *airOrderTemp in order.airOrdersList)
    {
        if (airOrderTemp.flightType == FlightTypeGo || airOrderTemp.flightType == FlightTypeGoOfDouble) {
            goAirOrder = airOrderTemp;
            break;
        }
    }
    
    return goAirOrder;
}

#define FRAME_HOLDER_1  CGRectMake(0, 45, 302, HEIGHT_HOLDER_VIEW)
#define FRAME_HOLDER_2  CGRectMake(0, 67, 302, HEIGHT_HOLDER_VIEW)
#define FRAME_HOLDER_3  CGRectMake(0, 89, 302, HEIGHT_HOLDER_VIEW)
#define FRAME_HOLDER_4  CGRectMake(0, 111, 302, HEIGHT_HOLDER_VIEW)
- (void)setCellWithOrder:(AirHotelOrder *)order
{
    AirHotelManager *manager = [AirHotelManager defaultManager];
    self.orderStatusLabel.text = [manager orderStatusName:order.orderStatus];
    self.orderStatusLabel.textColor = [manager orderStatusColor:order.orderStatus];
    
    self.orderIdLabel.text = [NSString stringWithFormat:@"%d", order.orderId];
    self.departCityLabel.text = [[AppManager defaultManager] getDepartCityName:order.departCityId];
    self.arriveCityLabel.text = [[AppManager defaultManager] getCityName:order.arriveCityId];
    
    self.departDateLabel.text = nil;
    if ([AirHotelOrderDetailTopCell hasAirOrder:order]) {
        AirOrder *goAirOrder = [AirHotelOrderDetailTopCell getGoAirOrder:order];
        if (goAirOrder) {
            NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:[AppUtils standardTimeFromBeijingTime:goAirOrder.flightDate]];
            self.departDateLabel.text = dateToChineseStringByFormat(departDate, @"yyyy-MM-dd");
        } else {
            self.departDateLabel.text = @"";
        }
        self.departCityHolderView.frame = FRAME_HOLDER_1;
        self.arrvieCityHolderView.frame = FRAME_HOLDER_2;
        self.departDateHolderView.frame = FRAME_HOLDER_3;
        self.contactHolderView.frame = FRAME_HOLDER_4;
        self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, self.holderView.frame.origin.y, self.holderView.frame.size.width, HEIGHT_BAISC);
    }
    else {        
        self.departCityHolderView.hidden = YES;
        self.departDateHolderView.hidden = YES;
        self.arrvieCityHolderView.frame = FRAME_HOLDER_1;
        self.contactHolderView.frame = FRAME_HOLDER_2;
        self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, self.holderView.frame.origin.y, self.holderView.frame.size.width, HEIGHT_BAISC - 2 * HEIGHT_HOLDER_VIEW);
    }
    
    self.contactPersonLabel.text = [NSString stringWithFormat:@"%@/%@", order.contactPerson.name, order.contactPerson.phone];
}

- (void)dealloc {
    [_orderIdLabel release];
    [_orderStatusLabel release];
    [_departCityLabel release];
    [_arriveCityLabel release];
    [_departDateLabel release];
    [_contactPersonLabel release];
    [_departCityHolderView release];
    [_arrvieCityHolderView release];
    [_departDateHolderView release];
    [_contactHolderView release];
    [_holderView release];
    [super dealloc];
}
@end
