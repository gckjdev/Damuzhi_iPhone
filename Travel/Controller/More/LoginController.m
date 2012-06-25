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

// add by lst
#import "StringUtil.h"
//#define TAG_TEXT_FIELD_LOGIN_ID 19
//#define TAG_TEXT_FIELD_PASSWORD 20

@interface LoginController ()
@property (copy, nonatomic) NSString *loginId;
@property (copy, nonatomic) NSString *password;
//@property (retain, nonatomic) UIButton loginButton;
@end

@implementation LoginController
@synthesize loginIdTextField;
@synthesize passwordTextField;

@synthesize loginId = _loginId;
@synthesize password = _password;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.view.backgroundColor = [UIColor redColor];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickBack:)];
    
    self.navigationItem.title = NSLS(@"登录");
    [self setNavigationRightButton:NSLS(@"登录") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickLogin:)];
    
    
}

- (void)viewDidUnload
{
    
    [self setLoginIdTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// hide the keyboard
- (IBAction)hideKeyboard:(id)sender {
    [self.loginIdTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}



////called whe 'done' key pressed. return NO to ignore
//-(BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//       switch (textField.tag) {
//        case :TAG_TEXT_FIELD_LOGIN_ID
//            [loginIdTextField becomeFirstResponder];
//            break;
//         
//        case :TAG_TEXT_FIELD_PASSWORD
//            [self hideKeyboard:nil]
//            break;
//            
//        default:
//            break;
//    }
//    return YES;
//}








- (void)clickLogin:(id)sender
{
    // To do, check password. 6~16 characters
    
    
    // check the format of loginId and password
    [self hideKeyboard:nil];
    self.loginId = [self.loginIdTextField.text
                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = self.passwordTextField.text;
    
    

    if (!NSStringIsValidPhone(_loginId)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    if (_password.length < 6) {
        [self popupMessage:NSLS(@"您输入的密码太短") title:nil];
        return;
    }
    
    if (_password.length > 16) {
        [self popupMessage:NSLS(@"您输入的密码长度太长") title:nil];
        return;
    }
    

    // verified by the server to test whether password matched loginId
    [[UserService defaultService] login:loginIdTextField.text
                               password:passwordTextField.text
                               delegate:self];
    
}

- (void)loginDidFinish:(int)success
{
    // check login success code.
    if (success != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，登录失败") title:nil];
        return;
    }
    
    
    // jump to another place
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSignUpButton:(id)sender {
    SignUpController *contoller = [[[SignUpController alloc] init] autorelease];
    contoller.superController = self;
    [self.navigationController pushViewController:contoller animated:YES];
}

- (IBAction)clickRetrievePasswordButton:(id)sender {
    
}

- (IBAction)clickCheckOrdersButton:(id)sender {
    
}







- (void)dealloc {
    [loginIdTextField release];
    [passwordTextField release];
    [super dealloc];
}

- (IBAction)clickAutoLoginButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected; 
}

- (IBAction)clickRememberLoginIdButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberLoginId:button.selected]; // save
    button.selected = !button.selected;
}


- (IBAction)clickRememberPasswordButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberPassword:button.selected]; // save
     button.selected = !button.selected;
}


@end























































