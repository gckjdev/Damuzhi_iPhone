//
//  LocalRouteIntroductionController.h
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"

@protocol LocalRouteIntroductionControllerDelegage <NSObject>

@optional
- (void)didClickBookingButton;
- (void)didClickDepartPlace:(int)departPlaceId;
- (void)didClickRelatePlace:(int)RelatePlaceId;
- (void)didClickFollow;
@end



@class LocalRoute;

@interface LocalRouteIntroductionController : PPViewController <UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *overallScrollView;
@property (retain, nonatomic) IBOutlet UIView *imagesHolderView;
@property (retain, nonatomic) IBOutlet UIView *bookingHolderView;
@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;
@property (retain, nonatomic) IBOutlet UILabel *priceLable;
@property (retain, nonatomic) IBOutlet UILabel *priceLastLabel;
@property (retain, nonatomic) IBOutlet UIButton *bookingButton;
@property (retain, nonatomic) id<LocalRouteIntroductionControllerDelegage> delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *LoadWebActivityView;

- (void)showInView:(UIView *)superView;
- (void)updateWithRoute:(LocalRoute *)route;
- (void)loadDetailHtml:(NSString *)detailUrl;

@end
