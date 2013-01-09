//
//  AirHotelOrderDetailController.h
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "PPTableViewController.h"
#import "OrderHotelView.h"
#import "PlaceService.h"
#import "AirOrderDetailCell.h"
#import "HotelOrderDetailCell.h"

@class AirHotelOrder;

@interface AirHotelOrderDetailController : PPTableViewController <OrderHotelViewDelegate, PlaceServiceDelegate, OrderFlightViewDelegate>

- (id)initWithOrder:(AirHotelOrder *)airHotelOrder;

@end
