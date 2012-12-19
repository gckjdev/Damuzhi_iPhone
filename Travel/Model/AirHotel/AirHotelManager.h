//
//  AirHotelManager.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import "AirHotel.pb.h"

typedef enum{
    FlightTypeGo = 1,
    FlightTypeBack = 2,
    FlightTypeGoOfDouble = 3,
    FlightTypeBackOfDouble = 4
} FlightType;

@interface AirHotelManager : NSObject

+ (AirHotelManager *)defaultManager;

- (HotelOrder_Builder *)createDefaultHotelOrderBuilder;
- (NSArray *)hotelOrderListFromBuilderList:(NSArray *)builderList;
- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList;

- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt;

@end
