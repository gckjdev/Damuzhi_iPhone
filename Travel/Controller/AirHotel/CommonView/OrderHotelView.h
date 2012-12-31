//
//  OrderHotelView.h
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import <UIKit/UIKit.h>

@protocol OrderHotelViewDelegate <NSObject>
@optional
- (void)didClickHotelButton:(int)hotelId;
- (void)didClickAddCheckInPersonButton:(int)hotelId;
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
@property (retain, nonatomic) IBOutlet UIButton *hotelButton;

+ (id)createOrderHotelView:(id<OrderHotelViewDelegate>)delegate;

//user to view 
+ (CGFloat)getCellHeightWithOrder:(HotelOrder *)order;
- (void)setViewWithOrder:(HotelOrder *)hotelOrder;

//user to edit and view
+ (CGFloat)getCellHeightWithBuiler:(HotelOrder_Builder *)builder;
- (void)setViewWithOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder;

@end
