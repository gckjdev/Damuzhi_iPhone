//
//  MonthViewController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-25.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "MonthViewController.h"
#import "PPDebug.h"
#import "LocaleUtils.h"
#import "TimeUtils.h"
#import "TouristRoute.pb.h"
#import "NSDate+TKCategory.h"
#import "UIViewUtils.h"
#import "RouteUtils.h"
#import "TravelNetworkConstants.h"
#import "LogUtil.h"
#import "TimeUtils.h"
#import "FontSize.h"

#define USER_UIIMAGE_NAME_DATE_TILE_SELECTED  (@"date_t_bg2.png")
#define USER_UIIMAGE_NAME_DATE_TILE  (@"date_t_bg.png")

@interface MonthViewController ()
{
    int _routeType;
}

@property (retain, nonatomic) NSArray *bookings;
@property (retain, nonatomic) NSMutableArray *dataArray;
//@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSString *currency;

@end

@implementation MonthViewController
@synthesize aDelegate = _aDelegate;
@synthesize currentMonthButton = _currentMonthButton;
@synthesize nextMonthButton = _nextMonthButton;
@synthesize monthHolderView = _monthHolderView;
@synthesize buttonHolderView = _buttonHolderView;
@synthesize backgroundImageView = _backgroundImageView;
//@synthesize rightLineImageView = _rightLineImageView;

@synthesize monthView = _monthView;
@synthesize bookings = _bookings;
@synthesize dataArray = _dataArray;
//@synthesize date = _date;
@synthesize currency = _currency;


- (void)dealloc {
    [_monthView release];
    [_bookings release];
    [_dataArray release];
    
    [_currentMonthButton release];
    [_nextMonthButton release];
    [_monthHolderView release];
    [_buttonHolderView release];
//    [_date release];

    [_backgroundImageView release];
//    [_rightLineImageView release];
    
    [_currency release];
    [super dealloc];
}

- (id)initWithBookings:(NSArray *)bookings
{
    if (self= [super init]) {
        self.bookings = bookings;
    }
    
    return self;
}

- (id)initWithBookings:(NSArray *)bookings routeType:(int)routeType
{
    if (self= [super init]) {
        self.bookings = bookings;
        _routeType = routeType;
    }
    
    return self;
}

- (id)initWithBookings:(NSArray *)bookings currency:(NSString *)currency
{
    if (self= [super init]) {
        self.bookings = bookings;
        self.currency = currency;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.title = NSLS(@"出发日期");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    self.backgroundImageView.image = [[UIImage imageNamed:@"date_top_bg@2x.png"] stretchableImageWithLeftCapWidth:150 topCapHeight:30];
//    self.rightLineImageView.backgroundColor = [UIColor colorWithRed:209/255.0 green:210/255.0 blue:214/255.0 alpha:1.0];
    self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO
                                                                    date:[NSDate date]
                                                              tileHeight:55] autorelease];
    [self.monthView hideMonthYearLabel:YES];
    [self.monthView hideLeftArrow:YES];
    [self.monthView hideRightArrow:YES];
    [self.monthView setTopBgImage:nil];
    

    [self.currentMonthButton setTitle:dateToChineseStringByFormat([[NSDate date] chineseFirstOfMonth], @"yyyy年MM月")
                             forState:UIControlStateNormal];
    
    [self.nextMonthButton  setTitle:dateToChineseStringByFormat([[[NSDate date] chineseFirstOfMonth] chineseNextMonth], @"yyyy年MM月")
                           forState:UIControlStateNormal];

//    PPDebug(@"current time is %@",dateToChineseStringByFormat(now, @"yyyy年MM月dd日 HH:mm"));
//    PPDebug(@"next month time is %@",dateToChineseStringByFormat([now chineseNextMonth], @"yyyy年MM月dd日 HH:mm"));
    
    _monthView.delegate = self;
    _monthView.dataSource = self;
    
    if (self.currentMonthButton.selected == NO && self.nextMonthButton.selected == NO) {
        self.currentMonthButton.selected = YES;
    }
        
    [_monthView reload];
    [self.monthHolderView addSubview:_monthView];
    
    if ([_aDelegate respondsToSelector:@selector(didChangeFrame:)]) {
        [_aDelegate didChangeFrame:_monthView.frame];
    }
}

- (void)viewDidUnload
{
    [self setCurrentMonthButton:nil];
    [self setNextMonthButton:nil];
    [self setMonthHolderView:nil];
    [self setButtonHolderView:nil];
    [self setBackgroundImageView:nil];
//    [self setRightLineImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    [self generateRandomDataForStartDate:startDate endDate:lastDate];
	return _dataArray;
}

