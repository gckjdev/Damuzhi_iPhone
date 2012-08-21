//
//  RouteDetailController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-18.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteDetailController.h"
#import "UIImageUtil.h"
#import "AppUtils.h"
#import "AppManager.h"
#import "ImageName.h"
#import "SlideImageView.h"
#import "FontSize.h"
@implementation RouteDetailController

@synthesize tip = _tip;
@synthesize imageHolderView;
@synthesize routeNameLabel;
@synthesize detailIntroView;
@synthesize scrollView;

- (void)viewDidLoad
{
//    [self setBackgroundImageName:@"all_page_bg2.jpg"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    
    [self setNavigationLeftButton:@" 返回" 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

    [self addSlideImageView];
    
    [scrollView setContentSize:detailIntroView.frame.size];
    
    [routeNameLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"detail_shadow.png"]]];
    [routeNameLabel setTextColor:[UIColor colorWithRed:36.0/255.0 green:65.0/255.0 blue:79.0/255.0 alpha:1]];
    [routeNameLabel setText:_tip.name];
    [routeNameLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [routeNameLabel setTextAlignment:UITextAlignmentCenter];
    
    [detailIntroView setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];

    UILabel *label = [[UILabel alloc] init];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];

    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1]];
    
    NSString *detailIntro = [NSString stringWithFormat:@"       %@", [_tip.detailIntro stringByReplacingOccurrencesOfString:@"\n" withString:@"       \n"]];

    CGSize constrainedSize = CGSizeMake(detailIntroView.frame.size.width, CGFLOAT_MAX);
    CGSize detailIntroSize = [detailIntro sizeWithFont:label.font constrainedToSize:constrainedSize lineBreakMode:label.lineBreakMode];
    [label setFrame:CGRectMake(0, 0, detailIntroView.frame.size.width, detailIntroSize.height)];
    [label setText:detailIntro];
    
    if (detailIntroSize.height > detailIntroView.frame.size.height) {
        
        float increaseHeight = detailIntroSize.height - detailIntroView.frame.size.height;
        
        [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 
                                              scrollView.frame.size.height + increaseHeight)];
        
        [detailIntroView setFrame:CGRectMake(detailIntroView.frame.origin.x, 
                                             detailIntroView.frame.origin.y,
                                             detailIntroView.frame.size.width,
                                             detailIntroSize.height)];
        
    }
//    [detailIntroView setFrame:CGRectMake(detailIntroView.frame.origin.x, 
//                                         detailIntroView.frame.origin.y,
//                                         detailIntroView.frame.size.width,
//                                         1000)];
//
//    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 
//                                          1000)];
    
    [detailIntroView addSubview:label];
    [label release];
    
    
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setDetailIntroView:nil];
    [self setScrollView:nil];
    [self setImageHolderView:nil];
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
    [_tip release];
    [routeNameLabel release];
    [detailIntroView release];
    [scrollView release];
    [imageHolderView release];
    [super dealloc];
}

- (RouteDetailController*)initWithDataSource:(CommonTravelTip*)tip
{
    self = [super init];
    if (self) {
        self.tip = tip;
    }
    
    return self;
}

- (void)addSlideImageView
{
    NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
    
    if ([AppUtils isShowImage]) {
        //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
        for (NSString *image in _tip.imagesList) {
            NSString *path = [AppUtils getAbsolutePath:[AppUtils getCityDir:[[AppManager defaultManager] getCurrentCityId]] string:image];
            [imagePathList addObject:path];
        }
    }
    else {
        [imagePathList addObject:IMAGE_PLACE_DETAIL];
    }
    
    SlideImageView *slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    slideImageView.defaultImage = IMAGE_PLACE_DETAIL;
    [slideImageView.pageControl setPageIndicatorImageForCurrentPage:[UIImage strectchableImageName:@"point_pic3.png"] forNotCurrentPage:[UIImage strectchableImageName:@"point_pic4.png"]];
    [slideImageView setImages:imagePathList];
    [imageHolderView addSubview:slideImageView];
    [imagePathList release];
    [slideImageView release];
}

@end
