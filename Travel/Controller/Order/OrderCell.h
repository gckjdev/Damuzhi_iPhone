//
//  OrderCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TouristRoute.pb.h"

@interface OrderCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *routeIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *departCityLabel;
@property (retain, nonatomic) IBOutlet UILabel *departDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *bookingDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *personCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderStatusLabel;


- (void)setCellData:(Order *)order;

@end
