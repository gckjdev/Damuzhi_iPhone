//
//  MakeAirOrderOneCell.h
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "PPTableViewCell.h"
#import "MakeOrderHeader.h"

@class AirOrder_Builder;

@interface MakeAirOrderOneCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *dateIconViewImage;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *flightIconImageView;
@property (retain, nonatomic) IBOutlet UILabel *flightLabel;

@property (retain, nonatomic) IBOutlet UIButton *departCityButton;
@property (retain, nonatomic) IBOutlet UIButton *flightDateButton;
@property (retain, nonatomic) IBOutlet UIButton *flightButton;
@property (retain, nonatomic) IBOutlet UIView *flightHolderView;

@property (retain, nonatomic) IBOutlet UIButton *clearDepartCityButton;
@property (retain, nonatomic) IBOutlet UIButton *clearFlightDateButton;
@property (retain, nonatomic) IBOutlet UIButton *clearFlightButton;
@property (retain, nonatomic) IBOutlet UIControl *clearButtonsHolderView;


- (void)setCellWithType:(AirType)airType
         departCityName:(NSString *)departCityName
                builder:(AirOrder_Builder *)builder;

@end
