//
//  AirHotelService.m
//  Travel
//
//  Created by haodong on 12-11-20.
//
//

#import "AirHotelService.h"
#import "TravelNetworkRequest.h"
#import "Package.pb.h"
#import "LogUtil.h"
#import "TimeUtils.h"
#import "AirHotel.pb.h"
#import "JSON.h"

static AirHotelService *_airHotelService = nil;

@implementation AirHotelService

+ (AirHotelService*)defaultService
{
    if (_airHotelService == nil){
        _airHotelService = [[AirHotelService alloc] init];
    }
    
    return _airHotelService;
}


- (void)findHotelsWithCityId:(int)cityId
                 checkInDate:(NSDate *)checkInDate
                checkOutDate:(NSDate *)checkOutDate
                       start:(int)start
                       count:(int)count
                    delegate:(id<AirHotelServiceDelegate>)delegate
{
    NSString *checkInDateStr = dateToStringByFormat(checkInDate, @"yyyyMMdd");
    NSString *checkOutDateStr = dateToStringByFormat(checkOutDate, @"yyyyMMdd");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_LIST_CHECK_IN_HOTEL
                                                               cityId:cityId
                                                          checkInDate:checkInDateStr
                                                         checkOutDate:checkOutDateStr
                                                                start:start
                                                                count:count
                                                                lang:LanguageTypeZhHans];
        
        int totalCount = 0 ;
        int result = 0;
        NSString *resultInfo = nil;
        NSArray *hotelList = nil;
        
        PPDebug(@"<findHotelsWithCityId> resultCode:%d", output.resultCode);
        
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                hotelList = [[travelResponse placeList] listList];
                result = [travelResponse resultCode];
                resultInfo = [travelResponse resultInfo];
                totalCount = [travelResponse totalCount];
            }
            @catch (NSException *exception){
                PPDebug(@"<Catch Exception in findHotels>");
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findHotelsDone:result:resultInfo:totalCount:hotelList:)]) {
                [delegate findHotelsDone:output.resultCode
                                  result:result
                              resultInfo:resultInfo
                              totalCount:totalCount
                               hotelList:hotelList];
            }
        });
        
    });
}

- (void)order:(AirHotelOrder *)order
     delegate:(id<AirHotelServiceDelegate>)delegate
{
    //PPDebug(@"<AirHotelService> %@ %@", [order airOrdersAtIndex:0].flightNumber, [order airOrdersAtIndex:0].flightSeatCode );
    
    //PPDebug(@"<AirHotelService> %d", [order hotelOrdersAtIndex:0].hotelId);
    
    NSData *data = [order data];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest orderAirHotel:data];
        
        if (output.resultCode == ERROR_SUCCESS){
            PPDebug(@"<AirHotelService> order succe");
        } else {
            PPDebug(@"<AirHotelService> order failed");
        }
        
        NSString *reultInfo = [output.jsonDataDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        NSString *orderIdStr = [output.jsonDataDict objectForKey:PARA_TRAVEL_ID];
        int orderId = [orderIdStr intValue];
        int needPayInt = [[output.jsonDataDict objectForKey:PARA_TRAVEL_NEED_PAY] intValue];
        BOOL needPay = (needPayInt == 1 ? YES : NO);
        
        //PPDebug(@"<AirHotelService> order reultInfo:%@", reultInfo);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(orderDone:resultInfo:orderId:needPay:)]) {
                [delegate orderDone:output.resultCode resultInfo:reultInfo orderId:orderId needPay:needPay];
            }
        });
    });
}

- (void)findFlightsWithDepartCityId:(int)departCityId
                  destinationCityId:(int)destinationCityId
                         departDate:(NSDate *)departDate
                         flightType:(int)flightType
                       flightNumber:(NSString *)flightNumber
                           delegate:(id<AirHotelServiceDelegate>)delegate

{
    NSString *departDateStr = dateToStringByFormat(departDate, @"yyyyMMdd");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:OBJECT_LIST_FLIGHT
                                                         departCityId:departCityId
                                                    destinationCityId:destinationCityId
                                                           departDate:departDateStr
                                                           flightType:flightType
                                                         flightNumber:flightNumber
                                                                 lang:LanguageTypeZhHans];
        
        int totalCount = 0 ;
        int result = 0;
        NSString *resultInfo = nil;
        NSArray *flightList = nil;

        if (output.responseData == nil || [output.responseData length] == 0){
            PPDebug(@"<findFlights> but response data is empty");
            output.resultCode = ERROR_NO_FLIGHT_DATA;
        }
        
        if (output.resultCode == ERROR_SUCCESS){
            
            @try{
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                flightList = [[travelResponse flightList] flightsList];
                result = [travelResponse resultCode];
                resultInfo = [travelResponse resultInfo];
                totalCount = [travelResponse totalCount];
            }
            @catch (NSException *exception){
                PPDebug(@"<Catch Exception in findFlights> exception=%@", [exception description]);
                output.resultCode = ERROR_CLIENT_PARSE_DATA;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findFlightsDone:result:resultInfo:flightList:)]) {
                [delegate findFlightsDone:output.resultCode
                                   result:result
                               resultInfo:resultInfo
                               flightList:flightList];
                
                }
        });
        
    });
}

