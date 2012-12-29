//
//  HotelOrderDetailCell.h
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "PPTableViewCell.h"
#import "OrderHotelView.h"


@class AirHotelOrder;

@interface HotelOrderDetailCell : PPTableViewCell<OrderHotelViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *holderView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UIView *priceHolderView;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

+ (CGFloat)getCellHeight:(AirHotelOrder *)airHotelOrde;
- (void)setCellWithOrther:(AirHotelOrder *)airHotelOrde;

@end
