//
//  LocalRouteIntroductionController.m
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteIntroductionController.h"
#import "TouristRoute.pb.h"
#import "SlideImageView.h"
#import "ImageName.h"
#import "UIImageUtil.h"

@interface LocalRouteIntroductionController ()



@end

@implementation LocalRouteIntroductionController
@synthesize overallScrollView;
@synthesize imagesHolderView;
@synthesize contentWebView;
@synthesize priceLable;

- (void)dealloc {
    [imagesHolderView release];
    [contentWebView release];
    [overallScrollView release];
    [priceLable release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.overallScrollView.contentSize = CGSizeMake(self.overallScrollView.frame.size.width , self.overallScrollView.frame.size.height + 1);
    
    self.overallScrollView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [self setImagesHolderView:nil];
    [self setContentWebView:nil];
    [self setOverallScrollView:nil];
    [self setPriceLable:nil];
    [super viewDidUnload];
}

- (void)updateWithRoute:(LocalRoute *)route
{
    //load images
    SlideImageView *slideImageView = [[[SlideImageView alloc] initWithFrame:imagesHolderView.bounds] autorelease];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    
    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:route.detailImagesList];
    
    [imagesHolderView addSubview:slideImageView];
    
    
    //set price
    self.priceLable.text = [NSString stringWithFormat:@"%@  立即预订", route.price];
    
    
    //load html
    NSURL *requestUrl = [NSURL URLWithString:route.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    self.contentWebView.alpha = 0.0;
    self.contentWebView.delegate = self;
    [self.contentWebView loadRequest:request];
    
}

#pragma mark - 
#pragma UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    webView.alpha = 1.0;
}

- (void)showInView:(UIView *)superView
{
    [superView addSubview:self.view];
}




@end
