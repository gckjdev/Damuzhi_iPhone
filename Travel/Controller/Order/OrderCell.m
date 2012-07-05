//
//  OrderCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "OrderCell.h"
#import "TouristRoute.pb.h"
#import "AppManager.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@interface OrderCell ()

@property (retain, nonatomic) Order *order;

@end

@implementation OrderCell

@synthesize order = _order;
@synthesize delegate = _delegate;

@synthesize routeNameLabel;
@synthesize routeIdLabel;
@synthesize departCityLabel;
@synthesize departDateLabel;
@synthesize bookingDateLabel;
@synthesize personCountLabel;
@synthesize priceLabel;
@synthesize orderStatusLabel;

- (void)dealloc {
    [_order release];
    
    [routeNameLabel release];
    [routeIdLabel release];
    [departCityLabel release];
    [departDateLabel release];
    [bookingDateLabel release];
    [personCountLabel release];
    [priceLabel release];
    [orderStatusLabel release];
    [super dealloc];
}

+ (CGFloat)getCellHeight
{
    return 248;
}

+ (NSString *)getCellIdentifier
{
    return @"OrderCell";
}

- (void)setCellData:(Order *)order
{
    self.order  = order;
    
    routeNameLabel.text = order.routeName;
    routeIdLabel.text = [NSString stringWithFormat:@"%d", order.routeId];
    departCityLabel.text = order.departCityName;
    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:order.departDate];
    departDateLabel.text = [NSString stringWithFormat:NSLS(@"%@ %@"), dateToStringByFormat(departDate, @"MM月dd日"), chineseWeekDayFromDate(departDate)];
    
    NSDate *bookDate = [NSDate dateWithTimeIntervalSince1970:order.bookDate];
    bookingDateLabel.text = dateToStringByFormat(bookDate, @"yyyy-MM-dd HH:mm");
    
    personCountLabel.text = [NSString stringWithFormat:NSLS(@"成人%d位 儿童%d位"), order.adult, order.children];
    
    priceLabel.text = [NSString stringWithFormat:NSLS(@"%@(%@)"), order.price, order.priceStatus];
    
    orderStatusLabel.text = [self orderStatusString:order.status];
}

- (IBAction)clickRouteFeekbackButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRouteFeekback:)]){
        [_delegate didClickRouteFeekback:_order.routeId];
    }
}

- (IBAction)clickRouteDetailButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRouteDetail:)]){
        [_delegate didClickRouteDetail:_order.routeId];
    }
}

- (NSString*)orderStatusString:(int)orderStatus
{
    NSString *string;
    switch (orderStatus) {
        case 1:
            string = NSLS(@"意向订单");
            break;
            
        case 2:
            string = NSLS(@"处理中");
            break;
            
        case 3:
            string = NSLS(@"待支付");
            break;
            
        case 4:
            string = NSLS(@"已支付");
            break;
            
        case 5:
            string = NSLS(@"已完成");
            break;
            
        case 6:
            string = NSLS(@"取消");
            break;
            
        default:
            break;
    }
    
    return string;
}


@end
