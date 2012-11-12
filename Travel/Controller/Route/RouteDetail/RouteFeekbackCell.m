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
#import "UserManager.h"
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
    
    // routeFeekback.nickName is already trimmed by method stringByTrimmingCharactersInSet:
    if (routeFeekback.nickName == nil || [routeFeekback.nickName isEqualToString:@""]) 
    {
        NSString *loginIdString = routeFeekback.loginId;
        NSString *str1 = [loginIdString substringToIndex:3]; 
        NSString *str2 = [loginIdString substringFromIndex:7];
        NSString *modifiedLoginIdString = [NSString stringWithFormat:@"%@****%@", str1, str2];
        userNameLabel.text = modifiedLoginIdString;
    }
    else 
    {
        userNameLabel.text = routeFeekback.nickName;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:routeFeekback.date - 8 * 3600];
    dateLabel.text = dateToStringByFormat(date, DATE_FORMAT);
    PPDebug(@"feedback date is %@",  dateToStringByFormat(date,  @"yyyy-MM-dd hh:mm"));
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
    
    CGSize withinSize = CGSizeMake(contentLabel.frame.size.width, MAXFLOAT);
    CGSize size = [routeFeekback.content sizeWithFont:contentLabel.font constrainedToSize:withinSize lineBreakMode:contentLabel.lineBreakMode];
    
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, size.height);
    
    static long methodCalledTimes = 1;
    if(methodCalledTimes % 2 == 1){
        bgImageView.image = [[ImageManager defaultManager] routeFeekbackBgImage1];
        bgImageView.frame = CGRectMake(11 + 4, bgImageView.frame.origin.y, bgImageView.frame.size.width, size.height + 40);
    }
    else
    {
        bgImageView.image = [[ImageManager defaultManager] routeFeekbackBgImage2]; 
        bgImageView.frame = CGRectMake(11 - 4, bgImageView.frame.origin.y, bgImageView.frame.size.width, size.height + 40);
    }
    methodCalledTimes++;
    
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
