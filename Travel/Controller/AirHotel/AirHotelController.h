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

@interface AirHotelController : PPTableViewController <MakeHotelOrderCellDelegate, CommonMonthControllerDelegate, SelectHotelControllerDelegate, MakeOrderHeaderDelegate>

@end
