//
//  RetrievePasswordController.m
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RetrievePasswordController.h"
#import "PPDebug.h"
#import "PPViewController.h"
#import "StringUtil.h"
#import "PPNetworkRequest.h"
#import "FontSize.h"
#import "ImageManager.h"

@interface RetrievePasswordController ()
@property (copy, nonatomic) NSString *loginId;
@end


@implementation RetrievePasswordController
@synthesize loginIdTextField;
@synthesize backgroundScrollView;
@synthesize loginId = _loginId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"找回密码");
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"  
                            action:@selector(clickOk:)];
    
    backgroundScrollView.contentSize = CGSizeMake(backgroundScrollView.frame.size.width, backgroundScrollView.frame.size.height + 1);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];

}

- (void)viewDidUnload
{
    [self setLoginIdTextField:nil];
    [self setBackgroundScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [loginIdTextField release];
    [backgroundScrollView release];
    [_loginId release];
    [super dealloc];
}
- (IBAction)hideKeyboard:(id)sender {
    [loginIdTextField resignFirstResponder];
}

-(void)clickOk:(id)sender
{
    [self hideKeyboard:nil];
    self.loginId = [self.loginIdTextField.text
                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (!NSStringIsValidPhone(_loginId)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    [[UserService defaultService] retrievePassword:loginIdTextField.text delegate:self];
    
}

- (void)retrievePasswordDidSend:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    
//    _signUpButton.enabled = YES;
    
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，找回密码失败") title:nil];
        return;
    }
    
    if (result != 0 ) {
        NSString *text = [NSString stringWithFormat:NSLS(@"找回密码失败: %@"), resultInfo];
        [self popupMessage:text title:nil];
        return;
    }
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"账号密码已发送到您的手机，请注意查收" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self.navigationController popViewControllerAnimated:YES];
}
 

@end







