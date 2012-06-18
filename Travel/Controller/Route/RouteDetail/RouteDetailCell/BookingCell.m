//
//  BookingCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "BookingCell.h"
#import "NSDate+TKCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PPDebug.h"
@interface BookingCell ()

@property (retain, nonatomic) TKCalendarMonthView *monthView;
@property (retain, nonatomic) NSMutableArray *dataArray;

@end

@implementation BookingCell
@synthesize monthHolderView = _monthHolderView;

@synthesize monthView = _monthView;
@synthesize dataArray = _dataArray;

+ (NSString*)getCellIdentifier
{
    return @"BookingCell";
}

- (void)dealloc
{
    [_monthView release];
    [_dataArray release];
    [_monthHolderView release];
    [super dealloc];
}

- (void)setCellData:(BOOL)sundayFirst
{    
    self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO 
                                                                    date:[NSDate date]
                                                    hasMonthYearAndArrow:NO 
                                                        hasTopBackground:NO
                                                               hasShadow:NO 
                                                   userInteractionEnable:NO] autorelease];
    
//    [NSDate date] 
    
//    self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:sundayFirst] autorelease];
    
    _monthView.delegate = self;
    _monthView.dataSource = self;
    
    [_monthView reload];
    
    CGFloat scale = _monthHolderView.frame.size.width / _monthView.frame.size.width;
    CGAffineTransform transform =  CGAffineTransformMakeScale(scale, scale);
    _monthView.transform = transform;
    _monthView.frame = CGRectMake(0, 0, _monthView.frame.size.width, _monthView.frame.size.height);
    
    [self.monthHolderView addSubview:_monthView];
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    [self generateRandomDataForStartDate:startDate endDate:lastDate];
	return _dataArray;
}

- (IBAction)clickCurrentMonthButton:(id)sender {
    UIButton *button = [_monthView valueForKey:@"leftArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
}

- (IBAction)clickNextMonthButton:(id)sender {
    UIButton *button = [_monthView valueForKey:@"rightArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
}

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	PPDebug(@"Delegate Range: %@ %@ %d",start,end,[start daysBetweenDate:end]);
	
	self.dataArray = [NSMutableArray array];
	
	NSDate *d = start;
	while(YES){
        [self.dataArray addObject:[NSNumber numberWithBool:YES]];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView markTextsFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSDate *d = startDate;
    NSMutableArray *texts = [[NSMutableArray alloc] init];
    
    
    while(YES){
        [texts addObject:@"5888 \n 可报>9"];
		
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return texts;
}

- (CGSize)sizeForLatticeOfcalendarMonthView:(TKCalendarMonthView *)monthView
{
    return CGSizeMake(46, 68);
}

@end
