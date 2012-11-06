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
#import "UserManager.h"
#import "PPDebug.h"
#import "TravelNetworkConstants.h"

#define ORDER_ITEM_LABEL_ORIGIN_X 28
#define GAP_BETWEEN_ORDER_ITEMS 24
#define ORDER_ITEM_LABEL_WIDTH 250
#define ORDER_ITEM_LABEL_HEIGHT 25

@interface OrderCell ()

@property (retain, nonatomic) Order *order;
@end

@implementation OrderCell

@synthesize order = _order;
@synthesize delegate = _delegate;
@synthesize orderPayButton;
@synthesize routeFeedback;
@synthesize routeDetail;

@synthesize cellBgImageView;

- (void)dealloc {
    [_order release];
    [orderPayButton release];
    [routeFeedback release];
    [routeDetail release];
    [cellBgImageView release];
    [super dealloc];
}



//+ (CGFloat)getCellHeight
//{
//    return 248;
//}

+ (NSString *)getCellIdentifier
{
    return @"OrderCell";
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
    label.textColor = [UIColor colorWithRed:74./255. green:74./255. blue:74./255. alpha:1.0];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}


- (void)setCellData:(Order *)order orderType:(int )orderType
{
    self.order  = order;
    
    NSString *routeNameLabelText = [NSString stringWithFormat:@"路线名称: %@",order.routeName];
    UILabel *routeNameLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, 5, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:routeNameLabelText];
    [self addSubview:routeNameLabel];
    
    NSString *routeIdLabelText = [NSString stringWithFormat:@"路线编号: %d",order.routeId];
    UILabel *routeIdLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, 5 + GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:routeIdLabelText];
    [self addSubview:routeIdLabel];
    
    CGFloat originY = routeIdLabel.frame.origin.y;
    if ([order hasPackageName]) {
        NSString *routePackageNameLabelText = [NSString stringWithFormat:@"套餐名称: %@",order.packageName];
        UILabel *routePackageNameLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:routePackageNameLabelText];
        [self addSubview:routePackageNameLabel];
    } 
    
    if (orderType != OBJECT_LIST_LOCAL_ROUTE_ORDER) {
        NSString *departCityLabelText = [NSString stringWithFormat:@"出发城市: %@",order.departCityName];
        UILabel *departCityLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:departCityLabelText];
        [self addSubview:departCityLabel];
    }

    
    NSDate *departDate = [NSDate dateWithTimeIntervalSince1970:order.departDate - 8 * 3600];
    NSString *departDateLabelText = [NSString stringWithFormat:NSLS(@"%@ %@"), dateToStringByFormat(departDate, @"yyyy年MM月dd日"), chineseWeekDayFromDate(departDate)]; 
    departDateLabelText = [NSString stringWithFormat:@"出发时间: %@",departDateLabelText];
    UILabel *departDateLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:departDateLabelText];
    [self addSubview:departDateLabel];
    
    NSDate *bookDate = [NSDate dateWithTimeIntervalSince1970:order.bookDate - 8 * 3600];
    NSString *bookingDateLabelText = dateToStringByFormat(bookDate, @"yyyy年MM月dd日 HH:mm");
    bookingDateLabelText = [NSString stringWithFormat:@"预订时间: %@",bookingDateLabelText];
    UILabel *bookingDateLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:bookingDateLabelText];
    [self addSubview:bookingDateLabel];

    NSString *personCountLabelText = [NSString stringWithFormat:@"出游人数: 成人%d位 儿童%d位",order.adult, order.children];
    UILabel *personCountLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:personCountLabelText];
    [self addSubview:personCountLabel];
    
    NSString *priceLabelText = [NSString stringWithFormat:@"参考价格: %@%d%@" , order.currency ,order.price, order.priceStatus];
    UILabel *priceLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:priceLabelText];
    priceLabel.textColor = [UIColor colorWithRed:255/255.0 green:48/255.0 blue:0.0 alpha:1.0];
    [self addSubview:priceLabel];
    
    NSString *orderStatusLabelText = [self orderStatusString:order.status];
    orderStatusLabelText = [NSString stringWithFormat:@"订单状态: %@", orderStatusLabelText];
    UILabel *orderStatusLabel = [self labelWithFrame:CGRectMake(ORDER_ITEM_LABEL_ORIGIN_X, originY += GAP_BETWEEN_ORDER_ITEMS, ORDER_ITEM_LABEL_WIDTH, ORDER_ITEM_LABEL_HEIGHT) text:orderStatusLabelText];
    orderStatusLabel.textColor = [UIColor colorWithRed:22/255.0 green:118/255.0 blue:0.0 alpha:1.0];
    [self addSubview:orderStatusLabel];
    
    orderPayButton.frame = CGRectMake(22, originY + 32, 80, 28);
    routeDetail.frame = CGRectMake(110, originY + 32, 80, 28);
    routeFeedback.frame = CGRectMake(198, originY + 32, 80, 28);
    
    orderPayButton.hidden = YES;
    if ([[UserManager defaultManager] isLogin])
    {
        routeDetail.center = CGPointMake(103, routeDetail.center.y);
        routeFeedback.center = CGPointMake(206, routeFeedback.center.y);
        
    }
    else
    {
            routeFeedback.hidden = YES;
            routeDetail.center = CGPointMake(160 - 3, orderPayButton.center.y);
    }
}

- (IBAction)clickRouteFeekbackButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRouteFeekback:)]){
        [_delegate didClickRouteFeekback:_order];
    }
    
}

- (IBAction)clickRouteDetailButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRouteDetail:)]){
        [_delegate didClickRouteDetail:_order];
    }
}

- (NSString*)orderStatusString:(int)orderStatus
{
    NSString *string = @"";
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
