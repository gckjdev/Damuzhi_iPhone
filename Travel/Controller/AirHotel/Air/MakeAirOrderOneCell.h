//
//  MakeAirOrderOneCell.h
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "PPTableViewCell.h"
#import "MakeOrderHeader.h"

@interface MakeAirOrderOneCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *dateIconViewImage;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *flightIconImageView;
@property (retain, nonatomic) IBOutlet UILabel *flightLabel;

- (void)setCellWithType:(AirType)airType;

@end
