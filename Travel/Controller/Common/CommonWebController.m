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
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

    webView.delegate = self;

    if (dataSource) {
        [self.navigationItem setTitle:[dataSource getTitleName]];
        [dataSource requestDataWithDelegate:self];
    }
    else {
        //handle urlString, if there has local data, urlString is a relative path, otherwise, it is a absolute URL.
        NSURL *url = [AppUtils getNSURLFromHtmlFileOrURL:_htmlPath];
        
        //request from a url, load request to web view.
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        if (request) {
            [self.webView loadRequest:request];        
        }
    }
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
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityWithText:NSLS(@"数据加载中...")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
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
    switch (result) {
        case ERROR_SUCCESS:
            [self loadHtml:overview];
            break;
        case ERROR_NETWORK:
            [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
            break;
            
        case ERROR_CLIENT_URL_NULL:
            [self popupMessage:NSLS(@"ERROR_CLIENT_URL_NULL") title:nil];
            break;
            
        case ERROR_CLIENT_REQUEST_NULL:
            [self popupMessage:NSLS(@"ERROR_CLIENT_REQUEST_NULL") title:nil];
            break;
            
        case ERROR_CLIENT_PARSE_JSON:
            [self popupMessage:NSLS(@"ERROR_CLIENT_PARSE_JSON") title:nil];
            break;
            
        default:
            break;
    }
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

@end
