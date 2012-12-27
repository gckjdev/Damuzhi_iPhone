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
#import "SRMonthPicker.h"

@class CreditCard;

@interface AddCreditCardController : PPTableViewController<AddPersonCellDelegate, SelectControllerDelegate, SRMonthPickerDelegate>
@property (retain, nonatomic) IBOutlet UIView *datePickerHolderView;
@property (retain, nonatomic) IBOutlet SRMonthPicker *monthPicker;

- (id)initWithIsAdd:(BOOL)isAdd creditCard:(CreditCard *)creditCard;

@end
