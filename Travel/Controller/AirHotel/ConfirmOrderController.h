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
#import "SelectPersonController.h"
#import "PlaceService.h"
#import "AirHotelOrderListController.h"

@class AirHotelOrder_Builder;

@interface ConfirmOrderController : PPTableViewController<AirHotelServiceDelegate, SelectPersonControllerDelegate, ConfirmAirCellDelegate,ConfirmHotelCellDelegate, UIAlertViewDelegate, PlaceServiceDelegate, AirHotelOrderListControllerDelegate, OrderFlightViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *contactPersonButton;
@property (retain, nonatomic) IBOutlet UILabel *airPirceLabel;
@property (retain, nonatomic) IBOutlet UILabel *hotelPriceLabel;
@property (retain, nonatomic) IBOutlet UIView *airPriceHolderView;
@property (retain, nonatomic) IBOutlet UIView *hotelPriceHolderView;
@property (retain, nonatomic) IBOutlet UILabel *shouldPayPriceLabel;

- (id)initWithAirOrderBuilders:(NSMutableArray *)airOrderBuilders
            hotelOrderBuilders:(NSMutableArray *)hotelOrderBuilders
                  departCityId:(int)departCityId
                      isMember:(BOOL)isMember;

@end
