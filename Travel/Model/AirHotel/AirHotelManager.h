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

- (AirOrder_Builder *)createDefaultAirOrderBuilder;
- (HotelOrder_Builder *)createDefaultHotelOrderBuilder;

- (HotelOrder_Builder *)hotelOrderBuilder:(HotelOrder *)order;
- (NSArray *)hotelOrderListFromBuilderList:(NSArray *)builderList;
- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList;

- (AirOrder_Builder *)airOrderBuilder:(AirOrder *)order;
- (NSArray *)airOrderListFromBuilderList:(NSArray *)builderList;
- (NSArray *)airOrderBuilderListFromOrderList:(NSArray *)orderList;

- (void)clearAirOrderBuilder:(AirOrder_Builder *)airOrderBuilder;
- (void)clearHotelOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder;

- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt;
- (NSString *)dateIntToYearMonthDayWeekString2:(int)dateInt;

- (BOOL)isValidAirOrderBuilder:(AirOrder_Builder *)builder;
- (BOOL)isValidHotelOrderBuilder:(HotelOrder_Builder *)builder;

- (NSArray *)validAirOrderBuilders:(NSArray *)builders;
- (NSArray *)validHotelOrderBuilders:(NSArray *)builders;

- (NSString *)calculateAirTotalPrice:(NSArray *)airOrderBuilderList;
- (NSString *)calculateHotelTotalPrice:(NSArray *)hotelOrderBuilderList;

- (NSString *)orderStatusName:(int)status;
- (UIColor *)orderStatusColor:(int)status;

@end
