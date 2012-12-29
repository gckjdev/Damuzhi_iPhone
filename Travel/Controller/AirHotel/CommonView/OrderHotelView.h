//
//  OrderHotelView.h
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import <UIKit/UIKit.h>

@protocol OrderHotelViewDelegate <NSObject>

@end

@class HotelOrder;
@class HotelOrder_Builder;

@interface OrderHotelView : UIView

@property (retain, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIView *roomInfoHolderView;
@property (retain, nonatomic) IBOutlet UIView *checkInPersonHolderView;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (retain, nonatomic) IBOutlet UIButton *checkInPersonButton;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (retain, nonatomic) IBOutlet UIButton *addCheckInPersonButton;

+ (id)createOrderHotelView:(id<OrderHotelViewDelegate>)delegate;

+ (CGFloat)getCellHeightWithBuiler:(HotelOrder_Builder *)builder;
+ (CGFloat)getCellHeightWithOrder:(HotelOrder *)order;

- (void)setViewWithOrder:(HotelOrder *)hotelOrder;
- (void)setViewWithOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder;

@end
