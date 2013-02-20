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

enum AirHotelOrderStatus{
    StatusUnknow = 0,   //未知
    StatusPrepaid = 1,  //已支付
    StatusUnpaid = 2,   //未支付
    StatusFinish = 3,   //已完成
    StatusCancel = 4,   //已取消
    StatusAdd = 5,      //意向订单
    StatusConfirm = 6   //已确认
};

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

- (void)clearFlight:(AirOrder_Builder *)airOrderBuilder;
- (void)clearHotel:(HotelOrder_Builder *)hotelOrderBuilder;

- (void)clearAirOrderBuilder:(AirOrder_Builder *)airOrderBuilder;
- (void)clearHotelOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder;

- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt;
- (NSString *)dateIntToYearMonthDayWeekString2:(int)dateInt;

- (BOOL)isValidAirOrderBuilder:(AirOrder_Builder *)builder;
- (BOOL)isValidHotelOrderBuilder:(HotelOrder_Builder *)builder;

- (NSArray *)validAirOrderBuilders:(NSArray *)builders;
- (NSArray *)validHotelOrderBuilders:(NSArray *)builders;

- (double)calculateAirTotalPrice:(NSArray *)airOrderBuilderList;
- (double)calculateHotelTotalPrice:(NSArray *)hotelOrderBuilderList;

- (NSString *)orderStatusName:(int)status;
- (UIColor *)orderStatusColor:(int)status;

- (NSArray *)getStatusItemList:(NSArray *)airHotelOrderList;

@end
