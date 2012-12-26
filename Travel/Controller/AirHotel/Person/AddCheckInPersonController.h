//
//  AddCheckInPersonController.h
//  Travel
//
//  Created by haodong on 12-12-24.
//
//

#import "PPViewController.h"

@interface AddCheckInPersonController : PPViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *chineseNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *englishNameTextField;

@end
