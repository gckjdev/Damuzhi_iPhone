//
//  RelatedPlaceCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"
#import "TouristRoute.pb.h"

@protocol RelatedPlaceCellDelegate <NSObject>

@optional
- (void)didSelectedRelatedPlace:(int)placeId;

@end


@interface RelatedPlaceCell : PPTableViewCell

@property (assign, nonatomic) id<RelatedPlaceCellDelegate> aDelegate;

@property (retain, nonatomic) IBOutlet UIButton *relatedPlaceButton;

- (void)setCellData:(PlaceTour *)relatedPlace rowNum:(int)rowNum rowCount:(int)rowCount;

@end
