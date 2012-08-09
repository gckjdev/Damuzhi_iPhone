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

#define FONT_PLACE  [UIFont systemFontOfSize:13] 

@interface DailyScheduleCell ()
{
    int _hotelId;
}

@end

@implementation DailyScheduleCell

@synthesize aDelegate = _aDelegate;
@synthesize titleButton;
@synthesize placeToursBgImageView;
@synthesize diningButton;
@synthesize hotelButton;
@synthesize placeToursTagButton;
@synthesize diningTagButton;
@synthesize hotelTagButton;


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

+ (CGFloat)height:(DailySchedule *)dailySchedule
{
    NSMutableString *placesText = [[[NSMutableString alloc] init] autorelease];
    if ([dailySchedule.placeToursList count] == 0) {
        [placesText appendString:NSLS(@" 无相关信息")];
    }else {
        int index = 0;
        for (PlaceTour *placeTour in dailySchedule.placeToursList) {
            [placesText appendString:placeTour.name];
            if (index < [dailySchedule.placeToursList count] - 1) {
                [placesText appendString:@" - "];
            }
            index ++;
        }
    }
    
    CGFloat widthLabel = 255;
    CGSize placesTextSize = [placesText sizeWithFont:FONT_PLACE constrainedToSize:CGSizeMake(widthLabel, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = placesTextSize.height + EDGE_TOP + EDGE_BOTTOM;
    
    
    return HEIGHT_DAILY_SCHEDULE_TITLE_LABEL + height + HEIGHT_DINING_LABEL + HEIGHT_HOTEL_LABEL;
}

- (void)setCellData:(DailySchedule *)dailySchedule rowNum:(int)rowNum rowCount:(int)rowCount
{
    [placeToursTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [diningTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [hotelTagButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [diningButton setTitleColor:COLOR_CONTENT forState:UIControlStateNormal];
    [hotelButton setTitleColor:[UIColor colorWithRed:37/255. green:66/255. blue:80/255. alpha:1] forState:UIControlStateNormal];
    
    [titleButton setTitle:dailySchedule.title forState:UIControlStateNormal];
    [titleButton setBackgroundImage:[[ImageManager defaultManager] dailyScheduleTitleBgImageWithRowNum:rowNum rowCount:rowCount]forState:UIControlStateNormal];
    
    [placeToursTagButton setTitle:NSLS(@"景点") forState:UIControlStateNormal];
    [placeToursTagButton setBackgroundImage:[[ImageManager defaultManager] placeTourBtnBgImage] forState:UIControlStateNormal];
    
    
    
    NSMutableString *placesText = [[[NSMutableString alloc] init] autorelease];
    if ([dailySchedule.placeToursList count] == 0) {
        [placesText appendString:NSLS(@" 无相关信息")];
    }else {
        int index = 0;
        for (PlaceTour *placeTour in dailySchedule.placeToursList) {
            [placesText appendString:placeTour.name];
            if (index < [dailySchedule.placeToursList count] - 1) {
                [placesText appendString:@" - "];
            }
            index ++;
        }
    }
    
    CGFloat widthLabel = 255;
    CGSize placesTextSize = [placesText sizeWithFont:FONT_PLACE constrainedToSize:CGSizeMake(widthLabel, 1000) lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = placesTextSize.height + EDGE_TOP + EDGE_BOTTOM;
    
    placeToursTagButton.frame = CGRectMake(placeToursTagButton.frame.origin.x, placeToursTagButton.frame.origin.y, placeToursTagButton.frame.size.width, height);
    
    placeToursBgImageView.frame = CGRectMake(placeToursBgImageView.frame.origin.x, placeToursBgImageView.frame.origin.y, placeToursBgImageView.frame.size.width, height);
    placeToursBgImageView.image = [[ImageManager defaultManager] placeTourBgImage];
    
    UILabel *placesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2, EDGE_TOP, widthLabel, placesTextSize.height)] autorelease];
    placesLabel.backgroundColor = [UIColor clearColor];
    placesLabel.font = FONT_PLACE;
    placesLabel.textColor = COLOR_CONTENT;
    placesLabel.text = placesText;
    placesLabel.numberOfLines = 0;
    placesLabel.lineBreakMode = UILineBreakModeWordWrap;
    [placeToursBgImageView addSubview:placesLabel];
    

    CGFloat originY = placeToursTagButton.frame.origin.y + placeToursBgImageView.frame.size.height;
    diningTagButton.frame = CGRectMake(diningTagButton.frame.origin.x, originY, diningTagButton.frame.size.width, HEIGHT_DINING_LABEL);
    diningButton.frame = CGRectMake(diningButton.frame.origin.x, originY, diningButton.frame.size.width, HEIGHT_DINING_LABEL);
    [diningTagButton setTitle:NSLS(@"用餐") forState:UIControlStateNormal];
    NSString *text;
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
    
    _hotelId = dailySchedule.accommodation.hotelId;
}

- (IBAction)clickHotelButton:(id)sender {
    if ([_aDelegate respondsToSelector:@selector(didClickHotel:)]) {
        [_aDelegate didClickHotel:_hotelId];
    }
}

@end
