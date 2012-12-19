//
//  FlightSeatView.m
//  Travel
//
//  Created by haodong on 12-12-11.
//
//

#import "FlightSeatView.h"
#import "AirHotel.pb.h"

@interface FlightSeatView()
@property (assign, nonatomic) int index;
@end

@implementation FlightSeatView
- (void)dealloc {
    [_flightSeatNameLabel release];
    [_planeTypeLabel release];
    [_remainingCountLabel release];
    [_ticketPriceLabel release];
    [_airportAndFuelTax release];
    [_priceLabel release];
    [_refundNoteTextView release];
    [_changeNoteTextView release];
    [super dealloc];
}

+ (id)createFlightSeatView:(id<FlightSeatViewDelegate>)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FlightSeatView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create FlightSeatView but cannot find Nib");
        return nil;
    }
    
    FlightSeatView *flightSeatView = (FlightSeatView *)[topLevelObjects objectAtIndex:0];
    flightSeatView.delegate = delegate;
    
    return flightSeatView;
}

- (void)setViewWithFlight:(Flight *)flight index:(int)index
{
    self.index = index;
    FlightSeat *flightSeat = [flight flightSeatsAtIndex:index];
    
    self.flightSeatNameLabel.text = flightSeat.name;
    self.planeTypeLabel.text = flight.planeType;
    self.remainingCountLabel.text = flightSeat.remainingCount;
    self.ticketPriceLabel.text = flightSeat.ticketPrice;
    self.airportAndFuelTax.text = [NSString stringWithFormat:@"%@/%@",flight.adultAirportTax, flight.adultFuelTax];
    self.priceLabel.text = flightSeat.price;
    self.refundNoteTextView.text = [NSString stringWithFormat:@"                 %@", flightSeat.refundNote];
    self.changeNoteTextView.text = [NSString stringWithFormat:@"                 %@", flightSeat.changeNote];
}

- (IBAction)clickSelectFlightSeatButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickSelectFlightSeatButton:)]) {
        [_delegate didClickSelectFlightSeatButton:_index];
    }
}

@end
