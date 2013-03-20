//
//  AirHotelController.h
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "PPTableViewController.h"
#import "MakeHotelOrderCell.h"
#import "MakeAirOrderOneCell.h"
#import "MakeAirOrderTwoCell.h"
#import "CommonMonthController.h"
#import "SelectHotelController.h"
#import "MakeOrderHeader.h"
#import "SelectFlightController.h"
#import "SelectAirCityController.h"
#import "UIViewController+Travel.h"
#import "LoginController.h"
#import "AirHotelService.h"

@interface AirHotelController : PPTableViewController <MakeHotelOrderCellDelegate, CommonMonthControllerDelegate, SelectHotelControllerDelegate, MakeOrderHeaderDelegate, MakeAirOrderCellDelegate, SelectAirCityControllerDelegate, FlightDetailControllerDelegate, UIActionSheetDelegate, LoginControllerDelegate, AirHotelServiceDelegate>
@property (retain, nonatomic) IBOutlet UIButton *memberButton;
@property (retain, nonatomic) IBOutlet UIButton *nonMemberButton;
@property (retain, nonatomic) IBOutlet UIView *tipsView;

@end
