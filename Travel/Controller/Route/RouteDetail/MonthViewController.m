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

@interface MonthViewController ()
{
    int _routeType;
}

@property (retain, nonatomic) NSArray *bookings;
@property (retain, nonatomic) NSMutableArray *dataArray;
//@property (retain, nonatomic) NSDate *date;

@end

@implementation MonthViewController
@synthesize aDelegate = _aDelegate;
@synthesize aBgView = _aBgView;
@synthesize currentMonthButton = _currentMonthButton;
@synthesize nextMonthButton = _nextMonthButton;
@synthesize monthHolderView = _monthHolderView;
@synthesize buttonHolderView = _buttonHolderView;

@synthesize monthView = _monthView;
@synthesize bookings = _bookings;
@synthesize dataArray = _dataArray;
//@synthesize date = _date;
- (void)dealloc {
    [_monthView release];
    [_bookings release];
    [_dataArray release];
    
    [_currentMonthButton release];
    [_nextMonthButton release];
    [_monthHolderView release];
    [_aBgView release];
    [_buttonHolderView release];
//    [_date release];
    [super dealloc];
}

- (id)initWithBookings:(NSArray *)bookings routeType:(int)routeType
{
    if (self= [super init]) {
        self.bookings = bookings;
        _routeType = routeType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    self.title = NSLS(@"出发日期");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    NSDate *now = [NSDate date];
    self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:NO 
                                                                    date:now
                                                    hasMonthYearAndArrow:NO 
                                                        hasTopBackground:NO
                                                               hasShadow:NO 
                                                   userInteractionEnable:YES] autorelease];
    
    [self.currentMonthButton setTitle:dateToStringByFormat(now, @"yyyy年MM月") forState:UIControlStateNormal];
    [self.nextMonthButton  setTitle:dateToStringByFormat([now nextMonth], @"yyyy年MM月") forState:UIControlStateNormal];
    
    _monthView.delegate = self;
    _monthView.dataSource = self;
    
    if (self.currentMonthButton.selected == NO && self.nextMonthButton.selected == NO) {
        self.currentMonthButton.selected = YES;
    }
        
    [_monthView reload];
    
    [self.monthHolderView addSubview:_monthView];
}

- (void)viewDidUnload
{
    [self setCurrentMonthButton:nil];
    [self setNextMonthButton:nil];
    [self setMonthHolderView:nil];
    [self setABgView:nil];
    [self setButtonHolderView:nil];
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

- (NSString*)bookingStringWithDate:(NSDate *)date
{
    NSString *bookingInfo = @"";
    
    Booking *booking = [RouteUtils bookingOfDate:date bookings:_bookings];
    if (booking != nil) {
        PPDebug(@"routeType = %d", _routeType);
        if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
            if (booking.status == 1) {
                bookingInfo = NSLS(@"未开售") ;
            }else if (booking.status == 2) {            
                NSString *remainder = ([booking.remainder intValue] > 9) ? NSLS(@">9") : booking.remainder; 
                bookingInfo = [NSString stringWithFormat:@"%@\n可报%@", booking.adultPrice, remainder];
            }else if (booking.status == 3) {
                bookingInfo = NSLS(@"满");
            }
        }else {
            bookingInfo = [NSString stringWithFormat:@"%@", booking.adultPrice];
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

@end
