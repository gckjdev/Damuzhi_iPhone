//
//  AddPassengerController.h
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "PPTableViewController.h"
#import "AddPersonCell.h"

@interface AddPassengerController : PPTableViewController<AddPersonCellDelegate>

@property (retain, nonatomic) IBOutlet UIView *datePickerHolderView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end
