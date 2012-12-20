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

@class AirHotelOrder_Builder;

@interface ConfirmOrderController : PPTableViewController<AirHotelServiceDelegate, SelectPersonControllerDelegate, ConfirmAirCellDelegate,ConfirmHotelCellDelegate>

@property (retain, nonatomic) IBOutlet UIButton *contactPersonButton;
@property (retain, nonatomic) IBOutlet UIButton *paymentButton;


- (id)initWithAirOrderBuilders:(NSArray *)airOrderBuilders
            hotelOrderBuilders:(NSArray *)hotelOrderBuilders
                      isMember:(BOOL)isMember;

@end
