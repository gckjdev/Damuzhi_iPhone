//
//  RouteListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteListCell.h"
#import "LocaleUtils.h"
#import "AppUtils.h"
#import "PPApplication.h"
#import "ImageManager.h"

#define TAG_BEGIN_RANK_IMAGE_VIEW 18

@interface RouteListCell ()

@end

@implementation RouteListCell
@synthesize thumbImageView;
@synthesize nameLabel;
@synthesize tourLabel;
@synthesize rankHolderView;
@synthesize daysLabel;
@synthesize priceLabel;

- (void)dealloc {
    [thumbImageView release];
    [nameLabel release];
    [tourLabel release];
    [rankHolderView release];
    [daysLabel release];
    [priceLabel release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"RouteListCell";
}

+ (CGFloat)getCellHeight
{
    return 76.0;
}

- (void)setCellData:(TouristRoute *)route
{
    [self setRouteThumbImage:route.thumbImage];
    
    [nameLabel setText:route.name];
    [tourLabel setText:route.tour];
    
    [self setRank:route.averageRank];
    
    [daysLabel setText:[NSString stringWithFormat:NSLS(@"行程 : %d天"), route.days]];
    
    [priceLabel setText:route.price];
}

- (void)setRouteThumbImage:(NSString*)thumbImageUrl
{
    if (![AppUtils isShowImage] ) {
        return;
    }
    
    [thumbImageView clear];
    thumbImageView.image = [UIImage imageNamed:@"default_s.png"];
    [thumbImageView showLoadingWheel];
    
    thumbImageView.callbackOnSetImage = self;
    thumbImageView.url = [NSURL URLWithString:thumbImageUrl];
    [GlobalGetImageCache() manage:thumbImageView];
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (void) managedImageCancelled:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (void)setRank:(int)rank
{
    int i = 0;
    
    for ( ; i < 3 ; i ++) {
        int tag = TAG_BEGIN_RANK_IMAGE_VIEW + i;
        UIImageView *rankImageView = (UIImageView*)[rankHolderView viewWithTag:tag];
        if (i<rank) {
            [rankImageView setImage:[[ImageManager defaultManager] rankGoodImage]];
        } else {
            [rankImageView setImage:[[ImageManager defaultManager] rankBadImage]];
        }
    }
}

@end
