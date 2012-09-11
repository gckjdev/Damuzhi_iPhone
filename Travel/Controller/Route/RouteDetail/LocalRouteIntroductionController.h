//
//  LocalRouteIntroductionController.h
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPViewController.h"

@class LocalRoute;

@interface LocalRouteIntroductionController : PPViewController <UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *overallScrollView;
@property (retain, nonatomic) IBOutlet UIView *imagesHolderView;
@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;
@property (retain, nonatomic) IBOutlet UILabel *priceLable;

- (void)showInView:(UIView *)superView;
- (void)updateWithRoute:(LocalRoute *)route;

@end