- (IBAction)clickCurrentMonthButton:(id)sender {
    if (self.currentMonthButton.selected == YES) {
        return;
    }
    
    UIButton *button = [_monthView valueForKey:@"leftArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
    self.currentMonthButton.selected = YES;
    self.nextMonthButton.selected = NO;
    
    PPDebug(@"height: %f", self.monthView.frame.size.height);
    
    if ([_aDelegate respondsToSelector:@selector(didChangeFrame:)]) {
        [_aDelegate didChangeFrame:_monthView.frame];
    }
}

- (IBAction)clickNextMonthButton:(id)sender {
    if (self.nextMonthButton.selected == YES) {
        return;
    }
    
    UIButton *button = [_monthView valueForKey:@"rightArrow"];
    [_monthView performSelector:@selector(changeMonth:) withObject:button];
    
    self.nextMonthButton.selected = YES;
    self.currentMonthButton.selected = NO;
    
    PPDebug(@"height: %f", self.monthView.frame.size.height);

    
    if ([_aDelegate respondsToSelector:@selector(didChangeFrame:)]) {
        [_aDelegate didChangeFrame:_monthView.frame];
    }
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
    NSMutableArray *texts = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
        [texts addObject:[self bookingStringWithDate:d]];

		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return texts;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView markTextColorsFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSMutableArray *colors = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
        if ([[self bookingStringWithDate:d] isEqualToString:NSLS(@"销售中")]) {
            [colors addObject:[UIColor redColor]];
        } else {
            [colors addObject:[UIColor blackColor]];
        }
        
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return colors;
}

- (NSString*)bookingStringWithDate:(NSDate *)date
{
//    return @"销售中";
    
    NSString *bookingInfo = @"";
    
    Booking *booking = [RouteUtils bookingOfDate:date bookings:_bookings];
    if (booking != nil) {
        
        NSDate *nowStartDate = getDateStart([NSDate date]);
        NSTimeInterval diffTimeInterval = [date timeIntervalSinceDate:nowStartDate];
        if (diffTimeInterval < 0 ) {
            bookingInfo = NSLS(@"");
        } else {
            if (booking.status == 1) {
                bookingInfo = NSLS(@"未开售");
            }else if (booking.status == 2) {
                bookingInfo = NSLS(@"销售中");
            }
        }
    }
    
    return bookingInfo;
}



- (void)showInView:(UIView *)superView
{
    [superView removeAllSubviews];

    CGFloat scale = superView.frame.size.width / self.view.frame.size.width;
    CGAffineTransform transform =  CGAffineTransformMakeScale(scale, scale);
    _monthView.transform = transform;
    _monthView.frame = CGRectMake(0, 0, _monthView.frame.size.width, _monthView.frame.size.height);
    
    self.buttonHolderView.transform = transform;
    CGRect bFrame = self.buttonHolderView.frame;
    self.buttonHolderView.frame = CGRectMake(_monthView.frame.size.width * 0.5 - bFrame.size.width * 0.5, bFrame.origin.y, bFrame.size.width, bFrame.size.height);
    
    [superView addSubview:self.view];
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    if ([_aDelegate respondsToSelector:@selector(didSelecteDate:)]) {
        [self clearUnPopupMessages];
        
        NSDate *nowStartDate = getDateStart([NSDate date]);
        NSTimeInterval diffTimeInterval = [date timeIntervalSinceDate:nowStartDate];
        if (diffTimeInterval < 0 ) {
            [self popupMessage:NSLS(@"不能预订今天之前的日期") title:nil];
            return;
        }
        
        Booking *booking = [RouteUtils bookingOfDate:date bookings:_bookings];
        
        if (booking.status == 1) {
            [self popupMessage:NSLS(@"该日期未开售") title:nil];
        }else if (booking.status == 2) {
            [_aDelegate didSelecteDate:date];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (booking.status == 3) {
            [self popupMessage:NSLS(@"该日期已满") title:nil];
        }else {
            [self popupMessage:NSLS(@"该日期没有行程") title:nil];
        }
    }
}

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView tileBgImageNamesForNormalFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
        [images addObject:([d isToday] ? USER_UIIMAGE_NAME_DATE_TILE : USER_UIIMAGE_NAME_DATE_TILE)];
        
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return images;
}

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView tileBgImageNamesForSelectedFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
        if ([d isSameYearMonth:monthView.selectedMonth]) {
            [images addObject:([d isToday] ? USER_UIIMAGE_NAME_DATE_TILE_SELECTED : USER_UIIMAGE_NAME_DATE_TILE_SELECTED)];
        }else {
            [images addObject:@""];
        }
        
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return images;
}

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView tileTouchDisabledsFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray *touchDisableds = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
    
    while(YES){
        PPDebug(@"%@", monthView);
        
        PPDebug(@"%@", dateToChineseString(monthView.selectedMonth));
        PPDebug(@"%@", dateToChineseString(d));
        if ([d isSameYearMonth:monthView.selectedMonth]) {
            [touchDisableds addObject:@(NO)];
        }else {
            [touchDisableds addObject:@(YES)];
        }
        
		TKDateInformation info = [d dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		info.day++;
		d = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		if([d compare:lastDate]==NSOrderedDescending) break;
	}
    
    return touchDisableds;
}



@end
