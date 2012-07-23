//
//  PlaceOrderCell.h
//  Travel
//
//  Created by haodong qiu on 12年7月12日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewCell.h"

@protocol PlaceOrderCellDelegate <NSObject>

@optional
- (void)didClickLeftButton:(NSIndexPath *)aIndexPath;
- (void)didClickRightButton:(NSIndexPath *)aIndexPath;

@end


@interface PlaceOrderCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (retain, nonatomic) IBOutlet UIImageView *pointImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;

- (void)setCellWithIndexPath:(NSIndexPath *)aIndexPath;

@end
