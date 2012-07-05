//
//  RouteFeekbackCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "Package.pb.h"

@interface RouteFeekbackCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;

- (void)setCellData:(RouteFeekback *)routeFeekback;


@property (retain, nonatomic) IBOutlet UIImageView *displayRankImage1;

@property (retain, nonatomic) IBOutlet UIImageView *displayRankImage2;

@property (retain, nonatomic) IBOutlet UIImageView *displayRankImage3;

@end
