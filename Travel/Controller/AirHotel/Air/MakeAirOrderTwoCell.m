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

@implementation MakeAirOrderTwoCell

- (void)dealloc {
    [_departCityButton release];
    [_goDateButton release];
    [_backDateButton release];
    [_goFlightButton release];
    [_backFlightButton release];
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
    
    if (goBuilder.flightDate) {
        [self.goDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:goBuilder.flightDate] forState:UIControlStateNormal];
    } else {
        [self.goDateButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    
    if (backBuilder.flightDate) {
        [self.backDateButton setTitle:[_manager dateIntToYearMonthDayWeekString:backBuilder.flightDate] forState:UIControlStateNormal];
    } else {
        [self.backDateButton setTitle:defaultTips forState:UIControlStateNormal];
    }
    
    //[self.goFlightButton setTitle:nil forState:UIControlStateNormal];
    //[self.backFlightButton setTitle:nil forState:UIControlStateNormal];
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
