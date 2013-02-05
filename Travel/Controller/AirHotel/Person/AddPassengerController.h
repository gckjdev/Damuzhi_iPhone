//
//  AddPassengerController.h
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "PPTableViewController.h"
#import "AddPersonCell.h"
#import "SelectController.h"

@class Person;

@interface AddPassengerController : PPTableViewController<AddPersonCellDelegate, SelectControllerDelegate>

@property (retain, nonatomic) IBOutlet UIView *datePickerHolderView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePickerView;

- (id)initWithIsAdd:(BOOL)isAdd person:(Person *)person isMember:(BOOL)isMember;

@end
