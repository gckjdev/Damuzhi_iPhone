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

@protocol AirHotelOrderDetailControllerDelegate <NSObject>
@optional
- (void)didUpdateOrder:(AirHotelOrder *)order;
@end

@interface AirHotelOrderDetailController : PPTableViewController <OrderHotelViewDelegate, PlaceServiceDelegate, OrderFlightViewDelegate, AirHotelServiceDelegate,UPPayPluginDelegate>
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UILabel *shouldPayPriceLabel;
@property (retain, nonatomic) IBOutlet UIButton *payButton;
@property (retain, nonatomic) IBOutlet UILabel *priceTitleLabel;

@property (assign, nonatomic) BOOL isPopToRoot;
@property (assign, nonatomic) id<AirHotelOrderDetailControllerDelegate> delegate;

- (id)initWithOrder:(AirHotelOrder *)airHotelOrder;

@end
