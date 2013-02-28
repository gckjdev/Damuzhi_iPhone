//
//  FlightSeatView.m
//  Travel
//
//  Created by haodong on 12-12-11.
//
//

#import "FlightSeatView.h"
#import "AirHotel.pb.h"
#import "PriceUtils.h"
#import "LogUtil.h"

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
    [_changeNoteTitleLabel release];
    [_refundNoteTitleLabel release];
    [_rescheduleScrollView release];
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
    self.ticketPriceLabel.text = [NSString stringWithFormat:@"%@", [PriceUtils priceToStringCNY:flightSeat.adultTicketPrice]];
    self.airportAndFuelTax.text = [NSString stringWithFormat:@"%@ / %@",[PriceUtils priceToStringCNY:flight.adultAirportTax], [PriceUtils priceToStringCNY:flight.adultFuelTax]];
    
    double totalPrice = flightSeat.adultTicketPrice + flight.adultAirportTax + flight.adultFuelTax;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [PriceUtils priceToString:totalPrice]];
    
//    PPDebug(@"changeNote:%@", flightSeat.changeNote);
//    PPDebug(@"refundNote:%@", flightSeat.refundNote);
    
    self.changeNoteTextView.text = [NSString stringWithFormat:@"                  %@", flightSeat.changeNote];
    self.refundNoteTextView.text = [NSString stringWithFormat:@"                  %@", flightSeat.refundNote];
    
    //change
    CGFloat width = self.changeNoteTextView.frame.size.width;
    UIFont *font = self.changeNoteTextView.font;    
    CGSize size =  [self.changeNoteTextView.text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    size = CGSizeMake(size.width, size.height + 30);
    self.changeNoteTextView.frame = CGRectMake( self.changeNoteTextView.frame.origin.x,  self.changeNoteTextView.frame.origin.y, width, size.height);
    
    //refund
    CGFloat y = self.changeNoteTextView.frame.origin.y + size.height - 16;
    self.refundNoteTitleLabel.frame = CGRectMake(self.refundNoteTitleLabel.frame.origin.x, y, self.refundNoteTitleLabel.frame.size.width, self.refundNoteTitleLabel.frame.size.height);
    
    size = [self.refundNoteTextView.text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    size = CGSizeMake(size.width, size.height + 30);
    self.refundNoteTextView.frame = CGRectMake( self.changeNoteTextView.frame.origin.x, y, width, size.height);
    
    self.rescheduleScrollView.contentSize = CGSizeMake(self.rescheduleScrollView.contentSize.width, y + size.height);
}

- (IBAction)clickSelectFlightSeatButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickSelectFlightSeatButton:)]) {
        [_delegate didClickSelectFlightSeatButton:_index];
    }
}

@end
