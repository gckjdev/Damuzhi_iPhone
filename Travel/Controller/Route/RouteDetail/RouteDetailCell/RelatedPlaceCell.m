//
//  RelatedPlaceCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RelatedPlaceCell.h"
#import "ImageManager.h"

#define CELL_HEIGHT 25

@interface RelatedPlaceCell ()

@property (retain, nonatomic) PlaceTour *relatedPlace;

@end

@implementation RelatedPlaceCell

@synthesize aDelegate = _aDelegate;
@synthesize relatedPlace = _relatedPlace;

@synthesize relatedPlaceButton;

- (void)dealloc {
    [_relatedPlace release];
    
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
}

- (IBAction)clickPlaceTourButton:(id)sender {
    if ([_aDelegate respondsToSelector:@selector(didSelectedRelatedPlace:)]) {
        [_aDelegate didSelectedRelatedPlace:_relatedPlace];
    }
}

@end
