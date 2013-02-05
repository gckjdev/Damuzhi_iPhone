//
//  ConfirmAirCell.h
//  Travel
//
//  Created by haodong on 12-12-3.
//
//

#import "PPTableViewCell.h"
#import "OrderFlightView.h"

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
@property (retain, nonatomic) IBOutlet UIView *passengerHolderView;
@property (retain, nonatomic) IBOutlet UIButton *passengerButton;
@property (retain, nonatomic) IBOutlet UIButton *insuranceButton;
@property (retain, nonatomic) IBOutlet UIButton *sendTicketButton;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (retain, nonatomic) IBOutlet UILabel *sendTicketLabel;

+ (CGFloat)getCellHeight:(NSArray *)airOrderBuilders;

- (void)setCellWithAirOrderBuilders:(NSArray *)airOrderBuilders indexPath:(NSIndexPath *)aInadexPath;

@end
