//
//  ShareToSinaController.m
//  Travel
//
//  Created by haodong qiu on 12年4月6日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShareToSinaController.h"
#import "LogUtil.h"
#import "LocaleUtils.h"
#import "AppDelegate.h"
#import "MobClick.h"

#define UMENG_ONLINE_SINA_WEIBO_APP_KEY       @"sina_weibo_app_key"
#define UMENG_ONLINE_SINA_WEIBO_APP_SECRET    @"sina_weibo_app_secret"

@interface ShareToSinaController ()

@property (nonatomic, retain) WBEngine *sinaWeiBoEngine;
@property (nonatomic, retain) UITextView *contentTextView;
@property (nonatomic, retain) UILabel *wordsNumberLabel;

@end

@implementation ShareToSinaController
@synthesize sinaWeiBoEngine;
@synthesize contentTextView;
@synthesize wordsNumberLabel;

- (void)dealloc
{
    [sinaWeiBoEngine release];
    [contentTextView release];
    [wordsNumberLabel release];
    [super dealloc];
}

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
    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:84.0/255.0 green:154.0/255.0 blue:182.0/255.0 alpha:1.0];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"发送") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(sendSinaWeibo:)];
    
    self.navigationItem.title = NSLS(@"分享到新浪微博");
    
    [self createSendView];
    
    NSString *appKey = [MobClick getConfigParams:UMENG_ONLINE_SINA_WEIBO_APP_KEY];
    NSString *appSecret = [MobClick getConfigParams:UMENG_ONLINE_SINA_WEIBO_APP_SECRET];
    
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:appKey appSecret:appSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.sinaWeiBoEngine = engine;
    [engine release]; 
    
    if (![sinaWeiBoEngine isLoggedIn]) {
        [sinaWeiBoEngine logIn];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setSinaWeiBoEngine:nil];
    [self setContentTextView:nil];
    [self setWordsNumberLabel:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (IBAction)backgroundTap:(id)sender
{
    [contentTextView resignFirstResponder];
}

#define WEIBO_LOGO_WIDTH    98
#define WEIBO_LOGO_HEIGHT   30
#define WORDSNUMBER_WIDTH   30
#define WORDSNUMBER_HEIGHT  20
#define CONTENT_WIDTH       284
#define CONTENT_HEIGHT      132

- (void)createSendView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-CONTENT_WIDTH)/2, 0, WEIBO_LOGO_WIDTH, WEIBO_LOGO_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"SinaWeibo_logo.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((320-CONTENT_WIDTH)/2+CONTENT_WIDTH-WORDSNUMBER_WIDTH, WEIBO_LOGO_HEIGHT-WORDSNUMBER_HEIGHT, WORDSNUMBER_WIDTH, WORDSNUMBER_HEIGHT)];
    label.text = @"0";
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    //label.backgroundColor = [UIColor blueColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    self.wordsNumberLabel = label;
    [label release];
    
    UIImageView *textBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feedback_bg2.png"]];
    textBackgroundView.frame = CGRectMake((320-CONTENT_WIDTH)/2, WEIBO_LOGO_HEIGHT, CONTENT_WIDTH, CONTENT_HEIGHT);
    [self.view addSubview:textBackgroundView];
    [textBackgroundView release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake((320-CONTENT_WIDTH)/2, WEIBO_LOGO_HEIGHT, CONTENT_WIDTH, CONTENT_HEIGHT)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = [NSString stringWithFormat:NSLS(@"kShareContent"),[MobClick getConfigParams:@"download_website"]];
    textView.backgroundColor = [UIColor clearColor];
    self.contentTextView = textView;
    [textView release];
    
    [self.view addSubview:wordsNumberLabel];
    [self.view addSubview:contentTextView];
    
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%d",[contentTextView.text length]];
}

- (void)sendSinaWeibo:(id)sender
{
    [contentTextView resignFirstResponder];
    
    if ([sinaWeiBoEngine isLoggedIn]) {
        //发送微博
        [sinaWeiBoEngine sendWeiBoWithText:contentTextView.text image:nil];
        [self showActivity];
    }
    else {
        [sinaWeiBoEngine logIn];
    }
}

#pragma -mark UITextViewDelegate 
- (void)textViewDidChange:(UITextView *)textView
{
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%d",[textView.text length]];
}

#pragma -mark WBEngineDelegate
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSLog(@"已登陆");
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"登陆成功");
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"登陆错误,错误代码:%@",error);
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    NSLog(@"退出成功");
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    NSLog(@"没有授权");
    [self hideActivity];
    [sinaWeiBoEngine logIn];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSLog(@"授权过期");
    [self hideActivity];
    [sinaWeiBoEngine logIn];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"发送失败,error:%@",error);
    [self hideActivity];
    [self popupUnhappyMessage:NSLS(@"发送失败") title:nil];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"发送成功");
    [self hideActivity];
    [self popupHappyMessage:NSLS(@"发送成功") title:nil];
}


@end
