//
//  LocalRouteIntroductionController.m
//  Travel
//
//  Created by haodong on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalRouteIntroductionController.h"

@interface LocalRouteIntroductionController ()

@end

@implementation LocalRouteIntroductionController
@synthesize imagesHolderView;
@synthesize contentWebView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [self setImagesHolderView:nil];
    [self setContentWebView:nil];
    [super viewDidUnload];
    
}

- (void)dealloc {
    [imagesHolderView release];
    [contentWebView release];
    [super dealloc];
}
@end
