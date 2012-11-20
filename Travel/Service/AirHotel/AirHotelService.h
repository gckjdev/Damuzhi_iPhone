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

@end


@interface AirHotelService : CommonService

+ (AirHotelService*)defaultService;

- (void)findHotels:(int)cityId
       checkInDate:(NSDate *)checkInDate
      checkOutDate:(NSDate *)checkOutDate
             start:(int)start
             count:(int)count
          delegate:(id<AirHotelServiceDelegate>)delegate;

@end
