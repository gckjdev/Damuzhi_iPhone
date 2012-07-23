//
//  VerificationController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "UserService.h"

@interface VerificationController : PPTableViewController <UserServiceDelegate, UITextFieldDelegate>

- (id)initWithTelephone:(NSString *)telephone;

@property (retain, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (retain, nonatomic) UIViewController *loginController;
@property (retain, nonatomic) IBOutlet UIButton *retrieveCodeButton;

@property (retain, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UIButton *hideKeyboardButton;

@end
