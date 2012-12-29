//
//  AirHotelOrderDetailTopCell.h
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import "PPTableViewCell.h"

@class AirHotelOrder;

@interface AirHotelOrderDetailTopCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (retain, nonatomic) IBOutlet UILabel *departCityLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveCityLabel;

@property (retain, nonatomic) IBOutlet UILabel *departDateLabel;

@property (retain, nonatomic) IBOutlet UILabel *contactPersonLabel;

- (void)setCellWithOrder:(AirHotelOrder *)order;

@end
