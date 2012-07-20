//
//  CharacticsCell.m
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CharacticsCell.h"

@interface CharacticsCell ()

@end

@implementation CharacticsCell
@synthesize characticsLabel;

+ (NSString *)getCellIdentifier
{
    return @"CharacticsCell";
}

- (void)setCellData:(NSString *)text 
{
    [text stringByReplacingOccurrencesOfString:@"\n" withString:@"\n         "];
    characticsLabel.font = FONT_CHARACTICS_LABEL;
    characticsLabel.lineBreakMode = LINE_BREAK_MODE_CHARACTICS_LABEL;
    characticsLabel.numberOfLines = 0;

    CGSize withinSize = CGSizeMake(WIDTH_CHARACTICS_LABEL, MAXFLOAT);
    CGSize size = [text sizeWithFont:characticsLabel.font constrainedToSize:withinSize lineBreakMode:characticsLabel.lineBreakMode];
    
    characticsLabel.frame = CGRectMake(characticsLabel.frame.origin.x, characticsLabel.frame.origin.y, WIDTH_CHARACTICS_LABEL, size.height);
    characticsLabel.text = text;
}

- (void)dealloc {
    [characticsLabel release];
    [super dealloc];
}
@end
