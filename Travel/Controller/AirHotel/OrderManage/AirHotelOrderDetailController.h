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
#import "AirHotelService.h"
#import "UPPayPluginDelegate.h"

@class AirHotelOrder;

@interface AirHotelOrderDetailController : PPTableViewController <OrderHotelViewDelegate, PlaceServiceDelegate, OrderFlightViewDelegate, AirHotelServiceDelegate,UPPayPluginDelegate>
@property (retain, nonatomic) IBOutlet UIView *footerView;

@property (assign, nonatomic) BOOL isPopToRoot;

- (id)initWithOrder:(AirHotelOrder *)airHotelOrder;

@end
