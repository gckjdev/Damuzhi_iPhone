//
//  SignUpController.h
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"
#import "UserService.h"

@interface SignUpController : PPTableViewController <UITextFieldDelegate, UserServiceDelegate>

@property (retain, nonatomic) UIViewController *superController;

@property (retain, nonatomic) IBOutlet UITextField *loginIdTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UITextField *comfirmPasswordTextField;

@end
