//
//  RouteListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-4.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "TouristRoute.pb.h"
#import "HJManagedImageV.h"

@interface RouteListCell : PPTableViewCell <HJManagedImageVDelegate>

@property (retain, nonatomic) IBOutlet HJManagedImageV *thumbImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *tourLabel;
@property (retain, nonatomic) IBOutlet UIView *rankHolderView;
@property (retain, nonatomic) IBOutlet UILabel *daysLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellData:(TouristRoute*)route;

@end
