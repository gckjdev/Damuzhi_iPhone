//
//  CharacticsCell.h
//  Travel
//
//  Created by 小涛 王 on 12-6-14.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewCell.h"

#define WIDTH_CHARACTICS_LABEL 294
#define FONT_CHARACTICS_LABEL [UIFont systemFontOfSize:13]
#define LINE_BREAK_MODE_CHARACTICS_LABEL UILineBreakModeTailTruncation

@interface CharacticsCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UILabel *characticsLabel;

- (void)setCellData:(NSString *)text;

@end
