//
//  DailySchedulesCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DailyScheduleCell.h"
#import "ImageManager.h"
#import "LocaleUtils.h"
#import "PPDebug.h"

#define COLOR_CONTENT [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]

@interface DailyScheduleCell ()

@end

@implementation DailyScheduleCell
@synthesize titleButton;
@synthesize placeToursBgImageView;
@synthesize diningButton;
@synthesize hotelButton;
@synthesize placeToursTagButton;
@synthesize diningTagButton;
@synthesize hotelTagButton;

+ (NSString*)getCellIdentifier
{
    return @"DailyScheduleCell";
}

- (NSString *)placeToursString:(NSArray *)placeTours
{
    NSMutableArray *stringArray = [[[NSMutableArray alloc] init] autorelease];
    for (PlaceTour *placeTour in placeTours) {
        [stringArray addObject:placeTour.name];
    }
    
    return [stringArray componentsJoinedByString:@"\n "];
}

- (void)setCellData:(DailySchedule *)dailySchedule rowNum:(int)rowNum rowCount:(int)rowCount
{
    [placeToursTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [diningTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [hotelTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [diningButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [hotelButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    
    [titleButton setTitle:dailySchedule.title forState:UIControlStateNormal];
    [titleButton setBackgroundImage:[[ImageManager defaultManager] dailyScheduleTitleBgImageWithRowNum:rowNum rowCount:rowCount]forState:UIControlStateNormal];
    
    CGFloat height = MAX([dailySchedule.placeToursList count], 1)* HEIGHT_PLACE_TOUR_LABEL + EDGE_TOP + EDGE_BOTTOM;
    NSString *text;
    placeToursTagButton.frame = CGRectMake(placeToursTagButton.frame.origin.x, placeToursTagButton.frame.origin.y, placeToursTagButton.frame.size.width, height);
    placeToursBgImageView.frame = CGRectMake(placeToursBgImageView.frame.origin.x, placeToursBgImageView.frame.origin.y, placeToursBgImageView.frame.size.width, height);
    [placeToursTagButton setTitle:NSLS(@"景点") forState:UIControlStateNormal];

    if ([dailySchedule.placeToursList count] == 0) {
        UILabel *placeTourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, EDGE_TOP, placeToursBgImageView.frame.size.width, HEIGHT_PLACE_TOUR_LABEL)];
        placeTourLabel.backgroundColor = [UIColor clearColor];
        placeTourLabel.text = NSLS(@" 无相关信息");
        placeTourLabel.font = [UIFont systemFontOfSize:13];
        [placeToursBgImageView addSubview:placeTourLabel];
        [placeTourLabel release];
    }
    
    int i = 0;
    for (PlaceTour *placeTour in dailySchedule.placeToursList) {
        UILabel *placeTourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, EDGE_TOP +HEIGHT_PLACE_TOUR_LABEL * (i++), placeToursBgImageView.frame.size.width, HEIGHT_PLACE_TOUR_LABEL)];
        placeTourLabel.backgroundColor = [UIColor clearColor];
        placeTourLabel.text = [NSString stringWithFormat:(@" %@(%@)"), placeTour.name, placeTour.duration];
        placeTourLabel.font = [UIFont systemFontOfSize:13];
        [placeToursBgImageView addSubview:placeTourLabel];
        placeTourLabel.textColor = COLOR_CONTENT;
        [placeTourLabel release];
    }

    CGFloat originY = placeToursTagButton.frame.origin.y + placeToursBgImageView.frame.size.height;
    diningTagButton.frame = CGRectMake(diningTagButton.frame.origin.x, originY, diningTagButton.frame.size.width, HEIGHT_DINING_LABEL);
    diningButton.frame = CGRectMake(diningButton.frame.origin.x, originY, diningButton.frame.size.width, HEIGHT_DINING_LABEL);
    [diningTagButton setTitle:NSLS(@"用餐") forState:UIControlStateNormal];
    text = [NSString stringWithFormat:NSLS(@"早：%@ 午：%@ 晚：%@"), dailySchedule.breakfast, dailySchedule.lunch, dailySchedule.dinner];
    [diningButton setTitle:text forState:UIControlStateNormal];
    
    originY = diningTagButton.frame.origin.y + diningTagButton.frame.size.height;
    hotelTagButton.frame = CGRectMake(hotelTagButton.frame.origin.x, originY, hotelTagButton.frame.size.width, HEIGHT_DINING_LABEL);
    hotelButton.frame = CGRectMake(hotelButton.frame.origin.x, originY, hotelButton.frame.size.width, HEIGHT_DINING_LABEL);
    [hotelTagButton setTitle:NSLS(@"住宿") forState:UIControlStateNormal];
    text = dailySchedule.accommodation.hotelName;
    [hotelButton setTitle:text forState:UIControlStateNormal];
    
    [hotelTagButton setBackgroundImage:[[ImageManager defaultManager] tableLeftBgImageWithRowNum:rowNum rowCount:rowCount] forState:UIControlStateNormal];
    [hotelButton setBackgroundImage:[[ImageManager defaultManager] tableRightBgImageWithRowNum:rowNum rowCount:rowCount] forState:UIControlStateNormal];
}

- (void)dealloc {
    [titleButton release];
    [diningButton release];
    [hotelButton release];
    [hotelTagButton release];
    [placeToursTagButton release];
    [diningTagButton release];
    [placeToursBgImageView release];
    [super dealloc];
}
@end
