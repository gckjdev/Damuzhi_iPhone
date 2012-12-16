//
//  FlightSeatView.h
//  Travel
//
//  Created by haodong on 12-12-11.
//
//

#import <UIKit/UIKit.h>

@protocol FlightSeatViewDelegate <NSObject>

@optional
- (void)didClickSelectFlightSeatButton:(int)index;

@end


@class Flight;

@interface FlightSeatView : UIView

@property (retain, nonatomic) IBOutlet UILabel *flightSeatNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *planeTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *remainingCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *airportAndFuelTax;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UITextView *refundNoteTextView;
@property (retain, nonatomic) IBOutlet UITextView *changeNoteTextView;
@property (assign, nonatomic) id<FlightSeatViewDelegate> delegate;

+ (id)createFlightSeatView:(id<FlightSeatViewDelegate>)delegate;

- (void)setViewWithFlight:(Flight *)flight index:(int)index;

@end
