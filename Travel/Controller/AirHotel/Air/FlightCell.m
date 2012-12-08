//
//  FlightCell.m
//  Travel
//
//  Created by haodong on 12-12-7.
//
//

#import "FlightCell.h"
#import "ImageManager.h"

@implementation FlightCell

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

- (void)dealloc {
    [_flightCellBackgroundImageView release];
    [super dealloc];
}
@end
