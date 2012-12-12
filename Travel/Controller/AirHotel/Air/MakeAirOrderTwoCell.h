//
//  MakeAirOrderTwoCell.h
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "PPTableViewCell.h"
#import "MakeOrderHeader.h"

@class AirOrder_Builder;

@interface MakeAirOrderTwoCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIButton *departCityButton;
@property (retain, nonatomic) IBOutlet UIButton *goDateButton;
@property (retain, nonatomic) IBOutlet UIButton *backDateButton;
@property (retain, nonatomic) IBOutlet UIButton *goFlightButton;
@property (retain, nonatomic) IBOutlet UIButton *backFlightButton;

- (void)setCellByDepartCityName:(NSString *)departCityName
                      goBuilder:(AirOrder_Builder *)goBuilder
                    backBuilder:(AirOrder_Builder *)backBuilder;

@end
