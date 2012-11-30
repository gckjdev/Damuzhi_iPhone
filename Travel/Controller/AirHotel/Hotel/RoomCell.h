//
//  RoomCell.h
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "PPTableViewCell.h"

@protocol RoomCellDelegate <NSObject>

@optional
- (void)didClickSelectRoomButton:(int)roomId isSelected:(BOOL)isSelected count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath;
- (void)didClickMinusButton:(int)roomId count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath;
- (void)didClickPlusButton:(int)roomId count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath;

@end

@class HotelRoom;

@interface RoomCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIButton *selectRoomButton;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;

- (void)setCellWithRoom:(HotelRoom *)room count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath isSelected:(BOOL)isSelected;

@end
