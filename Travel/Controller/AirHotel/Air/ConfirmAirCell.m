//
//  ConfirmAirCell.m
//  Travel
//
//  Created by haodong on 12-12-3.
//
//

#import "ConfirmAirCell.h"
#import "AirHotel.pb.h"
#import "AirHotelManager.h"
#import "LocaleUtils.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "LogUtil.h"
#import "PriceUtils.h"

@implementation ConfirmAirCell

+(NSString *)getCellIdentifier
{
    return @"ConfirmAirCell";
}


#define PERSON_LABEL_HEIGHT     24
#define CONFIRM_AIR_CELL_BASIC_HEIGHT 269 

+ (CGFloat)getCellHeight:(NSUInteger)personListCount
{
    if (personListCount == 0) {
        return CONFIRM_AIR_CELL_BASIC_HEIGHT;
    } else {
        return CONFIRM_AIR_CELL_BASIC_HEIGHT + (personListCount - 1) * PERSON_LABEL_HEIGHT;
    }
}

- (void)dealloc {
    [_flightDateLabel release];
    [_flightTypeLabel release];
    [_airLineAndFlightNumberLabel release];
    [_planeTypeLabel release];
    [_seatLabel release];
    [_departAirportAndTimeLabel release];
    [_arriveAirportAndTimeLabel release];
    [_adultPriceLabel release];
    [_childPriceLabel release];
    [_adultAirportFuelTax release];
    [_childAirportFuelTax release];
    [_passengerButton release];
    [_insuranceFeeLabel release];
    [_sendTicketFeeLabel release];
    [_insuranceButton release];
    [_sendTicketButton release];
    [_holderView release];
    [_footerView release];
    [_personHolderView release];
    [super dealloc];
}


#define FOOTER_VIEW_BASIC_Y         189
#define HOLDER_VIEW_BASIC_HEIGHT    269
#define PERSON_LABEL_BASIC_X    0
#define PERSON_LABEL_BASIC_Y    0
- (void)createPassengersLables:(NSArray *)personList
{
    for(UIView *subview in [self.personHolderView subviews]) {
        [subview removeFromSuperview];
    }
    
    int index = 0;
    for (Person *person in personList) {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(PERSON_LABEL_BASIC_X, PERSON_LABEL_BASIC_Y + ( index * PERSON_LABEL_HEIGHT ), 208, PERSON_LABEL_HEIGHT)] autorelease];
        label.textColor = [UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1];
        label.text = [NSString stringWithFormat:@"%@ %@", person.name, person.cardNumber];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        [self.personHolderView addSubview:label];
        
        index ++;
    }
    
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, FOOTER_VIEW_BASIC_Y + (index - 1) * PERSON_LABEL_HEIGHT, self.footerView.frame.size.width, self.footerView.frame.size.height);
    
    self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, self.holderView.frame.origin.y, self.holderView.frame.size.width, HOLDER_VIEW_BASIC_HEIGHT + (index - 1) * PERSON_LABEL_HEIGHT);
}

- (void)setCellWithAirOrderBuilder:(AirOrder_Builder *)airOrderBuilder indexPath:(NSIndexPath *)aInadexPath
{
    self.indexPath = aInadexPath;
    
    if (airOrderBuilder.flightType == FlightTypeGo || airOrderBuilder.flightType == FlightTypeGoOfDouble) {
        self.flightTypeLabel.text = NSLS(@"去程");
    } else {
        self.flightTypeLabel.text = NSLS(@"回程");
    }
    
    self.flightDateLabel.text = [[AirHotelManager defaultManager] dateIntToYearMonthDayWeekString2:airOrderBuilder.flightDate];
    
    NSString *airline = [[AppManager defaultManager] getAirlineName:airOrderBuilder.flight.airlineId];
    self.airLineAndFlightNumberLabel.text = [NSString stringWithFormat:@"%@ %@", airline, airOrderBuilder.flightNumber];
    
    self.planeTypeLabel.text = [NSString stringWithFormat:@"机型:%@",airOrderBuilder.flight.planeType] ;
    
    
    //set seatname
    NSString *seatName = nil;
    for (FlightSeat *seat in airOrderBuilder.flight.flightSeatsList) {
        if ([seat.code isEqualToString:airOrderBuilder.flightSeatCode]) {
            seatName = seat.name;
            break;
        }
    }
    self.seatLabel.text = seatName;
    
    
    //set airport and time
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:airOrderBuilder.flight.departDate];
    NSString *departDateStr =  dateToChineseStringByFormat(departDate, @"hh:mm");
    
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:airOrderBuilder.flight.arriveDate];
    NSString *arriveDateStr = dateToChineseStringByFormat(arriveDate, @"hh:mm");
    self.departAirportAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@",airOrderBuilder.flight.departAirport, departDateStr];
    self.arriveAirportAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", arriveDateStr,airOrderBuilder.flight.arriveAirport];
    
    //TO DO
    //self.adultPriceLabel.text =
    //self.childPriceLabel.text =
    
    
    self.adultAirportFuelTax.text = [NSString stringWithFormat:@"(机建/燃油: %@/%@)", [PriceUtils priceToString:airOrderBuilder.flight.adultAirportTax], [PriceUtils priceToString:airOrderBuilder.flight.adultFuelTax]];
    
    self.childAirportFuelTax.text = [NSString stringWithFormat:@"(机建/燃油: %@/%@)", [PriceUtils priceToString:airOrderBuilder.flight.childAirportTax], [PriceUtils priceToString:airOrderBuilder.flight.childFuelTax]];
    
    
    //set passenger
    if ([airOrderBuilder.passengerList count] > 0) {
        [self.passengerButton setTitle:@"" forState:UIControlStateNormal];
        
        [self createPassengersLables:airOrderBuilder.passengerList];
        
    } else {
        [self.passengerButton setTitle:NSLS(@"添加登机人") forState:UIControlStateNormal];
    }
    
    
    self.insuranceButton.selected = airOrderBuilder.insurance;
    self.sendTicketButton.selected = airOrderBuilder.sendTicket;
}

- (IBAction)clickInsuranceButton:(id)sender {
    self.insuranceButton.selected = !self.insuranceButton.selected;
    
    if ([delegate respondsToSelector:@selector(didClickInsuranceButton:isSelected:)]) {
        [delegate didClickInsuranceButton:indexPath isSelected:_insuranceButton.selected];
    }
}

- (IBAction)clickSendTicketButton:(id)sender {
    self.sendTicketButton.selected = !self.sendTicketButton.selected;
    
    if ([delegate respondsToSelector:@selector(didClickSendTicketButton:isSelected:)]) {
        [delegate didClickSendTicketButton:indexPath isSelected:_sendTicketButton.selected];
    }
}

- (IBAction)clickPassengerButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickPassengerButton:)]) {
        [delegate didClickPassengerButton:indexPath];
    }
}

- (IBAction)clickRescheduleButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickRescheduleButton:)]) {
        [delegate didClickRescheduleButton:indexPath];
    }
}
@end
