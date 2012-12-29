//
//  OrderHotelView.m
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import "OrderHotelView.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"
#import "AirHotelManager.h"
#import "PriceUtils.h"
#import "RoomInfoView.h"
#import "PersonsView.h"
#import "LogUtil.h"

@interface OrderHotelView()
@property (assign, nonatomic) id<OrderHotelViewDelegate> delegate;
@end


@implementation OrderHotelView

+ (id)createOrderHotelView:(id<OrderHotelViewDelegate>)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderHotelView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create OrderHotelView but cannot find Nib");
        return nil;
    }
    
    OrderHotelView *orderHotelView = (OrderHotelView *)[topLevelObjects objectAtIndex:0];
    orderHotelView.delegate = delegate;
    
    return orderHotelView;
}


#define HEIGHT_BAISC 160
+ (CGFloat)getCellHeightWithBuiler:(HotelOrder_Builder *)builder
{
    return HEIGHT_BAISC + [RoomInfoView getHeight:builder.roomInfosList] - 25 + [PersonsView getHeight:builder.checkInPersonsList] - 24;
}

+ (CGFloat)getCellHeightWithOrder:(HotelOrder *)order
{
    HotelOrder_Builder *builder = [[AirHotelManager defaultManager] hotelOrderBuilder:order];
    return [self getCellHeightWithBuiler:builder];
}

- (CGRect)updateOriginY:(UIView *)view originY:(CGFloat )originY
{
    return CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height);
}

- (CGRect)updateHeight:(UIView *)view height:(CGFloat )height
{
    return CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

#define PACE_PERSONSVIEW_BEFORE  11
- (void)createCheckInPersonView:(NSArray *)personList
{
    PersonsView *personsView = [PersonsView createCheckInPersonLabels:personList];
    //personsView.backgroundColor = [UIColor blueColor];
    
    personsView.frame = [self updateOriginY:personsView originY:PACE_PERSONSVIEW_BEFORE];
    
    self.checkInPersonHolderView.frame = [self updateHeight:self.checkInPersonHolderView height:PACE_PERSONSVIEW_BEFORE + personsView.frame.size.height + PACE_PERSONSVIEW_BEFORE];
    [self.checkInPersonHolderView addSubview:personsView];
    self.footerView.frame = [self updateHeight:self.footerView height:self.checkInPersonHolderView.frame.origin.y + self.checkInPersonHolderView.frame.size.height];
    self.frame = [self updateHeight:self height:self.footerView.frame.origin.y + self.footerView.frame.size.height];
}

- (void)createRoomInfo:(HotelOrder_Builder *)hotelOrderBuilder
{
    //set rooms
    RoomInfoView *roomInfoView = [RoomInfoView createRoomInfo:hotelOrderBuilder.roomInfosList roomList:hotelOrderBuilder.hotel.roomsList isHidePrice:NO];
    
    self.roomInfoHolderView.frame = [self updateHeight:self.roomInfoHolderView height:roomInfoView.frame.size.height];
    [self.roomInfoHolderView addSubview:roomInfoView];
    self.footerView.frame = [self updateOriginY:self.footerView originY:self.roomInfoHolderView.frame.origin.y + self.roomInfoHolderView.frame.size.height];
    self.frame = [self updateHeight:self height:self.footerView.frame.origin.y + self.footerView.frame.size.height];
}


- (void)setViewWithOrder:(HotelOrder *)hotelOrder
{
    HotelOrder_Builder *builder = [[AirHotelManager defaultManager] hotelOrderBuilder:hotelOrder];
    [self setViewWithOrderBuilder:builder];
    
    self.arrowImageView.hidden = YES;
    self.addCheckInPersonButton.hidden = YES;
}

- (void)setViewWithOrderBuilder:(HotelOrder_Builder *)hotelOrderBuilder
{
    self.hotelNameLabel.text = hotelOrderBuilder.hotel.name;
    
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkInDate];
    NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkOutDate];
    NSString *checkInDateString = dateToStringByFormat(checkInDate, @"yyyy年MM月dd日");
    NSString *checkOutDateString = dateToStringByFormat(checkOutDate, @"MM月dd日");
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", checkInDateString, checkOutDateString];
    
    [self createRoomInfo:hotelOrderBuilder];
    
    if ([[hotelOrderBuilder checkInPersonsList] count] > 0) {
        [self.checkInPersonButton setTitle:@"" forState:UIControlStateNormal];
        [self createCheckInPersonView:hotelOrderBuilder.checkInPersonsList];
    } else {
        [self.checkInPersonButton setTitle:@"一间房一位入住人    添加入住人" forState:UIControlStateNormal];
    }
    
    PPDebug(@"OrderHotelView height:%f", self.frame.size.height);
}

- (void)dealloc {
    [_hotelNameLabel release];
    [_dateLabel release];
    [_roomInfoHolderView release];
    [_checkInPersonHolderView release];
    [_footerView release];
    [_checkInPersonButton release];
    [_arrowImageView release];
    [_addCheckInPersonButton release];
    [super dealloc];
}
@end
