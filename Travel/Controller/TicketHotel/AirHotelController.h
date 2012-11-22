//
//  AirHotelController.h
//  Travel
//
//  Created by kaibin on 12-9-21.
//
//

#import "PPTableViewController.h"
#import "MakeHotelOrderCell.h"


@interface AirHotelController : PPTableViewController <MakeHotelOrderCellDelegate>

@property (retain, nonatomic) IBOutlet UISegmentedControl *totalControl;

@property (retain, nonatomic) IBOutlet UIView *makeOrderView;
@property (retain, nonatomic) IBOutlet UIView *orderNoteView;


@end
