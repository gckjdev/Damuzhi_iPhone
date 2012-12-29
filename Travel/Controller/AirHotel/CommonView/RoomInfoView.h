//
//  RoomInfoView.h
//  Travel
//
//  Created by haodong on 12-12-29.
//
//

#import <UIKit/UIKit.h>

@interface RoomInfoView : UIView

+ (CGFloat)getHeight:(NSArray *)orderRoomInfoList;

+ (RoomInfoView *)createRoomInfo:(NSArray *)orderRoomInfoList
                        roomList:(NSArray *)roomList
                     isHidePrice:(BOOL)isHidePrice;

@end
