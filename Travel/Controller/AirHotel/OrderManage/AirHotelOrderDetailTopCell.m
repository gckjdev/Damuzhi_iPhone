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

@implementation AirHotelOrderDetailTopCell

+ (NSString*)getCellIdentifier
{
    return @"AirHotelOrderDetailTopCell";
}

+ (CGFloat)getCellHeight
{
    return 140.0f;
}

- (void)setCellWithOrder:(AirHotelOrder *)order
{
    self.orderIdLabel.text = [NSString stringWithFormat:@"%d", order.orderId];
    self.departCityLabel.text = [[AppManager defaultManager] getDepartCityName:order.departCityId];
    self.arriveCityLabel.text = [[AppManager defaultManager] getCityName:order.arriveCityId];
    
    if ([order.airOrdersList count] > 0) {
        AirOrder *goAirOrder = nil;
        for (AirOrder *airOrderTemp in order.airOrdersList)
        {
            if (airOrderTemp.flightType == FlightTypeGo || airOrderTemp.flightType == FlightTypeGoOfDouble) {
                goAirOrder = airOrderTemp;
            }
        }
        
        if (goAirOrder) {
            NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:goAirOrder.flightDate];
            self.departDateLabel.text = dateToChineseStringByFormat(departDate, @"yyyy-MM-dd");
        }
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
    [super dealloc];
}
@end
