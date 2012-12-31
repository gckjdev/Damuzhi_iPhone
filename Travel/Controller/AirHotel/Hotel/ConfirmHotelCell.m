//
//  ConfirmHotelCell.m
//  Travel
//
//  Created by haodong on 12-12-1.
//
//

#import "ConfirmHotelCell.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"
#import "PriceUtils.h"
#import "OrderHotelView.h"

@implementation ConfirmHotelCell

+(NSString *)getCellIdentifier
{
    return @"ConfirmHotelCell";
}

+ (CGFloat)getCellHeight:(HotelOrder_Builder *)hotelOrderBuilder
{
    return [OrderHotelView getCellHeightWithBuiler:hotelOrderBuilder];
}

- (void)dealloc {
    [super dealloc];
}

#define TAG_ORDERHOTELVIEW  2012123101
- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    OrderHotelView *subView = (OrderHotelView *)[self viewWithTag:TAG_ORDERHOTELVIEW];
    [subView removeFromSuperview];
    
    OrderHotelView *orderHotelView = [OrderHotelView createOrderHotelView:self];
    orderHotelView.tag = TAG_ORDERHOTELVIEW;
    [orderHotelView setViewWithOrderBuilder:hotelOrderBuilder];
    orderHotelView.frame = CGRectMake(9, 0, orderHotelView.frame.size.width, orderHotelView.frame.size.height);
    [self addSubview:orderHotelView];
}

#pragma mark - 
#pragma OrderHotelViewDelegate methods
- (void)didClickHotelButton:(int)hotelId
{
    if ([delegate respondsToSelector:@selector(didClickShowHotelDetailButton:)]) {
        [delegate didClickShowHotelDetailButton:indexPath];
    }
}

- (void)didClickAddCheckInPersonButton:(int)hotelId
{
    if ([delegate respondsToSelector:@selector(didClickCheckInPersonButton:)]) {
        [delegate didClickCheckInPersonButton:indexPath];
    }
}

@end
