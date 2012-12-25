//
//  AirHotelManager.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "AirHotelManager.h"
#import "TimeUtils.h"
#import "PriceUtils.h"
#import "AppManager.h"
#import "LogUtil.h"

static AirHotelManager *_airHotelManager = nil;

@implementation AirHotelManager
+ (AirHotelManager *)defaultManager
{
    if (_airHotelManager == nil) {
        _airHotelManager = [[AirHotelManager alloc] init];
    }
    return _airHotelManager;
}

- (AirOrder_Builder *)createDefaultAirOrderBuilder
{
    AirOrder_Builder *builder = [[[AirOrder_Builder alloc] init] autorelease];
    return builder;
}

- (HotelOrder_Builder *)createDefaultHotelOrderBuilder
{
    HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
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

- (NSString *)calculateAirTotalPrice:(NSArray *)airOrderBuilderList
{
    double totalPrice = 0;
    
    for (AirOrder_Builder *builder in airOrderBuilderList) {
        for (Person *person in builder.passengerList) {
            double each = 0;
            if (person.ageType == PersonAgeTypePersonAgeChild) {
                each = builder.flightSeat.ticketPrice + builder.flight.childAirportTax + builder.flight.childFuelTax;
            }else {
                each = builder.flightSeat.ticketPrice + builder.flight.adultAirportTax + builder.flight.adultFuelTax;
            }
            totalPrice += each;
        }
    }
    
    return [PriceUtils priceToStringCNY:totalPrice];
}

- (HotelRoom *)getRoomWithRoomId:(int)roomId hotel:(Place *)hotel
{
    for (HotelRoom *room in hotel.roomsList) {
        if (roomId == room.roomId) {
            return room;
        }
    }
    
    return nil;
}

- (NSString *)calculateHotelTotalPrice:(NSArray *)hotelOrderBuilderList
{
    double totalPrice = 0;
    
    for (HotelOrder_Builder *builder in hotelOrderBuilderList) {
        for (HotelOrderRoomInfo *info in builder.roomInfosList) {
            HotelRoom *room = [self getRoomWithRoomId:info.roomId hotel:builder.hotel];
            totalPrice += info.count * room.price;
        }
    }
    
    AppManager *manager = [AppManager defaultManager];
    int currentCiytId = [manager getCurrentCityId];
    NSString *currency = [manager getCurrencySymbol:currentCiytId];
    
    return [PriceUtils priceToString:totalPrice currency:currency];
}

@end
