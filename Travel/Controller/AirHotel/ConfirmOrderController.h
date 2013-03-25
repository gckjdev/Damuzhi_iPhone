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
#import "PayView.h"

@class AirHotelOrder_Builder;

@interface ConfirmOrderController : PPTableViewController<AirHotelServiceDelegate, SelectPersonControllerDelegate, ConfirmAirCellDelegate,ConfirmHotelCellDelegate, UIAlertViewDelegate, PlaceServiceDelegate, OrderFlightViewDelegate, UmpayDelegate>

@property (retain, nonatomic) IBOutlet UIButton *contactPersonButton;
@property (retain, nonatomic) IBOutlet UILabel *airPirceLabel;
@property (retain, nonatomic) IBOutlet UILabel *hotelPriceLabel;
@property (retain, nonatomic) IBOutlet UIView *airPriceHolderView;
@property (retain, nonatomic) IBOutlet UIView *hotelPriceHolderView;
@property (retain, nonatomic) IBOutlet UILabel *shouldPayPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *hotelPayModeLabel;
@property (retain, nonatomic) IBOutlet UIView *shouldPayPriceHolderView;
@property (retain, nonatomic) IBOutlet UIButton *orderButton;
@property (retain, nonatomic) IBOutlet UIView *passengerHolderView;
@property (retain, nonatomic) IBOutlet UIButton *passengerButton;
@property (retain, nonatomic) IBOutlet UIView *contactHolderView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (retain, nonatomic) IBOutlet UILabel *sendTicketLabel;
@property (retain, nonatomic) IBOutlet UIButton *insuranceButton;
@property (retain, nonatomic) IBOutlet UIButton *sendTicketButton;

- (id)initWithAirOrderBuilders:(NSMutableArray *)airOrderBuilders
            hotelOrderBuilders:(NSMutableArray *)hotelOrderBuilders
                  departCityId:(int)departCityId
                      isMember:(BOOL)isMember;

@end
