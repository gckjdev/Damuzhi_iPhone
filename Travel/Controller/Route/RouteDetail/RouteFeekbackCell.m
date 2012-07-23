//
//  RouteFeekbackCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteFeekbackCell.h"
#import "TimeUtils.h"
#import "PPDebug.h"

#import "ImageManager.h"

@interface RouteFeekbackCell ()

@end

@implementation RouteFeekbackCell
@synthesize displayRankImage1;
@synthesize displayRankImage2;
@synthesize displayRankImage3;
@synthesize userNameLabel;
@synthesize dateLabel;
@synthesize contentLabel;
@synthesize bgImageView;

+ (CGFloat)getCellHeight
{
    return 120;
}

+ (NSString *)getCellIdentifier
{
    return @"RouteFeekbackCell";
}

- (void)setCellData:(RouteFeekback *)routeFeekback
{

    userNameLabel.text = routeFeekback.nickName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:routeFeekback.date];
    dateLabel.text = dateToStringByFormat(date, DATE_FORMAT);
    contentLabel.text = routeFeekback.content;
    
    
    if (routeFeekback.rank == 1) 
    {

        displayRankImage1.image = [[ImageManager defaultManager] rankGoodImage];
    }
    else if(routeFeekback.rank == 2)
    {
        displayRankImage1.image = [[ImageManager defaultManager] rankGoodImage];
        displayRankImage2.image = [[ImageManager defaultManager] rankGoodImage];
    }
    else if(routeFeekback.rank == 3)
    {
        displayRankImage1.image = [[ImageManager defaultManager] rankGoodImage];
        displayRankImage2.image = [[ImageManager defaultManager] rankGoodImage];
        displayRankImage3.image = [[ImageManager defaultManager] rankGoodImage];
           
    }
    
    static int count = 1;
    if(count % 2 == 1){
        bgImageView.image = [[ImageManager defaultManager] routeFeekbackBgImage1];
    }
    else
        bgImageView.image = [[ImageManager defaultManager] routeFeekbackBgImage2]; 
    count++;
    
    CGSize withinSize = CGSizeMake(contentLabel.frame.size.width, MAXFLOAT);
    CGSize size = [routeFeekback.content sizeWithFont:contentLabel.font constrainedToSize:withinSize lineBreakMode:contentLabel.lineBreakMode];
    
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, size.height);
    
}

- (void)dealloc {
    [userNameLabel release];
    [dateLabel release];
    [contentLabel release];
    [bgImageView release];
    [displayRankImage1 release];
    [displayRankImage2 release];
    [displayRankImage3 release];
    [super dealloc];
}

@end
