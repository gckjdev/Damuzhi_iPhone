//
//  AirHotelService.h
//  Travel
//
//  Created by haodong on 12-11-20.
//
//

#import "CommonService.h"
#import "UPPayPluginDelegate.h"

#define ERROR_NO_FLIGHT_DATA            10001

@class AirHotelOrder;

@protocol AirHotelServiceDelegate <NSObject>

@optional
- (void)findHotelsDone:(int)resultCode
                result:(int)result
            resultInfo:(NSString *)resultInfo
            totalCount:(int)totalCount
             hotelList:(NSArray*)hotelList;

- (void)orderDone:(int)result
       resultInfo:(NSString *)resultInfo
          orderId:(int)orderId
          needPay:(BOOL)needPay;

- (void)findFlightsDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
             flightList:(NSArray *)flightList;

- (void)findOrdersDone:(int)result orderList:(NSArray *)orderList;

- (void)findOrderDone:(int)result order:(AirHotelOrder *)order;

- (void)findOrderPaymentInfoDone:(int)result paymentInfo:(NSString *)paymentInfo;

- (void)findPaySerialNumberDone:(int)result
                     resultInfo:(NSString *)resultInfo
                   serialNumber:(NSString *)serialNumber
                    orderNumber:(int)orderNumber;

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
                       flightNumber:(NSString *)flightNumber
                           delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)findOrdersUsingUserId:(NSString *)userId
                    delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)findOrdersUsingLoginId:(NSString *)loginId
                        token:(NSString *)token
                     delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)findOrder:(int)orderId delegate:(id<AirHotelServiceDelegate>)delegate;

//- (void)findOrderPaymentInfo:(int)orderId
//                    delegate:(id<AirHotelServiceDelegate>)delegate;

- (void)findPaySerialNumber:(int)orderId
                   delegate:(id<AirHotelServiceDelegate>)delegate;

//queryPayOrder just for test
- (void)queryPayOrder:(int)orderNumber;

@end
