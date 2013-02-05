//
//  SelectPersonCell.h
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "PPTableViewCell.h"

typedef enum{
    ViewTypePassenger = 1,
    ViewTypeCheckIn = 2,
    ViewTypeContact = 3,
    ViewTypeCreditCard = 4
} SelectPersonViewType;


@protocol SelectPersonCellDelegate <NSObject>

@optional
- (void)didClickSelectButton:(NSIndexPath *)indexPath;
- (void)didClickEditButton:(NSIndexPath *)indexPath;
- (void)didClickDeleteButton:(NSIndexPath *)indexPath;

@end

@class Person;
@class CreditCard;

@interface SelectPersonCell : PPTableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *noteLabel;
@property (retain, nonatomic) IBOutlet UIButton *selectButton;
@property (retain, nonatomic) IBOutlet UIButton *editButton;
@property (retain, nonatomic) IBOutlet UIImageView *detailImageView;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;

- (void)setCellWithType:(SelectPersonViewType)type
                 person:(Person *)person
             creditCard:(CreditCard *)creditCard
              indexPath:(NSIndexPath *)aIndexPath
             isSelected:(BOOL)isSelected
             isMultiple:(BOOL)isMultiple;

- (void)showDeleteButton;
- (void)showNormalAppearance;

@end
