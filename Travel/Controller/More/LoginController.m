//
//  LoginController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LoginController.h"
#import "SignUpController.h"
#import "UserManager.h"
#import "PPNetworkRequest.h"
#import "UIImageUtil.h"
#import "OrderManagerController.h"
#import "ImageManager.h"

#import "StringUtil.h"
#import "RetrievePasswordController.h"
#import "FontSize.h"
@interface LoginController ()

@property (copy, nonatomic) NSString *loginId;
@property (copy, nonatomic) NSString *password;
@property (retain, nonatomic) UIButton *loginButton;

@end

@implementation LoginController
@synthesize autoLoginButton;
@synthesize rememberLoginIdbutton;
@synthesize rememberPasswordButton;
@synthesize backgroundScrollView;


@synthesize loginIdTextField;
@synthesize passwordTextField;
@synthesize checkOrdersButton;

@synthesize loginButton = _loginButton;
@synthesize loginId = _loginId;
@synthesize password = _password;

#pragma mark: Lift cycle

- (void)dealloc {
    [_loginId release];
    [_password release];
    [_loginButton release];
    

    [passwordTextField release];
    
    [checkOrdersButton release];

    [autoLoginButton release];
    [rememberLoginIdbutton release];
    [rememberPasswordButton release];

    [backgroundScrollView release];
    [loginIdTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                         imageName:@"back.png"
                            action:@selector(clickBack:)];
    
    self.navigationItem.title = NSLS(@"登录");
    [self setNavigationRightButton:NSLS(@"登录")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickLogin:)];
   [self.backgroundScrollView setContentSize:CGSizeMake(self.backgroundScrollView.frame.size.width, self.backgroundScrollView.frame.size.height+1)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    UIImage *buttonImageBackground = [UIImage strectchableImageName:@"line_btn1.png"leftCapWidth:20];
    [checkOrdersButton setBackgroundImage:buttonImageBackground forState:UIControlStateNormal];
    
    autoLoginButton.selected = [[UserManager defaultManager] isAutoLogin];
    rememberLoginIdbutton.selected = [[UserManager defaultManager] isRememberLoginId];
    rememberPasswordButton.selected = [[UserManager defaultManager]  isRememberPassword];
    
    if ([[UserManager defaultManager] isRememberLoginId]) {
        loginIdTextField.text = [[UserManager defaultManager] loginId];
    }
    
    if ([[UserManager defaultManager]  isRememberPassword]) {
        passwordTextField.text = [[UserManager defaultManager] password];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    
    [self setLoginIdTextField:nil];
    [self setPasswordTextField:nil];
    [self setCheckOrdersButton:nil];

    [self setAutoLoginButton:nil];
    [self setRememberLoginIdbutton:nil];
    [self setRememberPasswordButton:nil];
    [self setBackgroundScrollView:nil];
    [self setLoginIdTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark: Button action

- (void)clickLogin:(id)sender
{
    // To do, check password. 6~16 characters
    // valid loginId and password
    [self hideKeyboard:nil];
    self.loginId = [self.loginIdTextField.text
                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = self.passwordTextField.text;
    
 
    
    if (!NSStringIsValidEmail(_loginId) && !NSStringIsValidPhone(_loginId)) {
        [self popupMessage:NSLS(@"您输入的用户名格式不正确") title:nil];
        return;
    }
    
//    if (_password.length < 6) {
//        [self popupMessage:NSLS(@"您输入的密码太短") title:nil];
//        return;
//    }
//    
//    if (_password.length > 16) {
//        [self popupMessage:NSLS(@"您输入的密码长度太长") title:nil];
//        return;
//    }
    
    self.loginButton = (UIButton *)sender;
    _loginButton.enabled = NO;
    [[UserService defaultService] login:loginIdTextField.text
                               password:passwordTextField.text
                               delegate:self];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.loginIdTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (IBAction)clickSignUpButton:(id)sender {
    SignUpController *controller = [[[SignUpController alloc] init] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickRetrievePasswordButton:(id)sender {
    RetrievePasswordController *controller = [[RetrievePasswordController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
}

- (IBAction)clickCheckOrdersButton:(id)sender {
    OrderManagerController *controller = [[OrderManagerController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickAutoLoginButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected; 
    
    [[UserManager defaultManager] setAutoLogin:button.selected];
}

- (IBAction)clickRememberLoginIdButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    [[UserManager defaultManager] rememberLoginId:button.selected];  
}

- (IBAction)clickRememberPasswordButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    [[UserManager defaultManager] rememberPassword:button.selected]; 
}


-(IBAction)textFieldDoneEditing:(id)sender;
{
    [sender resignFirstResponder];
}


#pragma mark: implementation of UserServiceDelegate.

- (void)loginDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    _loginButton.enabled = YES;
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，登录失败") title:nil];
        return;
    }
    
    if (result != 0) {
        NSString *str = [NSString stringWithFormat:NSLS(@"登录失败：%@"), resultInfo];
        [self popupMessage:str title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"登录成功") title:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end























































