//
//  AirHotelService.h
//  Travel
//
//  Created by haodong on 12-11-20.
//
//

#import "CommonService.h"

@protocol AirHotelServiceDelegate <NSObject>

@optional
- (void)findHotelsDone:(int)resultCode
                result:(int)result
            resultInfo:(NSString *)resultInfo
            totalCount:(int)totalCount
             hotelList:(NSArray*)hotelList;

- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo;

- (void)findFlightsDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
             flightList:(NSArray *)flightList;

@end


@class AirHotelOrder;

@interface AirHotelService : CommonService

+ (AirHotelService*)defaultService;

- (void)findHotelsWithCityId:(int)cityId
                 checkInDate:(NSDate *)checkInDate
                checkOutDate:(NSDate *)checkOutDate
                       start:(int)start
                       count:(int)count
                    delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)order:(AirHotelOrder *)order
     delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)findFlightsWithDepartCityId:(int)departCityId
                  destinationCityId:(int)destinationCityId
                         departDate:(NSDate *)departDate
                         flightType:(int)flightType
                       flightNumber:(NSString *)flightNumber;

@end
