//
//  RoomCell.m
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "RoomCell.h"
#import "Place.pb.h"


@interface RoomCell()

@property (assign, nonatomic) int roomId;
@property (assign, nonatomic) NSUInteger roomCount;

@end

@implementation RoomCell
@synthesize roomCount = _roomCount;
@synthesize roomId = _roomId;

+ (id)createCell:(id)delegate
{
    RoomCell *roomCell = [super createCell:delegate];
    return roomCell;
}


+ (NSString*)getCellIdentifier
{
    return @"RoomCell";
}

+ (CGFloat)getCellHeight
{
    return 42.0f;
}

- (void)setCellWithRoom:(HotelRoom *)room count:(NSUInteger)count indexPath:(NSIndexPath *)aIndexPath isSelected:(BOOL)isSelected
{
    self.roomId = room.roomId;
    self.roomCount = count;
    self.indexPath = aIndexPath;
    
    self.nameLabel.text = room.name;
    self.breakfastLabel.text = room.breakfast;
    self.selectRoomButton.selected = isSelected;
    
    [self updateCountLabel];
}

- (void)updateCountLabel
{
    self.countLabel.text = [NSString stringWithFormat:@"%d", _roomCount];
}

- (void)minus
{
    if (_roomCount <= 1) {
        return;
    }
    _roomCount -- ;
    [self updateCountLabel];
}

- (void)plus
{
    _roomCount ++ ;
    [self updateCountLabel];
}


- (IBAction)clickSelectRoomButton:(id)sender {
    self.selectRoomButton.selected = !self.selectRoomButton.selected;
    
    if ([delegate respondsToSelector:@selector(didClickSelectRoomButton:isSelected:count:indexPath:)]) {
        [delegate didClickSelectRoomButton:_roomId isSelected:self.selectRoomButton.selected count:_roomCount indexPath:indexPath];
    }
}

- (IBAction)clickMinusButton:(id)sender {
    [self minus];
    
    if ([delegate respondsToSelector:@selector(didClickMinusButton:count:indexPath:)]) {
        [delegate didClickMinusButton:_roomId count:_roomCount indexPath:indexPath];
    }
}

- (IBAction)clickPlusButton:(id)sender {
    [self plus];
    
    if ([delegate respondsToSelector:@selector(didClickPlusButton:count:indexPath:)]) {
        [delegate didClickPlusButton:_roomId count:_roomCount indexPath:indexPath];
    }
}

- (void)dealloc {
    [_nameLabel release];
    [_breakfastLabel release];
    [_countLabel release];
    [_selectRoomButton release];
    [super dealloc];
}

@end
