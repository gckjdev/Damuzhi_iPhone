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
#import "Item.h"
#import "AppConstants.h"
#import "LocaleUtils.h"
#import <CoreLocation/CoreLocation.h>

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

- (HotelOrder_Builder *)hotelOrderBuilder:(HotelOrder *)order
{
    HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
    builder.checkInDate = order.checkInDate;
    builder.checkOutDate = order.checkOutDate;
    builder.hotelId = order.hotelId;
    [builder addAllRoomInfos:order.roomInfosList];
    [builder addAllCheckInPersons:order.checkInPersonsList];
    builder.hotel = order.hotel;
    
    return builder;
}

- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (HotelOrder *order in orderList) {
        HotelOrder_Builder *builder = [self hotelOrderBuilder:order];
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

- (AirOrder_Builder *)airOrderBuilder:(AirOrder *)order
{
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
    
    return builder;
}

- (NSArray *)airOrderBuilderListFromOrderList:(NSArray *)orderList
{
    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
    for (AirOrder *order in orderList) {
        AirOrder_Builder *builder = [self airOrderBuilder:order];
        [reArray addObject:builder];
    }
    return reArray;
}

- (void)clearFlight:(AirOrder_Builder *)airOrderBuilder
{
    [airOrderBuilder clearFlightNumber];
    [airOrderBuilder clearFlight];
    [airOrderBuilder clearFlightSeatCode];
    [airOrderBuilder clearFlightSeat];
}

- (void)clearAirOrderBuilder:(AirOrder_Builder *)airOrderBuilder
{
    [airOrderBuilder clear];
}

- (void)clearHotel:(HotelOrder_Builder *)hotelOrderBuilder
{
    [hotelOrderBuilder clearHotelId];
    [hotelOrderBuilder clearHotel];
    [hotelOrderBuilder clearRoomInfosList];
}

- (void)clearHotelOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder
{
    [hotelOrderBuilder clear];
}

- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSString *dateString  = dateToChineseStringByFormat(date, @"yyyy年MM月dd日");
    NSString *week = chineseWeekDayFromDate(date);
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@", dateString, week];
    return resultStr;
}

- (NSString *)dateIntToYearMonthDayWeekString2:(int)dateInt
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSString *dateString  = dateToChineseStringByFormat(date, @"yyyy-MM-dd");
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

- (double)calculateAirTotalPrice:(NSArray *)airOrderBuilderList
{
    double totalPrice = 0;
    
    double sendTicketFee = 0;
    
    for (AirOrder_Builder *builder in airOrderBuilderList) {
        for (Person *person in builder.passengerList) {
            double each = 0;
            if (person.ageType == PersonAgeTypePersonAgeChild) {
                each = builder.flightSeat.childTicketPrice + builder.flight.childAirportTax + builder.flight.childFuelTax;
            }else {
                each = builder.flightSeat.adultTicketPrice + builder.flight.adultAirportTax + builder.flight.adultFuelTax;
            }
            totalPrice += each;
        }
        
        if (builder.insurance) {
            totalPrice += builder.flight.insuranceFee * [builder.passengerList count];
        }
        
        if (builder.sendTicket) {
            sendTicketFee = builder.flight.sendTicketFee;
        }
    }
    
    totalPrice += sendTicketFee;
    
    return totalPrice;
    
    //return [PriceUtils priceToStringCNY:totalPrice];
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

- (double)calculateHotelTotalPrice:(NSArray *)hotelOrderBuilderList
{
    double totalPrice = 0;
    
    for (HotelOrder_Builder *builder in hotelOrderBuilderList) {
        for (HotelOrderRoomInfo *info in builder.roomInfosList) {
            HotelRoom *room = [self getRoomWithRoomId:info.roomId hotel:builder.hotel];
            int days = (builder.checkOutDate - builder.checkInDate) / (60 * 60 * 24);
            if (days <= 0) {
                days = 1;
            }
            totalPrice += info.count * room.price * days;
        }
    }
    
    return totalPrice;
}

- (NSString *)orderStatusName:(int)status
{
    NSString *statusName = nil;
    switch (status) {
        case StatusUnknow:
            statusName = @"未知";
            break;
        case StatusPrepaid:
            statusName = @"已支付";
            break;
        case StatusUnpaid:
            statusName = @"未支付";
            break;
        case StatusFinish:
            statusName = @"已完成";
            break;
        case StatusCancel:
            statusName = @"已取消";
            break;
        case StatusAdd:
            statusName = @"意向订单";
            break;
        case StatusConfirm:
            statusName = @"已确认";
            break;
        default:
            break;
    }
    return statusName;
}

- (UIColor *)orderStatusColor:(int)status
{
    UIColor *statusColor = [UIColor blackColor];
    switch (status) {
        case StatusUnknow:

            break;
        case StatusPrepaid:
            statusColor = [UIColor colorWithRed:0xff/0xff green:0x66/0xff blue:0x00/0xff alpha:1.0];
            break;
        case StatusUnpaid:
            statusColor = [UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
        case StatusFinish:

            break;
        case StatusCancel:

            break;
        case StatusAdd:

            break;
        case StatusConfirm:

            break;
        default:
            break;
    }
    return statusColor;
}

- (BOOL)isHasItem:(NSArray *)itemList status:(int)status
{
    for (Item *item in itemList) {
        if (item.itemId == status) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)getStatusItemList:(NSArray *)airHotelOrderList
{
    NSMutableArray *statusList = [[[NSMutableArray alloc] init] autorelease];
    
    [statusList addObject:[Item itemWithId:ALL_CATEGORY
                                  itemName:NSLS(@"全部")
                                     count:0]];
    
    for (AirHotelOrder * order in airHotelOrderList) {
        if ([self isHasItem:statusList status:order.orderStatus] == NO) {
            NSString *statusName = [self orderStatusName:order.orderStatus];
            [statusList addObject:[Item itemWithId:order.orderStatus itemName:statusName count:0]];
        }
    }
    
    return statusList;
}

- (AirCity *)getDefaultDepartCity:(NSString *)cityName
                         latitude:(double)latitude
                        longitude:(double)longitude
{
    PPDebug(@"user location la:%f lo:%f", latitude, longitude);
    NSArray *cityList = [[[AppManager defaultManager] app] airDepartCitiesList];
    for (AirCity *city in cityList) {
        for (CityLocationInfo *info in city.locationInfoList) {
            if ([info.cityName isEqualToString:cityName]) {
                //return city;
            }
        }
    }
    
    CLLocation *userCurrentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
    
    double minDistance = 0;
    int index = 0;
    AirCity *resultCity = nil;
    for (AirCity *city in cityList) {
        for (CityLocationInfo *info in city.locationInfoList) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:info.latitude longitude:info.longitude];
            CLLocationDistance distance = [userCurrentLocation distanceFromLocation:location];
            if (index == 0) {
                minDistance = distance;
                resultCity = city;
            }
            
            if (minDistance > distance) {
                minDistance = distance;
                resultCity = city;
            }
            
            [location release];
            
            
            PPDebug(@"c:%@ d:%f la:%f lo:%f", city.cityName, distance, info.latitude, info.longitude);
        }
        index ++;
    }
    
    return resultCity;
}

@end
