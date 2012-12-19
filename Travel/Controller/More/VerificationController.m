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
#import "UIImageUtil.h"
#import "FontSize.h"
#import "ImageManager.h"

@interface VerificationController ()

@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *code;

@end

@implementation VerificationController
@synthesize telephone = _telephone;
@synthesize code = _code;
@synthesize backgroundScrollView;
@synthesize loginController = _loginController;
@synthesize retrieveCodeButton;

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
    [retrieveCodeButton release];
    [backgroundScrollView release];
    [super dealloc];
}

- (id)initWithTelephone:(NSString *)telephone
{
    if (self = [super init]) {
        self.telephone = telephone;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:NSLS(@"注册验证")];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickFinish:)];
    
    [self.backgroundScrollView setContentSize:CGSizeMake(self.backgroundScrollView.frame.size.width, self.backgroundScrollView.frame.size.height+1)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    [retrieveCodeButton setBackgroundImage:[UIImage strectchableImageName:@"order_btn_1.png" leftCapWidth:20] forState:(UIControlStateNormal)];
        
//    telephoneTextField.delegate = self;
    codeTextField.delegate = self;
    
    telephoneTextField.text = _telephone;
}

- (void)viewDidUnload
{
    [self setTelephoneTextField:nil];
    [self setCodeTextField:nil];
    [self setHideKeyboardButton:nil];
    [self setRetrieveCodeButton:nil];
    [self setBackgroundScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)clickRetrieveCodeButton:(id)sender {
    retrieveCodeButton.enabled = NO;

    [[UserService defaultService] verificate:_telephone telephone:_telephone delegate:self];
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
//    if (!NSStringIsValidPhone(telephoneTextField.text)) {
//        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
//        return;
//    }
    NSString *str = codeTextField.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (0 == [str length]) 
    {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"您输入的验证码为空，请重新输入" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [[UserService defaultService] verificate:telephoneTextField.text code:codeTextField.text delegate:self];
}

- (void)verificationDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    retrieveCodeButton.enabled = YES;
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，获取验证码失败") title:nil];
        return;
    }
    
    if (result != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:resultInfo delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

@end
