//
//  FlightSimpleView.h
//  Travel
//
//  Created by haodong on 12-12-15.
//
//

#import <UIKit/UIKit.h>

@class Flight;

@interface FlightSimpleView : UIView
@property (retain, nonatomic) IBOutlet UILabel *airlineNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *departDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightSeatLabel;

+ (id)createFlightSimpleView;

- (void)setViewWith:(Flight *)flight flightSeatCode:(NSString *)flightSeatCode;

@end
