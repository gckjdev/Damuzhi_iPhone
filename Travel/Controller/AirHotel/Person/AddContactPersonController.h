//
//  AddContactPersonController.h
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "PPTableViewController.h"

@class Person;

@interface AddContactPersonController : PPTableViewController
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;

- (id)initWithIsAdd:(BOOL)isAdd person:(Person *)person isMember:(BOOL)isMember;

@end
