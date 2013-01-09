//
//  RoomCell.m
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "RoomCell.h"
#import "Place.pb.h"
#import "AppManager.h"
#import "PriceUtils.h"

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

#define HEIGH_TOP       49
#define HEIGH_MIDDLE    40

+ (CGFloat)getCellHeight:(RoomCellSite)roomCellSite;
{
    if (roomCellSite == RoomCellMiddle) {
        return HEIGH_MIDDLE;
    } else {
        return HEIGH_TOP;
    }
}

- (void)updateSite:(RoomCellSite)roomCellSite
{
    UIImage *image = nil;
    self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width , HEIGH_MIDDLE);
    self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, 0, self.holderView.frame.size.width, self.holderView.frame.size.height);
    
    switch (roomCellSite) {
        case RoomCellTop:
            image = [UIImage imageNamed:@"hotel_list_zk1.png"];
            self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y, self.backgroundImageView.frame.size.width , HEIGH_TOP);
            self.holderView.frame = CGRectMake(self.holderView.frame.origin.x, 8, self.holderView.frame.size.width, self.holderView.frame.size.height);
            break;
        case RoomCellMiddle:
            image = [UIImage imageNamed:@"hotel_list_zk2.png"];
            break;
        case RoomCellBottom:
            image = [UIImage imageNamed:@"hotel_list_zk3.png"];
            break;
        default:
            break;
    }
    
    self.backgroundImageView.image = image;
}

- (void)setCellWithRoom:(HotelRoom *)room
                  count:(NSUInteger)count
              indexPath:(NSIndexPath *)aIndexPath
             isSelected:(BOOL)isSelected
           roomCellSite:(RoomCellSite)roomCellSite
{
    self.contentView.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1];
    
    self.roomId = room.roomId;
    self.roomCount = count;
    self.indexPath = aIndexPath;
    
    self.nameLabel.text = room.name;
    self.breakfastLabel.text = [NSString stringWithFormat:@"%@/%@", room.bed, room.breakfast];
    self.selectRoomButton.selected = isSelected;
    
    AppManager *manager = [AppManager defaultManager];
    int currentCiytId = [manager getCurrentCityId];
    NSString *currency = [manager getCurrencySymbol:currentCiytId];
    self.priceLabel.text = [PriceUtils priceToString:room.price currency:currency];
    
    [self updateCountLabel];
    [self updateSite:roomCellSite];
    
    if (self.selectRoomButton.selected) {
        self.plusButton.enabled = YES;
        self.minusButton.enabled = YES;
        self.countLabel.enabled = YES;
    } else {
        self.plusButton.enabled = NO;
        self.minusButton.enabled = NO;
        self.countLabel.enabled = NO;
    }
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
    if (self.selectRoomButton.selected) {
        _roomCount = 1;
    }
    
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
    [_backgroundImageView release];
    [_holderView release];
    [_minusButton release];
    [_plusButton release];
    [_priceLabel release];
    [super dealloc];
}

@end
