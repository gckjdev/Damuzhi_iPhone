//
//  MakeAirOrderOneCell.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "MakeAirOrderOneCell.h"
#import "LocaleUtils.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"
#import "FlightSimpleView.h"
#import "AirHotelColorConstants.h"

@interface MakeAirOrderOneCell()
@property (assign, nonatomic) AirType airType;

@end

@implementation MakeAirOrderOneCell

- (void)dealloc {
    [_dateLabel release];
    [_flightLabel release];
    [_dateIconViewImage release];
    [_flightIconImageView release];
    [_departCityButton release];
    [_flightButton release];
    [_flightDateButton release];
    [_flightHolderView release];
    [_clearDepartCityButton release];
    [_clearFlightDateButton release];
    [_clearFlightButton release];
    [_clearButtonsHolderView release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"MakeAirOrderOneCell";
}

+ (CGFloat)getCellHeight
{
    return 120.0f;
}

- (void)createRecognizerOnView:(UIView *)view action:(SEL)action
{
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [view addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)addRecognizer
{
    [self createRecognizerOnView:self.departCityButton action:@selector(swipeDepartCity:)];
    [self createRecognizerOnView:self.flightDateButton action:@selector(swipeFlightDate:)];
    [self createRecognizerOnView:self.flightButton action:@selector(swipeFlight:)];
}

- (void)swipeDepartCity:(UISwipeGestureRecognizer *)recognizer
{
    self.clearButtonsHolderView.hidden = NO;
    self.clearDepartCityButton.hidden = NO;
}

- (void)swipeFlightDate:(UISwipeGestureRecognizer *)recognizer
{
    self.clearButtonsHolderView.hidden = NO;
    self.clearFlightDateButton.hidden = NO;
}

- (void)swipeFlight:(UISwipeGestureRecognizer *)recognizer
{
    self.clearButtonsHolderView.hidden = NO;
    self.clearFlightButton.hidden = NO;
}

#define TAG_FLIGHT_SIMPLE   2012121701
- (void)setCellWithType:(AirType)airType
         departCityName:(NSString *)departCityName
                builder:(AirOrder_Builder *)builder
{
    self.clearButtonsHolderView.hidden = YES;
    self.clearDepartCityButton.hidden = YES;
    self.clearFlightDateButton.hidden = YES;
    self.clearFlightButton.hidden = YES;
    
    self.airType = airType;
    AirHotelManager *_manager = [AirHotelManager defaultManager];
    NSString *defaultTips = NSLS(@"请选择");
    
    if (airType == AirGo) {
        self.dateIconViewImage.image = [UIImage imageNamed:@"ticket_p2.png"];
        self.dateLabel.text = NSLS(@"出发日期");
        self.flightIconImageView.image = [UIImage imageNamed:@"ticket_p5.png"];
        self.flightLabel.text = NSLS(@"去程");
    } else {
        self.dateIconViewImage.image = [UIImage imageNamed:@"ticket_p3.png"];
        self.dateLabel.text = NSLS(@"回程日期");
        self.flightIconImageView.image = [UIImage imageNamed:@"ticket_p6.png"];
        self.flightLabel.text = NSLS(@"回程");
    }
    
    
    if (departCityName) {
        [self.departCityButton setTitleColor:COLOR_VALUE forState:UIControlStateNormal];
        [self.departCityButton setTitle:departCityName forState:UIControlStateNormal];
    } else {
        [self.departCityButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
        [self.departCityButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    
    if ([builder hasFlightDate]) {
        [self.flightDateButton setTitleColor:COLOR_VALUE forState:UIControlStateNormal];
        [self.flightDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:builder.flightDate] forState:UIControlStateNormal];
    } else {
        [self.flightDateButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
        [self.flightDateButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    if ([builder hasFlight]) {
        [self.flightButton setTitle:@"" forState:UIControlStateNormal];
        self.flightHolderView.hidden = NO;
        
        FlightSimpleView *simpleView = (FlightSimpleView *)[self.flightHolderView viewWithTag:TAG_FLIGHT_SIMPLE];
        if (simpleView == nil) {
            simpleView = [FlightSimpleView createFlightSimpleView];
            simpleView.tag  = TAG_FLIGHT_SIMPLE;
            [self.flightHolderView addSubview:simpleView];
        }
        [simpleView setViewWith:builder.flight flightSeatCode:builder.flightSeatCode];
    } else {
        [self.flightButton setTitleColor:COLOR_NO_VALUE forState:UIControlStateNormal];
        [self.flightButton setTitle:defaultTips forState:UIControlStateNormal];
        self.flightHolderView.hidden = YES;
    }
    
    //[self addRecognizer];
}

- (IBAction)clickDepartCityButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickDepartCityButton)]) {
        [delegate didClickDepartCityButton];
    }
}

- (IBAction)clickFlightDateButton:(id)sender {
    if (_airType == AirGo) {
        if ([delegate respondsToSelector:@selector(didClickGoDateButton)]) {
            [delegate didClickGoDateButton];
        }
    } else if (_airType == AirBack) {
        if ([delegate respondsToSelector:@selector(didClickBackDateButton)]) {
            [delegate didClickBackDateButton];
        }
    }
}

- (IBAction)clickFlightButton:(id)sender {
    if (_airType == AirGo) {
        if ([delegate respondsToSelector:@selector(didClickGoFlightButton)]) {
            [delegate didClickGoFlightButton];
        }

    } else if (_airType == AirBack) {
        if ([delegate respondsToSelector:@selector(didClickBackFlightButton)]) {
            [delegate didClickBackFlightButton];
        }
    }
}

- (IBAction)clickClearDepartCityButton:(id)sender
{
    self.clearDepartCityButton.hidden = YES;
    self.clearButtonsHolderView.hidden = YES;

    if ([delegate respondsToSelector:@selector(didClickClearDepartCity)]) {
        [delegate didClickClearDepartCity];
    }
}

- (IBAction)clickClearFlightDateButton:(id)sender
{
    self.clearFlightDateButton.hidden = YES;
    self.clearButtonsHolderView.hidden = YES;
    
    if (_airType == AirGo) {
        if ([delegate respondsToSelector:@selector(didClickClearGoDate)]) {
            [delegate didClickClearGoDate];
        }
    } else if (_airType == AirBack) {
        if ([delegate respondsToSelector:@selector(didClickClearBackDate)]) {
            [delegate didClickClearGoDate];
        }
    }
}

- (IBAction)clickClearFlightButton:(id)sender
{
    self.clearFlightButton.hidden = YES;
    self.clearButtonsHolderView.hidden = YES;
    
    if (_airType == AirGo) {
        if ([delegate respondsToSelector:@selector(didClickClearGoFlight)]) {
            [delegate didClickClearGoFlight];
        }
        
    } else if (_airType == AirBack) {
        if ([delegate respondsToSelector:@selector(didClickClearBackFlight)]) {
            [delegate didClickClearBackFlight];
        }
    }
}

- (IBAction)touchDownClearHolderView:(id)sender {
    self.clearButtonsHolderView.hidden = YES;
    self.clearDepartCityButton.hidden = YES;
    self.clearFlightDateButton.hidden = YES;
    self.clearFlightButton.hidden = YES;
}


@end
