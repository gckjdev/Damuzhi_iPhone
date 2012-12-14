//
//  FlightCell.h
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "PPTableViewCell.h"

@class Flight;

@interface FlightCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *flightCellBackgroundImageView;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *discountLabel;
@property (retain, nonatomic) IBOutlet UILabel *departDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *airlineNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightNumberLabel;

- (void)setCellWithFlight:(Flight *)flight;

@end
