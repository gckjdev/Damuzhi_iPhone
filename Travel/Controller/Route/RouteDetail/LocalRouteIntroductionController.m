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
#import "ImageManager.h"

@interface LocalRouteIntroductionController ()



@end

@implementation LocalRouteIntroductionController
@synthesize overallScrollView;
@synthesize imagesHolderView;
@synthesize bookingHolderView;
@synthesize contentWebView;
@synthesize priceLable;
@synthesize priceLastLabel;
@synthesize bookingButton;
@synthesize followButton;
@synthesize delegate;

- (void)dealloc {
    [imagesHolderView release];
    [contentWebView release];
    [overallScrollView release];
    [priceLable release];
    [followButton release];
    [bookingHolderView release];
    [bookingButton release];
    [priceLastLabel release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bookingHolderView setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] routeDetailAgencyBgImage]]];
    [bookingButton setImage:[[ImageManager defaultManager] bookButtonImage] forState:UIControlStateNormal];
    
    
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
    [self setBookingHolderView:nil];
    [self setBookingButton:nil];
    [self setPriceLastLabel:nil];
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
    self.priceLable.text = route.price;
    
    CGSize priceSize = [route.price sizeWithFont:self.priceLable.font];
    self.priceLastLabel.frame = CGRectMake(self.priceLable.frame.origin.x + priceSize.width, self.priceLastLabel.frame.origin.y , self.priceLastLabel.frame.size.width, self.priceLastLabel.frame.size.height);
    
    
    //load html
    PPDebug(@"detailUrl:%@",route.detailUrl);
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
    
    if (actualSize.height > webView.frame.size.height){
        webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, actualSize.height);
        webView.alpha = 1.0;
        
        CGFloat followButtonY = webView.frame.origin.y + webView.frame.size.height +  5;
        followButton.frame = CGRectMake(followButton.frame.origin.x, followButtonY, followButton.frame.size.width, followButton.frame.size.height);
        
        CGFloat overallScrollViewHeight = followButton.frame.origin.y + followButton.frame.size.height + 10;
        overallScrollView.contentSize = CGSizeMake(overallScrollView.contentSize.width, overallScrollViewHeight);
    }
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
