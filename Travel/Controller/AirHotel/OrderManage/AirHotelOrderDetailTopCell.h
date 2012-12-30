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

@property (retain, nonatomic) IBOutlet UIView *departCityHolderView;
@property (retain, nonatomic) IBOutlet UIView *arrvieCityHolderView;
@property (retain, nonatomic) IBOutlet UIView *departDateHolderView;
@property (retain, nonatomic) IBOutlet UIView *contactHolderView;
@property (retain, nonatomic) IBOutlet UIView *holderView;

+ (CGFloat)getCellHeight:(AirHotelOrder *)order;
- (void)setCellWithOrder:(AirHotelOrder *)order;

@end
