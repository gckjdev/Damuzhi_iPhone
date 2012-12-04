//
//  MakeAirOrderOneCell.m
//  Travel
//
//  Created by haodong on 12-11-23.
//
//

#import "MakeAirOrderOneCell.h"
#import "LocaleUtils.h"

@implementation MakeAirOrderOneCell

+ (NSString*)getCellIdentifier
{
    return @"MakeAirOrderOneCell";
}

+ (CGFloat)getCellHeight
{
    return 120.0f;
}

- (void)setCellWithType:(AirType)airType
{
    if (airType == AirGo) {
        self.dateIconViewImage.image = [UIImage imageNamed:@"ticket_p2.png"];
        self.dateLabel.text = NSLS(@"回程日期");
        self.flightIconImageView.image = [UIImage imageNamed:@"ticket_p5.png"];
        self.flightLabel.text = NSLS(@"去程");
    } else {
        self.dateIconViewImage.image = [UIImage imageNamed:@"ticket_p3.png"];
        self.dateLabel.text = NSLS(@"出发日期");
        self.flightIconImageView.image = [UIImage imageNamed:@"ticket_p6.png"];
        self.flightLabel.text = NSLS(@"回程");
    }
}

- (void)dealloc {
    [_dateLabel release];
    [_flightLabel release];
    [_dateIconViewImage release];
    [_flightIconImageView release];
    [super dealloc];
}
@end
