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
@property (retain, nonatomic) IBOutlet UIView *holderView;
@property (retain, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIButton *checkInPersonButton;
@property (retain, nonatomic) IBOutlet UIView *roomInfoHolderView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIView *checkInPersonHolderView;

+ (CGFloat)getCellHeight:(NSUInteger)roomInfosCount personCount:(NSUInteger)personCount;

- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath;

@end
