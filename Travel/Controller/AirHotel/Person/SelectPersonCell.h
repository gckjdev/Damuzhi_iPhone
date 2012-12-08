//
//  SelectPersonCell.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "PPTableViewCell.h"

@protocol SelectPersonCellDelegate <NSObject>

@optional
- (void)didClickSelectButton:(NSIndexPath *)indexPath isSelect:(BOOL)isSelect;

@end

@interface SelectPersonCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *noteLabel;

- (void)setCellWithTitle:(NSString *)title
                subTitle:(NSString *)subTitle
                    note:(NSString *)note
               indexPath:(NSIndexPath *)aIndexPath;
@end
