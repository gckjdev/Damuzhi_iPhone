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

@implementation ConfirmHotelCell

+(NSString *)getCellIdentifier
{
    return @"ConfirmHotelCell";
}

#define ONE_ROOM_VIEW_HEIGHT  25
#define PERSON_LABEL_HEIGHT     24
#define CONFIRM_HOTEL_CELL_HEIGHT 160

+ (CGFloat)getCellHeight:(NSUInteger)roomInfosCount personCount:(NSUInteger)personCount
{
    NSUInteger temp1 = (roomInfosCount > 0 ? (roomInfosCount - 1) : 0);
    NSUInteger temp2 = (personCount > 0 ? (personCount - 1) : 0);
    
    return CONFIRM_HOTEL_CELL_HEIGHT + temp1 * ONE_ROOM_VIEW_HEIGHT + temp2 * PERSON_LABEL_HEIGHT;
}

- (void)dealloc {
    [_hotelNameLabel release];
    [_dateLabel release];
    [_checkInPersonButton release];
    [_roomInfoHolderView release];
    [_holderView release];
    [_footerView release];
    [_checkInPersonHolderView release];
    [super dealloc];
}

- (UILabel *)createOneLabelInRoomInfo
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 2, 90, 21)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

- (UIView *)createOneRoomView:(NSString *)roomName
                    breakfast:(NSString *)breakfast
                          bed:(NSString *)bed
                        count:(NSUInteger)count
                        price:(NSString *)price
{
    UIView *resultView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ONE_ROOM_VIEW_HEIGHT)] autorelease];
    
    UILabel *roomNameLabel = [self createOneLabelInRoomInfo];
    UILabel *breakfastAndBedLabel = [self createOneLabelInRoomInfo];
    UILabel *countLabel = [self createOneLabelInRoomInfo];
    UILabel *priceLabel = [self createOneLabelInRoomInfo];
    
    roomNameLabel.frame = CGRectMake(13, 2, 100, 21);
    breakfastAndBedLabel.frame = CGRectMake(114, 2, 90, 21);
    countLabel.frame = CGRectMake(205, 2, 32, 21);
    priceLabel.frame = CGRectMake(237, 2, 57, 21);
    
    roomNameLabel.text = roomName;
    breakfastAndBedLabel.text = [NSString stringWithFormat:@"%@/%@", breakfast, bed];
    countLabel.text = [NSString stringWithFormat:@"%d间", count];
    priceLabel.text = price;
    
    countLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textAlignment = NSTextAlignmentRight;
    
    [resultView addSubview:roomNameLabel];
    [resultView addSubview:breakfastAndBedLabel];
    [resultView addSubview:countLabel];
    [resultView addSubview:priceLabel];
    
    return resultView;
}

- (void)createRoomInfo:(HotelOrder_Builder *)hotelOrderBuilder 
{
    for(UIView *subview in [self.roomInfoHolderView subviews]) {
        [subview removeFromSuperview];
    }
    
    int index = 0;
    for (HotelOrderRoomInfo * roomInfo in hotelOrderBuilder.roomInfosList) {
        NSString *roomName = nil;
        NSString *breakfast = nil;
        NSString *bed = nil;
        NSString *price = nil;
        NSUInteger count = roomInfo.count;
        
        for (HotelRoom *room in hotelOrderBuilder.hotel.roomsList) {
            if (roomInfo.roomId == room.roomId) {
                roomName = room.name;
                breakfast = room.breakfast;
                bed = room.bed;
                price = [PriceUtils priceToString:room.price];
            }
        }
        
        UIView *roomView = [self createOneRoomView:roomName
                                         breakfast:breakfast
                                               bed:bed
                                             count:count
                                             price:price];
        roomView.frame = CGRectMake(0, ONE_ROOM_VIEW_HEIGHT * index, roomView.frame.size.width, roomView.frame.size.height);
        [self.roomInfoHolderView addSubview:roomView];
        
        index ++;
    }
    
    if (index > 0) {
        self.footerView.frame = CGRectMake(0, 119 + ONE_ROOM_VIEW_HEIGHT * (index - 1), self.footerView.frame.size.width, self.footerView.frame.size.height);
    }
}

#define PERSON_LABEL_BASIC_X    0
#define PERSON_LABEL_BASIC_Y    0
- (void)createCheckInPersonLabels:(NSArray *)personList
{
    for(UIView *subview in [self.checkInPersonHolderView subviews]) {
        [subview removeFromSuperview];
    }
    int index = 0;
    for (Person *person in personList) {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(PERSON_LABEL_BASIC_X, PERSON_LABEL_BASIC_Y + ( index * PERSON_LABEL_HEIGHT ), 208, PERSON_LABEL_HEIGHT)] autorelease];
        label.textColor = [UIColor colorWithRed:18.0/255.0 green:140.0/255.0 blue:192.0/255.0 alpha:1];
        label.text = [NSString stringWithFormat:@"%@", person.name];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        [self.checkInPersonHolderView addSubview:label];
        
        index ++;
    }
}


- (void)setCellWith:(HotelOrder_Builder *)hotelOrderBuilder indexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    
    self.hotelNameLabel.text = hotelOrderBuilder.hotel.name;
    
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkInDate];
    NSDate *checkOutDate = [NSDate dateWithTimeIntervalSince1970:hotelOrderBuilder.checkOutDate];
    NSString *checkInDateString = dateToStringByFormat(checkInDate, @"yyyy年MM月dd日");
    NSString *checkOutDateString = dateToStringByFormat(checkOutDate, @"MM月dd日");
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", checkInDateString, checkOutDateString];
    
    [self createRoomInfo:hotelOrderBuilder];
    
    if ([[hotelOrderBuilder checkInPersonsList] count] > 0) {
        [self.checkInPersonButton setTitle:@"" forState:UIControlStateNormal];
        [self createCheckInPersonLabels:hotelOrderBuilder.checkInPersonsList];
    } else {
        [self.checkInPersonButton setTitle:@"一间房一位入住人    添加入住人" forState:UIControlStateNormal];
    }
    
    
    
    NSUInteger roomCount = [hotelOrderBuilder.roomInfosList count];
    NSUInteger personCount = [hotelOrderBuilder.checkInPersonsList count];
    NSUInteger temp1 = (roomCount > 0 ? (roomCount - 1) : 0);
    NSUInteger temp2 = (personCount > 0 ? (personCount - 1) : 0);
    
    self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, self.holderView.frame.origin.y, self.holderView.frame.size.width, CONFIRM_HOTEL_CELL_HEIGHT +  temp1 * ONE_ROOM_VIEW_HEIGHT +  temp2 * PERSON_LABEL_HEIGHT);
}

- (IBAction)clickCheckInPersonButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickCheckInPersonButton:)]) {
        [delegate didClickCheckInPersonButton:indexPath];
    }
}

@end
