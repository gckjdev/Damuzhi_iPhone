//
//  OrderFlightView.h
//  Travel
//
//  Created by haodong on 12-12-28.
//
//

#import <UIKit/UIKit.h>

@protocol OrderFlightViewDelegate <NSObject>

@optional
- (void)didClickRescheduleButton:(NSString *)url;
@end


@class AirOrder;
@class AirOrder_Builder;

@interface OrderFlightView : UIView
@property (retain, nonatomic) IBOutlet UILabel *flightTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *airLineAndFlightNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *planeTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *seatLabel;
@property (retain, nonatomic) IBOutlet UILabel *departAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *departTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveAirportLabel;
@property (retain, nonatomic) IBOutlet UILabel *arriveTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *adultPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *childPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *adultAirportFuelTax;
@property (retain, nonatomic) IBOutlet UILabel *childAirportFuelTax;

+ (id)createOrderFlightView:(id<OrderFlightViewDelegate>)delegate;

- (void)setViewWithOrder:(AirOrder *)airOrder;
- (void)setViewWithOrderBuilder:(AirOrder_Builder *)airOrderBuilder;

@end
