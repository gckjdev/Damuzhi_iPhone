//
//  CommonWebController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonWebController.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "PPDebug.h"
#import "PPNetworkRequest.h"
#import "UIViewUtils.h"
#import "FontSize.h"
#import "DeviceDetection.h"
#import "WebViewConstants.h"
#import "XQueryComponents.h"

@implementation CommonWebController

@synthesize htmlPath = _htmlPath;
@synthesize webView;
@synthesize dataSource;


- (CommonWebController*)initWithWebUrl:(NSString*)htmlPath
{
    self = [super init];
    if (self){
        self.htmlPath = htmlPath;
    }
    return self;
}


- (id)initWithDataSource:(NSObject<CommonWebDataSourceProtocol>*)source
{
    self = [super init];
    if (self) {
        self.dataSource = source;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

    webView.delegate = self;
    
    if (dataSource) {
        [self.navigationItem setTitle:[dataSource getTitleName]];
        [dataSource requestDataWithDelegate:self];
    }
    else {
        //handle urlString, if there has local data, urlString is a relative path, otherwise, it is a absolute URL.
        NSURL *url = nil;
        if (_htmlPath) {
            url = [AppUtils getNSURLFromHtmlFileOrURL:_htmlPath];
        }
        
        //request from a url, load request to web view.
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        if (request) {
            [self.webView loadRequest:request];        
        }
    }
    
    if ([DeviceDetection isOS5]) {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)] autorelease];
        [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
        [webView.scrollView addSubview:imageView];
    }
    
    webView.backgroundColor = [UIColor colorWithRed:211/255.0 green:215/255.0 blue:218/255.0 alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startObservingContentSizeChangesInWebView:webView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopObservingContentSizeChangesInWebView:webView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (void)dealloc {
    [_htmlPath release];
    [webView release];

    [super dealloc];
}


#pragma mark -
#pragma mark: implementation of web view delegate.
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    PPDebug(@"<LocalRouteIntroductionController> url:%@", request.URL);
    
    NSURL *URL = request.URL;
    NSString *scheme = URL.scheme;
    NSString *host = URL.host;
    
    if ([scheme isEqualToString:WEB_SCHEME_DMZ] &&
        [host isEqualToString:WEB_MAKE_CALL])
    {
        NSString *phone = [URL.queryComponents objectForKey:WEB_PHONE_NUM];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:NSLS(@"是否拨打以下电话") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [actionSheet addButtonWithTitle:phone];
        [actionSheet addButtonWithTitle:NSLS(@"返回")];
        [actionSheet setCancelButtonIndex:[[[AppManager defaultManager] getServicePhoneList] count]];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView1
{
    [self showActivityWithText:NSLS(@"数据加载中...")];
}

#define TAG_FOOTER_BACKGROUND   2013030201
- (void)webViewDidFinishLoad:(UIWebView *)webView1
{
    if ([DeviceDetection isOS5]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, webView1.scrollView.contentSize.height, 320, 250)];
        imageView.tag = TAG_FOOTER_BACKGROUND;
        [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
        [webView1.scrollView addSubview:imageView];
        [imageView release];
    }
    
    [self hideActivity];
 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self popupMessage:@"web页面加载失败" title:nil];
    [self hideActivity];
}

#pragma mark - CityOverviewServiceDelegate
- (void)findRequestDone:(int)result overview:(CommonOverview*)overview
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
        return;
    }
    
    [self loadHtml:overview];
}

- (void)loadHtml:(CommonOverview*)overview
{
    NSString* htmlString = [overview html];
    
    //handle urlString, if there has local data, urlString is a relative path, otherwise, it is a absolute URL.
    
    NSString *htmlPath = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:htmlString];
    
    NSURL *url = [AppUtils getNSURLFromHtmlFileOrURL:htmlPath];
    
    //request from a url, load request to web view.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    PPDebug(@"load webview url = %@", [request description]);
    if (request) {
        [self.webView loadRequest:request];        
    }
}

-(void) showInView:(UIView *)superView
{
//    [superView removeAllSubviews];
    webView.frame = superView.bounds;
    [superView addSubview:self.view];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSString *phone = [[[AppManager defaultManager] getServicePhoneList] objectAtIndex:buttonIndex];
    //    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [UIUtils makeCall:phone];
}



static int kObservingContentSizeChangesContext;

- (void)startObservingContentSizeChangesInWebView:(UIWebView *)ontWebView {
    [ontWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:&kObservingContentSizeChangesContext];
}

- (void)stopObservingContentSizeChangesInWebView:(UIWebView *)ontWebView {
    [ontWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:&kObservingContentSizeChangesContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kObservingContentSizeChangesContext) {
        
        
        NSArray *subViews = [webView.scrollView subviews];
        for (UIView *subView in subViews) {
            if ([subView isKindOfClass:[UIImageView class]]&& subView.tag == TAG_FOOTER_BACKGROUND) {
                [subView removeFromSuperview];
            }
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, webView.scrollView.contentSize.height, 320, 250)];
        imageView.tag = TAG_FOOTER_BACKGROUND;
        [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
        [webView.scrollView addSubview:imageView];
        [imageView release];
        
//        UIScrollView *scrollView = object;
//        NSLog(@"%@ contentSize changed to %@", scrollView, NSStringFromCGSize(scrollView.contentSize));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end





