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
#import "FontSize.h"
#import "ImageManager.h"

#define UMENG_ONLINE_SINA_WEIBO_APP_KEY       @"sina_weibo_app_key"
#define UMENG_ONLINE_SINA_WEIBO_APP_SECRET    @"sina_weibo_app_secret"

#define kAppRedirectURI     @"http://"

@interface ShareToSinaController ()
{
    SinaweiboManager *_sinaweiboManager;
}

@property (nonatomic, retain) UITextView *contentTextView;
@property (nonatomic, retain) UILabel *wordsNumberLabel;

@end

@implementation ShareToSinaController
@synthesize contentTextView;
@synthesize wordsNumberLabel;

- (void)dealloc
{
    [contentTextView release];
    [wordsNumberLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"发送") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(sendSinaWeibo:)];
    
    self.navigationItem.title = NSLS(@"分享到新浪微博");
    
    [self createSendView];
    
    NSString *appKey = [MobClick getConfigParams:UMENG_ONLINE_SINA_WEIBO_APP_KEY];
    NSString *appSecret = [MobClick getConfigParams:UMENG_ONLINE_SINA_WEIBO_APP_SECRET];
    
    _sinaweiboManager = [SinaweiboManager defaultManager];
    [_sinaweiboManager createSinaweiboWithAppKey:appKey appSecret:appSecret appRedirectURI:kAppRedirectURI delegate:self];
    
    if (![_sinaweiboManager.sinaweibo isAuthValid]) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [_sinaweiboManager.sinaweibo logInInView:self.view];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setContentTextView:nil];
    [self setWordsNumberLabel:nil];
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
    
    if ([_sinaweiboManager.sinaweibo isAuthValid]) {
        //发送微博
        [_sinaweiboManager.sinaweibo requestWithURL:@"statuses/update.json"
                                             params:[NSMutableDictionary dictionaryWithObjectsAndKeys:contentTextView.text, @"status", nil]
                                         httpMethod:@"POST"
                                           delegate:self];
        [self showActivity];
    } else {
        [_sinaweiboManager.sinaweibo logInInView:self.view];
    }
}

#pragma -mark UITextViewDelegate 
- (void)textViewDidChange:(UITextView *)textView
{
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%d",[textView.text length]];
}

//#pragma -mark WBEngineDelegate
//- (void)engineAlreadyLoggedIn:(WBEngine *)engine
//{
//    NSLog(@"已登录");
//}
//
//- (void)engineDidLogIn:(WBEngine *)engine
//{
//    NSLog(@"登录成功");
//}
//
//- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
//{
//    NSLog(@"登录错误,错误代码:%@",error);
//}
//
//- (void)engineDidLogOut:(WBEngine *)engine
//{
//    NSLog(@"退出成功");
//}
//
//- (void)engineNotAuthorized:(WBEngine *)engine
//{
//    NSLog(@"没有授权");
//    [self hideActivity];
//    [sinaWeiBoEngine logIn];
//}
//
//- (void)engineAuthorizeExpired:(WBEngine *)engine
//{
//    NSLog(@"授权过期");
//    [self hideActivity];
//    [sinaWeiBoEngine logIn];
//}
//
//- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
//{
//    NSLog(@"发送失败,error:%@",error);
//    [self hideActivity];
//    [self popupUnhappyMessage:NSLS(@"发送失败") title:nil];
//}
//
//- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
//{
//    NSLog(@"发送成功");
//    [self hideActivity];
//    [self popupHappyMessage:NSLS(@"发送成功") title:nil];
//}

#pragma mark - 
#pragma SinaWeiboDelegate methods
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    PPDebug(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [_sinaweiboManager storeAuthData];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    PPDebug(@"sinaweiboDidLogOut");
    [_sinaweiboManager removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    PPDebug(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    PPDebug(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    PPDebug(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [_sinaweiboManager removeAuthData];
}

#pragma mark -
#pragma SinaWeiboRequestDelegate methods
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    PPDebug(@"requestDidFailWithError:%@",error);
    [self hideActivity];
    
    if (error.code == 20019) {
        [self popupUnhappyMessage:NSLS(@"不能重复发送相同的内容") title:nil];
    } else {
        [self popupUnhappyMessage:NSLS(@"发送失败") title:nil];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    PPDebug(@"requestDidFinishLoadingWithResult:%@", result);
    [self hideActivity];
    [self popupHappyMessage:NSLS(@"发送成功") title:nil];
}

@end
