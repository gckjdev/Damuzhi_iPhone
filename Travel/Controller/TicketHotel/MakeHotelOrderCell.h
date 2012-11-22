//
//  MakeHotelOrderCell.h
//  Travel
//
//  Created by haodong on 12-11-22.
//
//

#import "PPTableViewCell.h"

@protocol MakeHotelOrderCellDelegate <NSObject>

@optional
- (void)didClickCheckInButton:(NSIndexPath *)indexPath;
- (void)didClickCheckOutButton:(NSIndexPath *)indexPath;
- (void)didClickHotelButton:(NSIndexPath *)indexPath;

@end




@interface MakeHotelOrderCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIButton *checkInButton;
@property (retain, nonatomic) IBOutlet UIButton *checkOutButton;
@property (retain, nonatomic) IBOutlet UIButton *hotelButton;

@end
