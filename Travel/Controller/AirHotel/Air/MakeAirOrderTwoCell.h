//
//  MakeAirOrderTwoCell.h
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "PPTableViewCell.h"

@protocol MakeAirOrderCellDelegate <NSObject>

@optional
- (void)didClickDepartCityButton;
- (void)didClickGoDateButton;
- (void)didClickBackDateButton;
- (void)didClickGoFlightButton;
- (void)didClickBackFlightButton;

@end

@interface MakeAirOrderTwoCell : PPTableViewCell

@end
