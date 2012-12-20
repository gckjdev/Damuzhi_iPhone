//
//  ConfirmAirCell.h
//  Travel
//
//  Created by haodong on 12-12-3.
//
//

#import "PPTableViewCell.h"

@protocol ConfirmAirCellDelegate <NSObject>
@optional
- (void)didClickInsuranceButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected;
- (void)didClickSendTicketButton:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected;
- (void)didClickPassengerButton:(NSIndexPath *)indexPath;
- (void)didClickRescheduleButton:(NSIndexPath *)indexPath;

@end

@class AirOrder_Builder;


@interface ConfirmAirCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIView *holderView;
@property (retain, nonatomic) IBOutlet UILabel *flightTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *airLineAndFlightNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *planeTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *seatLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportAndTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportAndTimeLabel;

@property (retain, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *childPriceLabel;

@property (retain, nonatomic) IBOutlet UILabel *adultAirportFuelTax;
@property (retain, nonatomic) IBOutlet UILabel *childAirportFuelTax;
@property (retain, nonatomic) IBOutlet UIButton *passengerButton;

@property (retain, nonatomic) IBOutlet UILabel *insuranceFeeLabel;
@property (retain, nonatomic) IBOutlet UILabel *sendTicketFeeLabel;
@property (retain, nonatomic) IBOutlet UIButton *insuranceButton;
@property (retain, nonatomic) IBOutlet UIButton *sendTicketButton;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIView *personHolderView;

+ (CGFloat)getCellHeight:(NSUInteger)personListCount;

- (void)setCellWithAirOrderBuilder:(AirOrder_Builder *)airOrderBuilder indexPath:(NSIndexPath *)aInadexPath;

@end
