//
//  CommonInfoController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityBasicController.h"
#import "SlideImageView.h"
#import "CityOverviewService.h"
#import "AppManager.h"
#import "AppUtils.h"
#import "ImageName.h"
#import "PPNetworkRequest.h"
#import "PPDebug.h"
#import "UIImageUtil.h"
#import "FontSize.h"
@implementation CityBasicController

@synthesize scrollView;
@synthesize imageHolderView;
@synthesize dataWebview;
@synthesize dataSource;

- (void)dealloc {
    [dataSource release];
    [imageHolderView release];
    [dataWebview release];
    [scrollView release];
    [super dealloc];
}

- (id)initWithDataSource:(NSObject<CommonInfoDataSourceProtocol>*)source
{
    self = [super init];
    if (self) {
        self.dataSource = source;
    }
    
    return self;
}

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
    
    [self.navigationItem setTitle:[dataSource getTitleName]];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
        
    dataWebview.delegate = self;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
    [scrollView addSubview:imageView];
    [imageView release];

    scrollView.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:230.0/255.0 alpha:1];
    [dataSource requestDataWithDelegate:self];
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    PPDebug(@"webview document body scrollHeight is %@ high",heightString);

    //set webview frame
    CGRect webViewFrame = webView.frame;
    webViewFrame.size = CGSizeMake(webView.frame.size.width, [heightString floatValue]);
    webView.frame = webViewFrame;
    
    //set scrollview frame
    CGSize sz = scrollView.bounds.size;
    sz.height = webView.frame.size.height + imageHolderView.frame.size.height;
    scrollView.contentSize = sz;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollView.contentSize.height, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
    [scrollView addSubview:imageView];
    [imageView release];
}

- (void)findRequestDone:(int)result overview:(CommonOverview*)overview;
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络弱，数据加载失败") title:nil];
        return;
    }
    
    [self initDataSource:overview];
}

- (void)initDataSource:(CommonOverview*)overview
{
    NSString* htmlString = [overview html];
    NSArray *imageList = [overview imagesList];
    
    //handle urlString, if there has local data, urlString is a relative path, otherwise, it is a absolute URL.
    
    NSString *htmlPath = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:htmlString];
    
    NSURL *url = [AppUtils getNSURLFromHtmlFileOrURL:htmlPath];
    
    //request from a url, load request to web view.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    PPDebug(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebview loadRequest:request];        
    }
    
    //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
    NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
    for (NSString *image in imageList) {
        NSString *imgaePath = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:image];
        
        //        NSLog(@"image path = %@", imgaePath);
        [imagePathList addObject:imgaePath];
    }
    
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:imagePathList];
    [self.imageHolderView addSubview:slideImageView];
    
    [slideImageView release];
    [imagePathList release];
}

- (void)viewDidUnload
{
    [self setImageHolderView:nil];
    [self setDataWebview:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
