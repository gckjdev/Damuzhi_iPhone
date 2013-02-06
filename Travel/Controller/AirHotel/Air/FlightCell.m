//
//  FlightCell.m
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "FlightCell.h"
#import "ImageManager.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"
#import "AppManager.h"
#import "PriceUtils.h"
#import "UIImageView+WebCache.h"
#import "AnimationManager.h"
#import "AppUtils.h"

@implementation FlightCell

- (void)dealloc {
    [_flightCellBackgroundImageView release];
    [_priceLabel release];
    [_discountLabel release];
    [_departDateLabel release];
    [_arriveDateLabel release];
    [_departAirportLabel release];
    [_arriveAirportLabel release];
    [_airlineNameLabel release];
    [_flightNumberLabel release];
    [_areLineLogo release];
    [super dealloc];
}

+ (id)createCell:(id)delegate
{
    FlightCell *cell = [super createCell:delegate];
    cell.flightCellBackgroundImageView.image = [[ImageManager defaultManager] hotelListBgImage];
    return cell;
}

+(NSString *)getCellIdentifier
{
    return @"FlightCell";
}

+ (CGFloat)getCellHeight
{
    return 63;
}

#define FLIGHT_TIME_FORMAT @"HH:mm"

- (void)setCellWithFlight:(Flight *)flight
{
    [self clearContent];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@", [PriceUtils priceToString:flight.price]];
    
    if (flight.discount.length == 0) {
        self.discountLabel.text = @"无折扣";
    }else {
        self.discountLabel.text = flight.discount;
    }
    
    [self.areLineLogo setImageWithURL:[NSURL URLWithString:[[AppManager defaultManager] getAirlineLogo:flight.airlineId]] placeholderImage:nil success:^(UIImage *image, BOOL cached) {
        if (!cached) {
            self.areLineLogo.alpha = 0;
            [AnimationManager appearAnimationFrom:0 to:1 delay:0 duration:0.3];
            }
        } failure:^(NSError *error) {
    }];
    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:[AppUtils standardTimeFromBeijingTime:flight.departDate]];
    self.departDateLabel.text = dateToChineseStringByFormat(departDate, FLIGHT_TIME_FORMAT);
    
    NSDate *arriveDate = [NSDate dateWithTimeIntervalSince1970:[AppUtils standardTimeFromBeijingTime:flight.arriveDate]];
    self.arriveDateLabel.text = dateToChineseStringByFormat(arriveDate, FLIGHT_TIME_FORMAT);
    
    self.departAirportLabel.text = flight.departAirport;
    self.arriveAirportLabel.text = flight.arriveAirport;
    
    self.airlineNameLabel.text = [[AppManager defaultManager] getAirlineName:flight.airlineId];
    self.flightNumberLabel.text = flight.flightNumber;
    
    
}

- (void)clearContent
{
    self.priceLabel.text = nil;
    self.discountLabel.text = nil;
    self.departDateLabel.text = nil;
    self.arriveDateLabel.text = nil;
    self.departAirportLabel.text = nil;
    self.arriveAirportLabel.text = nil;
    self.airlineNameLabel.text = nil;
    self.flightNumberLabel.text = nil;
}

@end
