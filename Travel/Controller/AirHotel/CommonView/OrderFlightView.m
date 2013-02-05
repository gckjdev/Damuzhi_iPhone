//
//  OrderFlightView.m
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "OrderFlightView.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"
#import "LocaleUtils.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "PriceUtils.h"

@interface OrderFlightView()
@property (assign, nonatomic) id<OrderFlightViewDelegate> delegate;
@property (retain, nonatomic) NSString *rescheduleUrl;
@end


@implementation OrderFlightView


- (void)dealloc {
    [_rescheduleUrl release];
    [_flightTypeLabel release];
    [_flightDateLabel release];
    [_airLineAndFlightNumberLabel release];
    [_planeTypeLabel release];
    [_seatLabel release];
    [_departAirportLabel release];
    [_departTimeLabel release];
    [_arriveAirportLabel release];
    [_arriveTimeLabel release];
    [_adultPriceLabel release];
    [_childPriceLabel release];
    [_adultAirportFuelTax release];
    [_childAirportFuelTax release];
    [super dealloc];
}

+ (CGFloat)getViewHeight
{
    return 144;
}

+ (id)createOrderFlightView:(id<OrderFlightViewDelegate>)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderFlightView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create OrderFlightView but cannot find Nib");
        return nil;
    }
    
    OrderFlightView *orderFlightView = (OrderFlightView *)[topLevelObjects objectAtIndex:0];
    orderFlightView.delegate = delegate;
    
    return orderFlightView;
}

- (void)setViewWithOrder:(AirOrder *)airOrder
{
    AirOrder_Builder *builder = [[AirHotelManager defaultManager] airOrderBuilder:airOrder];
    [self setViewWithOrderBuilder:builder];
    
    UIColor *color = [UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:197.0/255.0 alpha:1];
    self.departAirportLabel.textColor = color;
    self.departTimeLabel.textColor = color;
    self.arriveAirportLabel.textColor = color;
    self.arriveTimeLabel.textColor = color;
}

- (void)setViewWithOrderBuilder:(AirOrder_Builder *)airOrderBuilder
{
    if (airOrderBuilder.flightType == FlightTypeGo || airOrderBuilder.flightType == FlightTypeGoOfDouble) {
        self.flightTypeLabel.text = NSLS(@"去程");
    } else {
        self.flightTypeLabel.text = NSLS(@"回程");
    }
    
    self.flightDateLabel.text = [[AirHotelManager defaultManager] dateIntToYearMonthDayWeekString2:airOrderBuilder.flightDate];
    
    NSString *airline = [[AppManager defaultManager] getAirlineName:airOrderBuilder.flight.airlineId];
    if (airline == nil) {
        airline = @"";
    }
    self.airLineAndFlightNumberLabel.text = [NSString stringWithFormat:@"%@ %@", airline, airOrderBuilder.flightNumber];
    
    self.planeTypeLabel.text = [NSString stringWithFormat:@"机型:%@",airOrderBuilder.flight.planeType] ;
    
    
    //set seatname
    NSString *reUrl = nil;
    for (FlightSeat *seat in airOrderBuilder.flight.flightSeatsList) {
        if ([seat.code isEqualToString:airOrderBuilder.flightSeatCode]) {
            reUrl = seat.reschedule;
            break;
        }
    }
    self.seatLabel.text = airOrderBuilder.flightSeat.name;
    self.rescheduleUrl = reUrl;
    
    //set airport and time
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:airOrderBuilder.flight.departDate];
    NSString *departDateStr =  dateToChineseStringByFormat(departDate, @"HH:mm");
    
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:airOrderBuilder.flight.arriveDate];
    NSString *arriveDateStr = dateToChineseStringByFormat(arriveDate, @"HH:mm");
    self.departTimeLabel.text = departDateStr;
    self.arriveTimeLabel.text = arriveDateStr;
    
    self.departAirportLabel.text = airOrderBuilder.flight.departAirport;
    self.arriveAirportLabel.text = airOrderBuilder.flight.arriveAirport;
    
    
    //set price
    double adultPrice = airOrderBuilder.flightSeat.adultTicketPrice + airOrderBuilder.flight.adultAirportTax + airOrderBuilder.flight.adultFuelTax;
    double childPrice = airOrderBuilder.flightSeat.childTicketPrice + airOrderBuilder.flight.childAirportTax + airOrderBuilder.flight.childFuelTax;
    self.adultPriceLabel.text = [PriceUtils priceToStringCNY:adultPrice];
    self.childPriceLabel.text = [PriceUtils priceToStringCNY:childPrice];
    
    self.adultAirportFuelTax.text = [NSString stringWithFormat:@"(机建/燃油: %@/%@)", [PriceUtils priceToString:airOrderBuilder.flight.adultAirportTax], [PriceUtils priceToString:airOrderBuilder.flight.adultFuelTax]];
    
    self.childAirportFuelTax.text = [NSString stringWithFormat:@"(机建/燃油: %@/%@)", [PriceUtils priceToString:airOrderBuilder.flight.childAirportTax], [PriceUtils priceToString:airOrderBuilder.flight.childFuelTax]];
}

- (IBAction)clickRescheduleButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRescheduleButton:)]) {
        [_delegate didClickRescheduleButton:_rescheduleUrl];
    }
}

@end
