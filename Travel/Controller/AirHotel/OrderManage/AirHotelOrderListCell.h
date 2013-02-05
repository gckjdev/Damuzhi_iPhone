//
//  AirHotelOrderListCell.h
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "PPTableViewCell.h"

@class AirHotelOrder;

@interface AirHotelOrderListCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *airPriceLabel;

@property (retain, nonatomic) IBOutlet UILabel *airlineAndFlightNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *planeTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *seatLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *departTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportLabel;

@property (retain, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *hotelPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *hotelDateLabel;

@property (retain, nonatomic) IBOutlet UIView *airHolderView;
@property (retain, nonatomic) IBOutlet UIView *hotelHolderView;
@property (retain, nonatomic) IBOutlet UIView *roomInfoHolderView;

@property (retain, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (retain, nonatomic) IBOutlet UIView *middleSolidLineView;
@property (retain, nonatomic) IBOutlet UIImageView *middleDottedLineImageView;



+ (CGFloat)getCellHeight:(AirHotelOrder *)order;

- (void)setCellWithOrder:(AirHotelOrder *)order;

@end
