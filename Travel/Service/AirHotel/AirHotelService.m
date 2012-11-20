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

static AirHotelService *_airHotelService = nil;

@implementation AirHotelService

+ (AirHotelService*)defaultService
{
    if (_airHotelService == nil){
        _airHotelService = [[AirHotelService alloc] init];
    }
    
    return _airHotelService;
}

- (void)findHotels:(int)cityId
       checkInDate:(NSString *)checkInDate
      checkOutDate:(NSString *)checkOutDate
             start:(int)start
             count:(int)count
          delegate:(id<AirHotelServiceDelegate>)delegate
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CommonNetworkOutput* output = [TravelNetworkRequest queryList:OBJECT_LIST_CHECK_IN_HOTEL
                                                               cityId:cityId
                                                          checkInDate:checkInDate
                                                         checkOutDate:checkOutDate
                                                                start:start
                                                                count:start
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
                PPDebug(@"<Catch Exception in findRoutesWithType>");
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

@end
