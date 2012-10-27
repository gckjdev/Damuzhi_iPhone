//
//  PlaceOrderCell.m
//  Travel
//
//  Created by haodong qiu on 12年7月12日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PlaceOrderCell.h"
#import "LocaleUtils.h"
@interface PlaceOrderCell()

- (void)clickLeftButton:(id)sender;
- (void)clickRightButton:(id)sender;

@end


@implementation PlaceOrderCell
@synthesize backgroundImageView;
@synthesize pointImageView;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize leftButton;
@synthesize rightButton;

- (void)dealloc {
    [titleLabel release];
    [contentLabel release];
    [pointImageView release];
    [backgroundImageView release];
    [leftButton release];
    [rightButton release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"PlaceOrderCell";
}

+ (CGFloat)getCellHeight
{
    return 54.0f;
}

- (void)setCellWithIndexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    
    [leftButton addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickLeftButton:(id)sender
{
    

    if ([delegate respondsToSelector:@selector(didClickLeftButton:)]) {
        [delegate didClickLeftButton:self.indexPath];
    }
}

- (void)clickRightButton:(id)sender
{
    if ([delegate respondsToSelector:@selector(didClickRightButton:)]) {
        [delegate didClickRightButton:self.indexPath];
    }
}


@end
