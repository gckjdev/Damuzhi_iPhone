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
#import "XQueryComponents.h"
#import "WebViewConstants.h"

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
@synthesize delegate;

- (void)dealloc {
    [imagesHolderView release];
    [contentWebView release];
    [overallScrollView release];
    [priceLable release];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -250, 320, 250)];
    [imageView setImage:[UIImage imageNamed:@"detail_bg_up.png"]];
    [self.overallScrollView addSubview:imageView];
    [imageView release];
    
    //self.overallScrollView.backgroundColor = [UIColor whiteColor];
    self.overallScrollView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    
    self.contentWebView.alpha = 0.0;
    self.contentWebView.userInteractionEnabled = YES;
    self.contentWebView.scrollView.scrollEnabled = NO;
}

- (void)viewDidUnload
{
    [self setImagesHolderView:nil];
    [self setContentWebView:nil];
    [self setOverallScrollView:nil];
    [self setPriceLable:nil];
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
    self.priceLastLabel.text = NSLS(@"起");
    
    //load html
    PPDebug(@"detailUrl:%@",route.detailUrl);
    NSURL *requestUrl = [NSURL URLWithString:route.detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    self.contentWebView.delegate = self;
    [self.contentWebView loadRequest:request];
    
}

#pragma mark - 
#pragma UIWebViewDelegate method

#define TAG_DOWN_BG  12091801

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    
    if (actualSize.height > webView.frame.size.height){
        webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, actualSize.height);
        webView.alpha = 1.0;
        
        CGFloat overallScrollViewHeight = webView.frame.origin.y + webView.frame.size.height;
        overallScrollView.contentSize = CGSizeMake(overallScrollView.contentSize.width, overallScrollViewHeight);
    }
    
    UIImageView *imageView = (UIImageView *)[self.overallScrollView viewWithTag:TAG_DOWN_BG];
    [imageView removeFromSuperview];
    
    UIImageView *imageViewNew = [[UIImageView alloc] initWithFrame:CGRectMake(0, overallScrollView.contentSize.height, 320, 250)];
    imageViewNew.tag = TAG_DOWN_BG;
    [imageViewNew setImage:[UIImage imageNamed:@"detail_bg_down.png"]];
    [self.overallScrollView addSubview:imageViewNew];
    [imageViewNew release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    PPDebug(@"<LocalRouteIntroductionController> url:%@", request.URL);
//    PPDebug(@"scheme:%@", request.URL.scheme);
//    PPDebug(@"host:%@", request.URL.host);
//    PPDebug(@"query:%@", request.URL.query);

    NSURL *URL = request.URL;
    NSString *scheme = URL.scheme;
    NSString *host = URL.host;
    
    if ([scheme isEqualToString:WEB_SCHEME_DMZ] && 
        [host isEqualToString:WEB_HOST_LOCAL_ROUTE])
    {
        NSString *type = [URL.queryComponents objectForKey:WEB_PARA_LOCAL_ROUTE_TYPE];
        
        //click depart palce
        if ([type isEqualToString:WEB_VALUE_LOCAL_ROUTE_DEPART_PLACE]) {
            
            if ([delegate respondsToSelector:@selector(didClickDepartPlace:)]) {
                NSString *deplaceIdStr = [URL.queryComponents objectForKey:WEB_PARA_LOCAL_ROUTE_PLACE_ID];
                int deplaceId = [deplaceIdStr intValue];
                
                [delegate didClickDepartPlace:deplaceId];
            }
        }
        
        //click relate place
        else if ([type isEqualToString:WEB_VALUE_LOCAL_ROUTE_RELATED_PLACE]) {
            if ([delegate respondsToSelector:@selector(didClickRelatePlace:)]) {
                NSString *deplaceIdStr = [URL.queryComponents objectForKey:WEB_PARA_LOCAL_ROUTE_PLACE_ID];
                int deplaceId = [deplaceIdStr intValue];
                
                [delegate didClickRelatePlace:deplaceId];
            }
        } 
        
        //click follow button
        else if ([type isEqualToString:WEB_VALUE_LOCAL_ROUTE_FOLLOW]) {
            if ([delegate respondsToSelector:@selector(didClickFollow)]) {                
                [delegate didClickFollow];
            }
        }
        
        return NO;
    }
    
    return YES;
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
