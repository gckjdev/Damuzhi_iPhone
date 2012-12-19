//
//  FlightSimpleView.m
//  Travel
//
//  Created by haodong on 12-12-15.
//
//

#import "FlightSimpleView.h"
#import "AppManager.h"
#import "TimeUtils.h"

@implementation FlightSimpleView

- (void)dealloc {
    [_airlineNameLabel release];
    [_flightNumberLabel release];
    [_departDateLabel release];
    [_arriveDateLabel release];
    [_departAirportLabel release];
    [_arriveAirportLabel release];
    [_flightSeatLabel release];
    [super dealloc];
}

+ (id)createFlightSimpleView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FlightSimpleView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create FlightSimpleView but cannot find Nib");
        return nil;
    }
    
    FlightSimpleView *flightSimpleView = (FlightSimpleView *)[topLevelObjects objectAtIndex:0];
    
    return flightSimpleView;
}


- (void)setViewWith:(Flight *)flight flightSeatCode:(NSString *)flightSeatCode
{
    self.airlineNameLabel.text = [[AppManager defaultManager] getAirlineName:flight.airlineId];
    self.flightNumberLabel.text = flight.flightNumber;
    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:flight.departDate];
    self.departDateLabel.text =  dateToChineseStringByFormat(departDate, @"hh:mm");
    
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:flight.arriveDate];
    self.arriveDateLabel.text = dateToChineseStringByFormat(arriveDate, @"hh:mm");
    
    self.departAirportLabel.text = flight.departAirport;
    self.arriveAirportLabel.text = flight.arriveAirport;
    
    
    NSString *seatName = nil;
    for (FlightSeat *seat in flight.flightSeatsList) {
        if ([seat.code isEqualToString:flightSeatCode]) {
            seatName = seat.name;
            break;
        }
    }
    self.flightSeatLabel.text = seatName;
}

@end
