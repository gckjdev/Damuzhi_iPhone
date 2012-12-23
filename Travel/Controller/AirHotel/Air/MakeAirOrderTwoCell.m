//
//  MakeAirOrderTwoCell.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "MakeAirOrderTwoCell.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"
#import "LocaleUtils.h"
#import "FlightSimpleView.h"

@implementation MakeAirOrderTwoCell

- (void)dealloc {
    [_departCityButton release];
    [_goDateButton release];
    [_backDateButton release];
    [_goFlightButton release];
    [_backFlightButton release];
    [_goFlightHolderView release];
    [_backFlightHolderView release];
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"MakeAirOrderTwoCell";
}

+ (CGFloat)getCellHeight
{
    return 200.0f;
}

#define TAG_GO_FLIGHT_SIMPLE    2012121701
#define TAG_BACK_FLIGHT_SIMPLE  2012121702

- (void)setCellByDepartCityName:(NSString *)departCityName
                      goBuilder:(AirOrder_Builder *)goBuilder
                    backBuilder:(AirOrder_Builder *)backBuilder
{
    AirHotelManager *_manager = [AirHotelManager defaultManager];
    NSString *defaultTips = NSLS(@"请选择");
    
    if (departCityName) {
        [self.departCityButton setTitle:departCityName forState:UIControlStateNormal];
    } else {
        [self.departCityButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    if ([goBuilder hasFlightDate]) {
        [self.goDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:goBuilder.flightDate] forState:UIControlStateNormal];
    } else {
        [self.goDateButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    
    if ([backBuilder hasFlightDate]) {
        [self.backDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:backBuilder.flightDate] forState:UIControlStateNormal];
    } else {
        [self.backDateButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    
    if ([goBuilder hasFlight]) {
        [self.goFlightButton setTitle:@"" forState:UIControlStateNormal];
        self.goFlightHolderView.hidden = NO;
        
        FlightSimpleView *simpleView = (FlightSimpleView *)[self.goFlightHolderView viewWithTag:TAG_GO_FLIGHT_SIMPLE];
        if (simpleView == nil) {
            simpleView = [FlightSimpleView createFlightSimpleView];
            simpleView.tag  = TAG_GO_FLIGHT_SIMPLE;
            [self.goFlightHolderView addSubview:simpleView];
        }
        [simpleView setViewWith:goBuilder.flight flightSeatCode:goBuilder.flightSeatCode];
    } else {
        [self.goFlightButton setTitle:@"请选择" forState:UIControlStateNormal];
        self.goFlightHolderView.hidden = YES;
    }
    
    if ([backBuilder hasFlight]) {
        [self.backFlightButton setTitle:@"" forState:UIControlStateNormal];
        self.backFlightHolderView.hidden = NO;
        
        FlightSimpleView *simpleView = (FlightSimpleView *)[self.backFlightHolderView viewWithTag:TAG_BACK_FLIGHT_SIMPLE];
        if (simpleView == nil) {
            simpleView = [FlightSimpleView createFlightSimpleView];
            simpleView.tag  = TAG_BACK_FLIGHT_SIMPLE;
            [self.backFlightHolderView addSubview:simpleView];
        }
        [simpleView setViewWith:backBuilder.flight flightSeatCode:backBuilder.flightSeatCode];
    } else {
        [self.backFlightButton setTitle:@"请选择" forState:UIControlStateNormal];
        self.backFlightHolderView.hidden = YES;
    }
    
}


- (IBAction)clickDepartCityButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickDepartCityButton)]) {
        [delegate didClickDepartCityButton];
    }
}

- (IBAction)clickGoDateButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickGoDateButton)]) {
        [delegate didClickGoDateButton];
    }
}

- (IBAction)clickBackDateButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickBackDateButton)]) {
        [delegate didClickBackDateButton];
    }
}

- (IBAction)clickGoFlightButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickGoFlightButton)]) {
        [delegate didClickGoFlightButton];
    }
}

- (IBAction)clickBackFlightButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickBackFlightButton)]) {
        [delegate didClickBackFlightButton];
    }
}

@end
