//
//  ConfirmHotelCell.h
//  Travel
//
//  Created by haodong on 12-12-1.
//
//

#import "PPTableViewCell.h"
#import "OrderHotelView.h"

@protocol ConfirmHotelCellDelegate <NSObject>
@optional
- (void)didClickCheckInPersonButton:(NSIndexPath *)indexPath;
- (void)didClickShowHotelDetailButton:(NSIndexPath *)indexPath;
@end


@class HotelOrder_Builder;

@interface ConfirmHotelCell : PPTableViewCell<OrderHotelViewDelegate>
+ (CGFloat)getCellHeight:(HotelOrder_Builder *)hotelOrderBuilder;
- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath;

@end
