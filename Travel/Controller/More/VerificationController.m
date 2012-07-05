//
//  VerificationController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "VerificationController.h"
#import "UserManager.h"
#import "PPNetworkRequest.h"
#import "StringUtil.h"

@interface VerificationController ()

@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *code;

@end

@implementation VerificationController
@synthesize telephone = _telephone;
@synthesize code = _code;
@synthesize loginController = _loginController;

@synthesize telephoneTextField;
@synthesize codeTextField;
@synthesize hideKeyboardButton;

- (void)dealloc {
    [_telephone release];
    [_code release];
    [_loginController release];
    
    [telephoneTextField release];
    [codeTextField release];
    [hideKeyboardButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickFinish:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
        
    telephoneTextField.delegate = self;
    codeTextField.delegate = self;
}

- (void)viewDidUnload
{
    [self setTelephoneTextField:nil];
    [self setCodeTextField:nil];
    [self setHideKeyboardButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickRetrieveCodeButton:(id)sender {
    self.telephone = telephoneTextField.text;
    
    [self.navigationController popToViewController:self.loginController animated:YES];
//    [[UserService defaultService] verificate:[[UserManager defaultManager] loginId] telephone:_telephone delegate:self];
}

- (IBAction)clickHideKeyboardButton:(id)sender {
    [self hideKeyboard];
    hideKeyboardButton.enabled = NO;
}

- (void)hideKeyboard
{
    [telephoneTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    hideKeyboardButton.enabled = YES;
}

- (void)clickFinish:(id)sender
{
    if (!NSStringIsValidPhone(telephoneTextField.text)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    [[UserService defaultService] verificate:telephoneTextField.text code:codeTextField.text delegate:self];
}

- (void)verificationDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，获取验证码失败") title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"等待接收验证码") title:nil];
}

- (void)verificationDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，验证失败") title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"验证成功") title:nil];
}


@end
