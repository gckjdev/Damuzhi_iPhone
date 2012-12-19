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
    NSData *data = [order data];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest orderAirHotel:data];
        
        if (output.resultCode == ERROR_SUCCESS){
            PPDebug(@"<AirHotelService> order succe");
        } else {
            PPDebug(@"<AirHotelService> order failed");
        }
        
        NSString *reultInfo = [output.jsonDataDict objectForKey:PARA_TRAVEL_RESULT_INFO];
        PPDebug(@"<AirHotelService> order reultInfo:%@", reultInfo);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([delegate respondsToSelector:@selector(orderDone:resultInfo:)]) {
                [delegate orderDone:output.resultCode resultInfo:reultInfo];
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
        
        if (output.resultCode == ERROR_SUCCESS){
            @try{
                TravelResponse *travelResponse = [TravelResponse parseFromData:output.responseData];
                flightList = [[travelResponse flightList] flightsList];
                result = [travelResponse resultCode];
                resultInfo = [travelResponse resultInfo];
                totalCount = [travelResponse totalCount];
            }
            @catch (NSException *exception){
                PPDebug(@"<Catch Exception in findFlights>");
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

@end
