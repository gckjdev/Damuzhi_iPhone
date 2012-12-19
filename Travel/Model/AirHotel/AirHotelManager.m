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

//- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList
//{
//    NSMutableArray *reArray = [[[NSMutableArray alloc] init] autorelease];
//    for (HotelOrder *order in orderList) {
//        HotelOrder_Builder *builder = [[[HotelOrder_Builder alloc] init] autorelease];
//        builder.checkInDate = order.checkInDate;
//        builder.checkOutDate = order.checkOutDate;
//        builder.hotelId = order.hotelId;
//        [builder addAllRoomInfos:order.roomInfosList];
//        [builder addAllCheckInPersons:order.checkInPersonsList];
//        builder.hotel = order.hotel;
//        
//        [reArray addObject:builder];
//    }
//    return reArray;
//}

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


- (NSString *)dateIntToYearMonthDayWeekString:(int)dateInt
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:dateInt];
    NSString *dateString  = dateToStringByFormat(date, @"yyyy年MM月dd日");
    NSString *week = chineseWeekDayFromDate(date);
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@", dateString, week];
    return resultStr;
}

@end
