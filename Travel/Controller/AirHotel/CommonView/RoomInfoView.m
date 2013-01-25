//
//  RoomInfoView.m
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import "RoomInfoView.h"
#import "AirHotel.pb.h"
#import "PriceUtils.h"
#import "AppManager.h"

@implementation RoomInfoView

#define WIDTH_ROOMINFOVIEW      300
#define HEIGHT_ONE_ROOM_VIEW    25

+ (CGFloat)getHeight:(NSArray *)orderRoomInfoList
{
    if ([orderRoomInfoList count] > 0) {
        return [orderRoomInfoList count] * HEIGHT_ONE_ROOM_VIEW;
    }
    
    return HEIGHT_ONE_ROOM_VIEW;
}

+ (UILabel *)createOneLabelInRoomInfo
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 9, 90, HEIGHT_ONE_ROOM_VIEW)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

+ (UIView *)createOneRoomView:(NSString *)roomName
                    breakfast:(NSString *)breakfast
                          bed:(NSString *)bed
                        count:(NSUInteger)count
                        price:(NSString *)price
{
    UIView *resultView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_ONE_ROOM_VIEW)] autorelease];
    
    UILabel *roomNameLabel = [self createOneLabelInRoomInfo];
    UILabel *breakfastAndBedLabel = [self createOneLabelInRoomInfo];
    UILabel *countLabel = [self createOneLabelInRoomInfo];
    UILabel *priceLabel = [self createOneLabelInRoomInfo];
    
    roomNameLabel.frame = CGRectMake(13, 0, 100, HEIGHT_ONE_ROOM_VIEW);
    breakfastAndBedLabel.frame = CGRectMake(114, 0, 90, HEIGHT_ONE_ROOM_VIEW);
    countLabel.frame = CGRectMake(205, 0, 32, HEIGHT_ONE_ROOM_VIEW);
    priceLabel.frame = CGRectMake(237, 0, 57, HEIGHT_ONE_ROOM_VIEW);
    
    if (breakfast == nil) {
        breakfast = @"";
    }
    
    if (bed == nil) {
        bed = @"";
    }
    
    roomNameLabel.text = roomName;
    breakfastAndBedLabel.text = [NSString stringWithFormat:@"%@/%@", breakfast, bed];
    countLabel.text = [NSString stringWithFormat:@"%d间", count];
    priceLabel.text = price;
    
    countLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:72.0/255.0 blue:0.0/255.0 alpha:1];
    
    [resultView addSubview:roomNameLabel];
    [resultView addSubview:breakfastAndBedLabel];
    [resultView addSubview:countLabel];
    [resultView addSubview:priceLabel];
    
    return resultView;
}

+ (RoomInfoView *)createRoomInfo:(NSArray *)orderRoomInfoList
                        roomList:(NSArray *)roomList
                     isHidePrice:(BOOL)isHidePrice
{
    RoomInfoView *returnRoomInfoView = [[[RoomInfoView alloc] init] autorelease];
    returnRoomInfoView.backgroundColor = [UIColor clearColor];
    
    int index = 0;
    for (HotelOrderRoomInfo * roomInfo in orderRoomInfoList) {
        NSString *roomName = nil;
        NSString *breakfast = nil;
        NSString *bed = nil;
        NSString *price = nil;
        NSUInteger count = roomInfo.count;
        
        for (HotelRoom *room in roomList) {
            if (roomInfo.roomId == room.roomId) {
                roomName = room.name;
                breakfast = room.breakfast;
                bed = room.bed;
                price = [PriceUtils priceToStringCNY:room.price];
            }
        }
        
        if (isHidePrice) {
            price = nil;
        }
        
        UIView *roomView = [self createOneRoomView:roomName
                                         breakfast:breakfast
                                               bed:bed
                                             count:count
                                             price:price];
        roomView.frame = CGRectMake(0, HEIGHT_ONE_ROOM_VIEW * index, roomView.frame.size.width, roomView.frame.size.height);
        [returnRoomInfoView addSubview:roomView];
        index ++;
    }
    if (index == 0) {
        index = 1;
    }
    
    returnRoomInfoView.frame = CGRectMake(0, 0, WIDTH_ROOMINFOVIEW, HEIGHT_ONE_ROOM_VIEW * index);
    
    return returnRoomInfoView;
}

@end
