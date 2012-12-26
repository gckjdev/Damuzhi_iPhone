//
//  AddCreditCardController.h
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "PPTableViewController.h"
#import "AddPersonCell.h"
#import "SelectController.h"

@interface AddCreditCardController : PPTableViewController<AddPersonCellDelegate, SelectControllerDelegate>
@property (retain, nonatomic) IBOutlet UIView *datePickerHolderView;

@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerView;

@end
