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
#import "PersonsView.h"

@implementation ConfirmAirCell

+(NSString *)getCellIdentifier
{
    return @"ConfirmAirCell";
}

+ (CGFloat)getCellHeight:(NSArray *)airOrderBuilders
{
    NSUInteger passengerCount = 0;
    if ([airOrderBuilders count] > 0) {
        AirOrder_Builder *builder = [airOrderBuilders objectAtIndex:0];
        passengerCount = [builder.passengerList count];
    }
    
    if (passengerCount == 0) {
        passengerCount = 1;
    }
    
    return [OrderFlightView getViewHeight] * [airOrderBuilders count] + 24 * (passengerCount -1) +  120;
}

- (void)dealloc {
    [_passengerButton release];
    [_insuranceButton release];
    [_sendTicketButton release];
    [_holderView release];
    [_footerView release];
    [_insuranceLabel release];
    [_sendTicketLabel release];
    [_passengerHolderView release];
    [super dealloc];
}

#define PLACE_TOP_PERSONS   8
- (void)setCellWithAirOrderBuilders:(NSArray *)airOrderBuilders indexPath:(NSIndexPath *)aInadexPath
{
    self.indexPath = aInadexPath;
    
    //set flight
    for(UIView *subview in [self.holderView subviews]) {
        if ([subview isKindOfClass:[OrderFlightView class]]) {
            [subview removeFromSuperview];
        }
    }
    CGFloat y = 0;
    for (AirOrder_Builder *builder in airOrderBuilders) {
        OrderFlightView *view = [OrderFlightView createOrderFlightView:delegate];
        [view setViewWithOrderBuilder:builder];
        view.frame = CGRectMake(0, y, view.frame.size.width, view.frame.size.height);
        [self.holderView addSubview:view];
        y += view.frame.size.height;
    }
    
    
    AirOrder_Builder *oneBuilder = nil;
    if ([airOrderBuilders count] > 0) {
        oneBuilder = [airOrderBuilders objectAtIndex:0];
    }
    
    //set persons
    for(UIView *subview in [self.passengerHolderView subviews]) {
        if ([subview isKindOfClass:[PersonsView class]]) {
            [subview removeFromSuperview];
        }
    }
    PersonsView *personsView = [PersonsView createCheckInPersonLabels:oneBuilder.passengerList type:PersonListTypePassenger];
    personsView.frame = CGRectMake(0, PLACE_TOP_PERSONS, personsView.frame.size.width, personsView.frame.size.height);
    
    [self.passengerHolderView insertSubview:personsView belowSubview:_passengerButton];
    
    //set frame
    self.passengerHolderView.frame = CGRectMake(_passengerHolderView.frame.origin.x, y, _passengerHolderView.frame.size.width, personsView.frame.size.height + 2*PLACE_TOP_PERSONS);
    y += _passengerHolderView.frame.size.height;
    self.footerView.frame = CGRectMake(_footerView.frame.origin.x, y, _footerView.frame.size.width, _footerView.frame.size.height);
    self.holderView.frame = CGRectMake(_holderView.frame.origin.x, _holderView.frame.origin.y, _holderView.frame.size.width, _footerView.frame.origin.y + _footerView.frame.size.height);
    
    
    //set value
    if ([oneBuilder.passengerList count] > 0) {
        [self.passengerButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.passengerButton setTitle:@"添加登机人" forState:UIControlStateNormal];
    }
    
    self.insuranceLabel.text = [NSString stringWithFormat:@"%@/份", [PriceUtils priceToStringCNY:oneBuilder.flight.insuranceFee]];
    self.sendTicketLabel.text = [NSString stringWithFormat:@"报销凭证(快递费%@元)",[PriceUtils priceToString:oneBuilder.flight.sendTicketFee]];
    
    self.insuranceButton.selected = oneBuilder.insurance;
    self.sendTicketButton.selected = oneBuilder.sendTicket;
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

@end
