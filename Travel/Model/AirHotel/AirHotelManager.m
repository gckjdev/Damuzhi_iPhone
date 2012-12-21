//
//  AirHotelManager.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "AirHotelManager.h"
#import "TimeUtils.h"

static AirHotelManager *_airHotelManager = nil;

@implementation AirHotelManager
+ (AirHotelManager *)defaultManager
{
    if (_airHotelManager == nil) {
        _airHotelManager = [[AirHotelManager alloc] init];
    }
    return _airHotelManager;
}

- (HotelOrder_Builder *)createDefaultHotelOrderBuilder
{
    HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
    [builder setCheckInDate:[[NSDate date] timeIntervalSince1970]];
    [builder setCheckOutDate:[[NSDate date] timeIntervalSince1970] + 60*60*24];
    return builder;
}

- (NSArray *)hotelOrderListFromBuilderList:(NSArray *)builderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (HotelOrder_Builder *builder in builderList) {
        if ([builder hasCheckInDate] && [builder hasCheckOutDate] && [builder hasHotelId]) {
            HotelOrder *order = [builder build];
            [reArray addObject:order];
        }
    }
    
    return reArray;
}

- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (HotelOrder *order in orderList) {
        HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
        builder.checkInDate = order.checkInDate;
        builder.checkOutDate = order.checkOutDate;
        builder.hotelId = order.hotelId;
        [builder addAllRoomInfos:order.roomInfosList];
        [builder addAllCheckInPersons:order.checkInPersonsList];
        builder.hotel = order.hotel;
        
        [reArray addObject:builder];
    }
    return reArray;
}

- (NSArray *)airOrderListFromBuilderList:(NSArray *)builderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (AirOrder_Builder *builder in builderList) {
        if ([builder hasFlightNumber] && [builder hasFlightSeatCode]) {
            AirOrder *order = [builder build];
            [reArray addObject:order];
        }
    }
    
    return reArray;
}


- (NSArray *)airOrderBuilderListFromOrderList:(NSArray *)orderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (AirOrder *order in orderList) {
        AirOrder_Builder *builder = [[[AirOrder_Builder alloc] init] autorelease];
        builder.flightNumber = order.flightNumber;
        builder.flightSeatCode = order.flightSeatCode;
        builder.flightType = order.flightType;
        builder.flightDate = order.flightDate;
        builder.insurance = order.insurance;
        builder.sendTicket = order.sendTicket;
        builder.insuranceFee = order.insuranceFee;
        builder.sendTicketFee = order.sendTicketFee;
        [builder addAllPassenger:order.passengerList];
        builder.flight = order.flight;
        builder.flightSeat = order.flightSeat;
        
        [reArray addObject:builder];
    }
    return reArray;
}


- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSString *dateString  = dateToStringByFormat(date, @"yyyy年MM月dd日");
    NSString *week = chineseWeekDayFromDate(date);
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@", dateString, week];
    return resultStr;
}

- (NSString *)dateIntToYearMonthDayWeekString2:(int)dateInt
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSString *dateString  = dateToStringByFormat(date, @"yyyy-MM-dd");
    NSString *week = chineseWeekDayFromDate(date);
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@", dateString, week];
    return resultStr;
}

- (BOOL)isValidAirOrderBuilder:(AirOrder_Builder *)builder
{
    if ([builder hasFlightNumber] && [builder hasFlightSeatCode]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isValidHotelOrderBuilder:(HotelOrder_Builder *)builder
{
    if ([builder hasCheckInDate] && [builder hasCheckOutDate] && [builder hasHotelId]) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)validAirOrderBuilders:(NSArray *)builders
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    for (AirOrder_Builder *builder in builders) {
        if ([self isValidAirOrderBuilder:builder]) {
            [resultArray addObject:builder];
        }
    }
    
    return resultArray;
}

- (NSArray *)validHotelOrderBuilders:(NSArray *)builders
{
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    for (HotelOrder_Builder *builder in builders) {
        if ([self isValidHotelOrderBuilder:builder]) {
            [resultArray addObject:builder];
        }
    }
    
    return resultArray;
}

@end
