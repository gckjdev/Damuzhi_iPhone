//
//  ConfirmOrderController.h
//  Travel
//
//  Created by haodong on 12-11-26.
//
//

#import "PPTableViewController.h"
#import "AirHotelService.h"
#import "ConfirmHotelCell.h"
#import "ConfirmAirCell.h"

@class AirHotelOrder_Builder;

@interface ConfirmOrderController : PPTableViewController<AirHotelServiceDelegate>

- (id)initWithOrderBuilder:(AirHotelOrder_Builder *)builder;

@end
