//
//  ConfirmHotelCell.h
//  Travel
//
//  Created by haodong on 12-12-1.
//
//

#import "PPTableViewCell.h"

@protocol ConfirmHotelCellDelegate <NSObject>
@optional
- (void)didClickCheckInPersonButton:(NSIndexPath *)indexPath;
@end

@class HotelOrder_Builder;

@interface ConfirmHotelCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIButton *checkInPersonButton;

- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath;

@end
