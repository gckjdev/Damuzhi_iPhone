//
//  ConfirmOrderController.h
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "PPViewController.h"
#import "AirHotelService.h"

@class AirHotelOrder_Builder;

@interface ConfirmOrderController : PPViewController<AirHotelServiceDelegate>

- (id)initWithOrderBuilder:(AirHotelOrder_Builder *)builder;

@end
