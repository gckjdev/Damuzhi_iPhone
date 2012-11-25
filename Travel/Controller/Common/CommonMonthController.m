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

@interface CommonMonthController ()

@property (retain,nonatomic) TKCalendarMonthView *monthView;
@property (assign, nonatomic) NSUInteger monthCount;
@property (assign, nonatomic) id<CommonMonthControllerDelegate> delegate;
@property (retain, nonatomic) NSString *navigationTitle;

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
    [super dealloc];
}

- (id)initWithDelegate:(id<CommonMonthControllerDelegate>)delegate
            monthCount:(NSUInteger)monthCount
                 title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.monthCount = monthCount;
        self.navigationTitle = title;
    }
    return self;
}

- (void) loadView{
	[super loadView];
	
	_monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:YES];
	_monthView.delegate = self;
	_monthView.dataSource = self;
	[self.view addSubview:_monthView];
	[_monthView reload];
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
    [self.monthView selectDate:[NSDate date]];
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
    if ([[NSDate date] isSameYearMonth:month]) {
        [self.monthView hideLeftArrow:YES];
    } else {
        [self.monthView hideLeftArrow:NO];
    }
    
    if ([[NSDate date] monthsBetweenDate:month] >= _monthCount - 1) {
        [self.monthView hideRightArrow:YES];
    } else {
        [self.monthView hideRightArrow:NO];
    }

    PPDebug(@"calendarMonthView:monthDidChange:%@", month);
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    PPDebug(@"calendarMonthView:didSelectDate%@", date);
    if ([_delegate respondsToSelector:@selector(didSelectDate:)]) {
        [_delegate didSelectDate:date];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma TKCalendarMonthViewDataSource methods
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    return nil;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView markTextsFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    return nil;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView markTextColorsFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    return nil;
}

@end
