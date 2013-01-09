//
//  AirOrderDetailCell.h
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "PPTableViewCell.h"
#import "OrderFlightView.h"

@class AirHotelOrder;

@interface AirOrderDetailCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIView *holderView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIView *passengerHolderView;
@property (retain, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (retain, nonatomic) IBOutlet UILabel *sendTickeLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIView *priceHolderView;


- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde;

@end
