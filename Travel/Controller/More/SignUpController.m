//
//  SignUpController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SignUpController.h"
//#import "ImageManager.h"
#import "StringUtil.h"
#import "PPNetworkRequest.h"
#import "VerificationController.h"

#define TAG_TEXT_FIELD_LOGIN_ID 19
#define TAG_TEXT_FIELD_PASSWORD 20
#define TAG_TEXT_FIELD_COMFIRM_PASSWORD 21

@interface SignUpController ()

@property (copy, nonatomic) NSString *loginId;
@property (copy, nonatomic) NSString *password;
@property (retain, nonatomic) UIButton *signUpButton;

@end

@implementation SignUpController

@synthesize loginId = _loginId;
@synthesize password = _password;
@synthesize signUpButton = _signUpButton;
@synthesize superController = _superController;

@synthesize loginIdTextField;
@synthesize passwordTextField;
@synthesize comfirmPasswordTextField;

- (void)dealloc {
    [_loginId release];
    [_password release];
    [_signUpButton release];
    [_superController release];
    
    [loginIdTextField release];
    [passwordTextField release];
    [comfirmPasswordTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"注册") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSignUp:)];
    
    [self setTitle:NSLS(@"注册账号")];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
//    self.SignUpBgImageView.image = [[ImageManager defaultManager] signUpBgImage];
    
    loginIdTextField.tag = TAG_TEXT_FIELD_LOGIN_ID;
    passwordTextField.tag = TAG_TEXT_FIELD_PASSWORD;
    comfirmPasswordTextField.tag = TAG_TEXT_FIELD_COMFIRM_PASSWORD;
    
    loginIdTextField.delegate = self;
    passwordTextField.delegate = self;
    comfirmPasswordTextField.delegate = self;
    
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.view addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
}

- (void)viewDidUnload
{
    [self setLoginIdTextField:nil];
    [self setPasswordTextField:nil];
    [self setComfirmPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)clickSignUp:(id)sender
{
    [self hideKeyboard];
    
    self.loginId = [self.loginIdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = self.passwordTextField.text;
    NSString *comfirmPassword = self.comfirmPasswordTextField.text;
    
    if (!NSStringIsValidPhone(_loginId)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    if (_password.length < 6) {
        [self popupMessage:NSLS(@"您输入的密码长度太短") title:nil];
    }
    
    if (_password.length > 16) {
        [self popupMessage:NSLS(@"您输入的密码长度太长") title:nil];
    }
    
    if (![_password isEqualToString:comfirmPassword]) {
        [self popupMessage:NSLS(@"两次输入密码不一致") title:nil];
        self.passwordTextField.text = nil;
        self.comfirmPasswordTextField.text = nil;
        return;
    }
    

    [[UserService defaultService] signUp:_loginId
                                password:_password
                                delegate:self];
    
    if (_signUpButton == nil) {
        self.signUpButton = (UIButton *)sender;
    }
    _signUpButton.enabled = NO;
}

- (void)signUpDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    _signUpButton.enabled = YES;
    
    VerificationController *controller = [[[VerificationController alloc] init] autorelease];
    controller.loginController = self.superController;
    [self.navigationController pushViewController:controller animated:YES];
    
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，注册失败") title:nil];
        return;
    }
    
    if (result == 0 ) {
        [self popupMessage:NSLS(@"注册成功") title:nil];
//        VerificationController *controller = [[[VerificationController alloc] init] autorelease];
//        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    NSString *text = [NSString stringWithFormat:NSLS(@"注册失败: %@"), resultInfo];
    [self popupMessage:text title:nil];
}



// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField              
{
    switch (textField.tag) {
        case TAG_TEXT_FIELD_LOGIN_ID:
            [passwordTextField becomeFirstResponder];
            break;
            
        case TAG_TEXT_FIELD_PASSWORD:
            [comfirmPasswordTextField becomeFirstResponder];
            break;
            
        case TAG_TEXT_FIELD_COMFIRM_PASSWORD:
            [self hideKeyboard];
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (void)hideKeyboard
{
    [self.loginIdTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.comfirmPasswordTextField resignFirstResponder];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
    [self hideKeyboard];
}

@end
