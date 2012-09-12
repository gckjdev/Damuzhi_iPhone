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
@synthesize followButton;
@synthesize delegate;

- (void)dealloc {
    [imagesHolderView release];
    [contentWebView release];
    [overallScrollView release];
    [priceLable release];
    [followButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.overallScrollView.contentSize = CGSizeMake(self.overallScrollView.frame.size.width , self.overallScrollView.frame.size.height + 1);
    
    self.overallScrollView.backgroundColor = [UIColor whiteColor];
    
    
    self.contentWebView.userInteractionEnabled = NO;
}

- (void)viewDidUnload
{
    [self setImagesHolderView:nil];
    [self setContentWebView:nil];
    [self setOverallScrollView:nil];
    [self setPriceLable:nil];
    [self setFollowButton:nil];
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
    //NSURL *requestUrl = [NSURL URLWithString:route.detailUrl];
    NSURL *requestUrl = [NSURL URLWithString:@"http://api.trip8888.com/Service/ShowArticle.aspx?ArticleId=6"];
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
    
    webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, actualSize.height);
    webView.alpha = 1.0;
    
    CGFloat followButtonY = webView.frame.origin.y + webView.frame.size.height +  5;
    followButton.frame = CGRectMake(followButton.frame.origin.x, followButtonY, followButton.frame.size.width, followButton.frame.size.height);
    
    CGFloat overallScrollViewHeight = followButton.frame.origin.y + followButton.frame.size.height + 8;
    overallScrollView.contentSize = CGSizeMake(overallScrollView.contentSize.width, overallScrollViewHeight);
}

- (IBAction)clickBookingButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickBookingButton)]) {
        [delegate didClickBookingButton];
    }
}

- (void)showInView:(UIView *)superView
{
    [superView addSubview:self.view];
}



@end
