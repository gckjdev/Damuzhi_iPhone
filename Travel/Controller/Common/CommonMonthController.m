//
//  CommonMonthController.m
//  Travel
//
//  Created by haodong on 12-11-21.
//
//

#import "CommonMonthController.h"
#import "TKCalendarMonthView.h"
#import "NSDate+TKCategory.h"
#import "LogUtil.h"
#import "FontSize.h"
#import "TimeUtils.h"

#define USER_UIIMAGE_NAME_DATE_TILE_SELECTED  (@"date_t_bg2@2x.png")
#define USER_UIIMAGE_NAME_DATE_TILE  (@"date_t_bg@2x.png")

@interface CommonMonthController ()

@property (retain,nonatomic) TKCalendarMonthView *monthView;
@property (assign, nonatomic) NSUInteger monthCount;
@property (assign, nonatomic) id<CommonMonthControllerDelegate> delegate;
@property (retain, nonatomic) NSString *navigationTitle;
@property (retain, nonatomic) NSDate *customStartDate;
@end

@implementation CommonMonthController
@synthesize monthCount = _monthCount;
@synthesize delegate = _delegate;
@synthesize monthView = _monthView;
@synthesize navigationTitle = _navigationTitle;

- (void) dealloc {
	self.monthView.delegate = nil;
	self.monthView.dataSource = nil;
    [_monthView release];
    [_navigationTitle release];
    [_customStartDate release];
    [super dealloc];
}

- (id)initWithDelegate:(id<CommonMonthControllerDelegate>)delegate
       customStartDate:(NSDate *)customStartDate
            monthCount:(NSUInteger)monthCount
                 title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.customStartDate = customStartDate;
        self.monthCount = monthCount;
        self.navigationTitle = title;
        
        if (_customStartDate == nil) {
            self.customStartDate = [NSDate date];
        }
        self.monthView = [[[TKCalendarMonthView alloc] initWithSundayAsFirst:YES date:_customStartDate] autorelease];
        _monthView.delegate = self;
        _monthView.dataSource = self;

        [_monthView setTopBgImage:[UIImage imageNamed:@"date_top_bg@2x.png"]];
        [self.view addSubview:_monthView];
    }
    return self;
}

- (void) loadView{
    [_monthView reload];
	[super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _navigationTitle;
    
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    if (_monthCount == 0) {
        _monthCount = 12; //default value
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.monthView hideLeftArrow:YES];
}

- (void) viewDidUnload {
	self.monthView.delegate = nil;
	self.monthView.dataSource = nil;
	self.monthView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma TKCalendarMonthViewDelegate methods
- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated
{
    if ([_customStartDate isSameYearMonth:month]) {
        [self.monthView hideLeftArrow:YES];
    } else {
        [self.monthView hideLeftArrow:NO];
    }
    
    if ([_customStartDate monthsBetweenDate:month] >= _monthCount - 1) {
        [self.monthView hideRightArrow:YES];
    } else {
        [self.monthView hideRightArrow:NO];
    }
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    NSDate *nowStartDate = getDateStart([NSDate date]);
    NSTimeInterval diffTimeInterval = [date timeIntervalSinceDate:nowStartDate];
    if (diffTimeInterval < 0 ) {
        [self popupMessage:NSLS(@"不能预订今天之前的日期") title:nil];
        return;
    }
    
    PPDebug(@"calendarMonthView:didSelectDate%@", date);
    if ([_delegate respondsToSelector:@selector(didSelectDate:)]) {
        [_delegate didSelectDate:date];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView tileBgImageNamesForNormalFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
    
    // 计算这个时间离1970年1月1日0时0分0秒过去的天数。
    NSDate *d = startDate;
        
    while(YES){
        
        if ([d isBeforeDay:_customStartDate]) {
            [images addObject:@"date_t_no_bg@2x.png"];
        }else if ([d isToday]){
            [images addObject:USER_UIIMAGE_NAME_DATE_TILE];
        }else {
            [images addObject:USER_UIIMAGE_NAME_DATE_TILE];
        }
                
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
        if ([d isBeforeDay:_customStartDate]) {
            [touchDisableds addObject:@(YES)];
        }else if([d isSameYearMonth:monthView.selectedMonth]) {
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