- (void)findOrdersUsingUserId:(NSString *)userId
                    delegate:(id<AirHotelServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:OBJECT_LIST_AIR_HOTEL_ORDER userId:userId lang:LanguageTypeZhHans];
        int result = -1;
        NSString *resultInfo;
        TravelResponse *travelResponse = nil;
        
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
            } @catch (NSException *exception){
                PPDebug (@"<findOrderUsingUserId> Caught %@%@", [exception name], [exception reason]);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findOrdersDone:orderList:)]) {
                [delegate findOrdersDone:output.resultCode orderList:[travelResponse.airHotelOrderList airHotelOrdersList]];
            }
        });
    });
}

- (void)findOrdersUsingLoginId:(NSString *)loginId
                        token:(NSString *)token
                     delegate:(id<AirHotelServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryList:OBJECT_LIST_AIR_HOTEL_ORDER loginId:loginId token:token lang:LanguageTypeZhHans];
        int result = -1;
        NSString *resultInfo;
        TravelResponse *travelResponse = nil;
        
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            @try{
                travelResponse = [TravelResponse parseFromData:output.responseData];
            } @catch (NSException *exception){
                PPDebug (@"<findOrderUsingUserId> Caught %@%@", [exception name], [exception reason]);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findOrdersDone:orderList:)]) {
                [delegate findOrdersDone:output.resultCode orderList:[travelResponse.airHotelOrderList airHotelOrdersList]];
            }
        });
    });
}

- (void)findOrder:(int)orderId delegate:(id<AirHotelServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryObject:OBJECT_TYPE_AIR_HOTEL_ORDER objId:orderId lang:LanguageTypeZhHans];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AirHotelOrder *order;
            int result;
            NSString *resultInfo;
            @try {
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                order = [travelResponse airHotelOrder];
                result = [travelResponse resultCode];
                resultInfo = [travelResponse resultInfo];
            }
            @catch (NSException *exception) {
                PPDebug(@"<findOrder> Caught %@%@", [exception name], [exception reason]);
            }
            
            if ([delegate respondsToSelector:@selector(findOrderDone:order:)]){
                [delegate findOrderDone:result order:order];
            }
        });
    });
}

//- (void)findOrderPaymentInfo:(int)orderId
//                    delegate:(id<AirHotelServiceDelegate>)delegate
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
//        NSError *requestError;
//        NSURLResponse *urlResponse = nil;
//        NSMutableURLRequest * requestm=[[NSMutableURLRequest alloc] init];
//        [requestm setTimeoutInterval:60];
//        NSString* urlAddress = [NSString stringWithFormat:@"%@%@=%d", URL_TRAVEL_ORDER_PAYMENT_INFO,PARA_TRAVEL_ID,orderId];
//        
//        PPDebug(@"<findOrderPaymentInfo> url:%@",urlAddress);
//        
//        NSURL* url = [NSURL URLWithString:urlAddress];
//        [requestm setURL:url];
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:requestm returningResponse:&urlResponse error:&requestError];
//        [requestm release];
//        
//        int result = 0;
//        BOOL isSucc = YES;
//        if (!urlResponse) {
//            if (requestError) {
//                result = 1;
//                isSucc = NO;
//                PPDebug(@"<findOrderPaymentInfo> error");
//            }
//        }
//        
//        NSString* paymentInfo = nil;
//        if (isSucc) {
//           paymentInfo = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
//        }
//        
//        PPDebug(@"<findOrderPaymentInfo> paymentInfo:%@",paymentInfo);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([delegate respondsToSelector:@selector(findOrderPaymentInfoDone:paymentInfo:)]) {
//                [delegate findOrderPaymentInfoDone:result paymentInfo:paymentInfo];
//            }
//        });
//    });
//}

- (void)findPaySerialNumber:(int)orderId
                   delegate:(id<AirHotelServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput *output = [TravelNetworkRequest querySerialNumber:orderId];
        
        int result = -1;
        NSString *resultInfo = nil;
        NSString *serialNumber = nil;
        int orderNumber = 0;
        if (output.resultCode == ERROR_SUCCESS) {
            NSDictionary* jsonDict = [output.textData JSONValue];
            result = [[jsonDict objectForKey:PARA_TRAVEL_RESULT] intValue];
            resultInfo = [jsonDict objectForKey:PARA_TRAVEL_RESULT_INFO];
            serialNumber = [jsonDict objectForKey:PARA_TRAVEL_SERIAL_NUMBER];
            orderNumber = [[jsonDict objectForKey:PARA_TRAVEL_ORDER_NUMBER] intValue];
        } 
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(findPaySerialNumberDone:resultInfo:serialNumber:orderNumber:)]) {
                [delegate findPaySerialNumberDone:result resultInfo:resultInfo serialNumber:serialNumber orderNumber:orderNumber];
            }
        });
    });
}

- (void)queryPayOrder:(int)orderNumber
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput *output = [TravelNetworkRequest queryPayOrder:orderNumber];
        if (output.resultCode == ERROR_SUCCESS) {
            //PPDebug(@"<queryPayOrder>");
        }
    });

}

@end
