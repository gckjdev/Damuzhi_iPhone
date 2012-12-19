//
//  SelectPersonCell.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "SelectPersonCell.h"

@implementation SelectPersonCell

- (void)dealloc {
    [_titleLabel release];
    [_subTitleLabel release];
    [_noteLabel release];
    [super dealloc];
}

+(NSString *)getCellIdentifier
{
    return @"SelectPersonCell";
}

+ (CGFloat)getCellHeight
{
    return 58;
}

- (void)setCellWithTitle:(NSString *)title
                subTitle:(NSString *)subTitle
                    note:(NSString *)note
               indexPath:(NSIndexPath *)aIndexPath
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.noteLabel.text = note;
    self.indexPath = aIndexPath;
}

- (IBAction)clickSelectButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if ([delegate respondsToSelector:@selector(didClickSelectButton:isSelect:)]) {
        [delegate didClickSelectButton:indexPath isSelect:button.selected];
    }
}



@end
