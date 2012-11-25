//
//  AirHotelController.h
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "PPTableViewController.h"
#import "MakeHotelOrderCell.h"
#import "MakeAirOrderTwoCell.h"
#import "CommonMonthController.h"
#import "SelectHotelController.h"

@interface AirHotelController : PPTableViewController <MakeHotelOrderCellDelegate, CommonMonthControllerDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl *totalControl;

@property (retain, nonatomic) IBOutlet UIView *makeOrderView;
@property (retain, nonatomic) IBOutlet UIView *orderNoteView;


@end
