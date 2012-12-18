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

#define TAG_FLIGHT_SIMPLE   2012121701

- (void)setCellWithType:(AirType)airType
         departCityName:(NSString *)departCityName
                builder:(AirOrder_Builder *)builder
{
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
        [self.departCityButton setTitle:departCityName forState:UIControlStateNormal];
    } else {
        [self.departCityButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    
    if (builder.flightDate) {
        [self.flightDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:builder.flightDate] forState:UIControlStateNormal];
    } else {
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
        [self.flightButton setTitle:@"请选择" forState:UIControlStateNormal];
        self.flightHolderView.hidden = YES;
    }
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

@end
