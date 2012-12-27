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
    [_selectButton release];
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
              isSelected:(BOOL)isSelected
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    self.noteLabel.text = note;
    self.indexPath = aIndexPath;
    
    self.selectButton.selected = isSelected;
}

- (IBAction)clickSelectButton:(id)sender {    
    if ([delegate respondsToSelector:@selector(didClickSelectButton:)]) {
        [delegate didClickSelectButton:indexPath];
    }
}



@end
