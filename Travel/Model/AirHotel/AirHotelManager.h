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

- (NSArray *)airOrderListFromBuilderList:(NSArray *)builderList;
- (NSArray *)airOrderBuilderListFromOrderList:(NSArray *)orderList;

- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt;
- (NSString *)dateIntToYearMonthDayWeekString2:(int)dateInt;

- (BOOL)isValidAirOrderBuilder:(AirOrder_Builder *)builder;
- (BOOL)isValidHotelOrderBuilder:(HotelOrder_Builder *)builder;

- (NSArray *)validAirOrderBuilders:(NSArray *)builders;
- (NSArray *)validHotelOrderBuilders:(NSArray *)builders;

@end
