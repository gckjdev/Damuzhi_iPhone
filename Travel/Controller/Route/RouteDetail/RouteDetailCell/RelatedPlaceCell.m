//
//  RelatedPlaceCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RelatedPlaceCell.h"
#import "ImageManager.h"
#import "PPDebug.h"

#define CELL_HEIGHT 30

@interface RelatedPlaceCell ()

@end

@implementation RelatedPlaceCell

@synthesize aDelegate = _aDelegate;

@synthesize relatedPlaceButton;

- (void)dealloc {
    
    [relatedPlaceButton release];
    
    [super dealloc];
}

+ (NSString*)getCellIdentifier
{
    return @"RelatedPlaceCell";
}

+ (CGFloat)getCellHeight
{
    return CELL_HEIGHT;
}

- (void)setCellData:(PlaceTour *)relatedPlace rowNum:(int)rowNum rowCount:(int)rowCount
{
    [relatedPlaceButton setTitle:relatedPlace.name forState:UIControlStateNormal];
    
    UIImage *image = [[ImageManager defaultManager] tableBgImageWithRowNum:rowNum rowCount:rowCount];
    [relatedPlaceButton setBackgroundImage:image forState:UIControlStateNormal];
    [relatedPlaceButton addTarget:self action:@selector(clickPlaceTourButton:) forControlEvents:UIControlEventTouchUpInside];
    relatedPlaceButton.tag = relatedPlace.placeId;
    
    PPDebug(@"place id: %d", relatedPlace.placeId);
    
}

- (void)clickPlaceTourButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    int placeId = button.tag;
    
    if ([_aDelegate respondsToSelector:@selector(didSelectedRelatedPlace:)]) {
        [_aDelegate didSelectedRelatedPlace:placeId];
    }
}

@end
