//
//  AirHotelManager.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import "AirHotel.pb.h"

@interface AirHotelManager : NSObject

+ (AirHotelManager *)defaultManager;

- (HotelOrder_Builder *)createDefaultHotelOrderBuilder;
- (NSArray *)hotelOrderListFromBuilderList:(NSArray *)builderList;
- (NSArray *)hotelOrderBuilderListFromOrderList:(NSArray *)orderList;



@end
