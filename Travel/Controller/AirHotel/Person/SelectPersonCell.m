//
//  SelectPersonCell.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "SelectPersonCell.h"
#import "AirHotel.pb.h"
#import "AppManager.h"

@implementation SelectPersonCell

- (void)dealloc {
    [_titleLabel release];
    [_subTitleLabel release];
    [_noteLabel release];
    [_selectButton release];
    [_editButton release];
    [_detailImageView release];
    [_deleteButton release];
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

- (void)showDeleteButton
{
    self.deleteButton.hidden = NO;
    self.detailImageView.hidden = YES;
}

- (void)showNormalAppearance
{
    self.deleteButton.hidden = YES;
    self.detailImageView.hidden = NO;
}

- (void)setCellWithType:(SelectPersonViewType)type
                 person:(Person *)person
             creditCard:(CreditCard *)creditCard
              indexPath:(NSIndexPath *)aIndexPath
             isSelected:(BOOL)isSelected
             isMultiple:(BOOL)isMultiple
{
    switch (type) {
        case ViewTypePassenger:
        {
            self.titleLabel.text = person.name;
            NSString *ageType = nil;
            if ([person hasAgeType]) {
                ageType = (person.ageType == PersonAgeTypePersonAgeChild ? @"儿童" : @"成人");
            }
            self.noteLabel.text = ageType;
            if ([person hasCardNumber] && person.cardNumber != nil && [person.cardNumber length] != 0) {
                self.subTitleLabel.text = [NSString stringWithFormat:@"%@/%@",[[AppManager defaultManager] getCardName:person.cardTypeId], person.cardNumber];
            } else {
                self.subTitleLabel.text = [[AppManager defaultManager] getCardName:person.cardTypeId];
            }
            break;
        }
            
        case ViewTypeCheckIn:
        {
            self.titleLabel.text = [NSString stringWithFormat:@"中文名：%@",person.name];
            self.noteLabel.text = nil;
            self.subTitleLabel.text = [NSString stringWithFormat:@"英文名：%@",person.nameEnglish];
            break;
        }
            
        case ViewTypeContact:
        {
            self.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",person.name];
            self.noteLabel.text = nil;
            self.subTitleLabel.text = [NSString stringWithFormat:@"电话：%@",person.phone];
            break;
        }
            
        case ViewTypeCreditCard:
        {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",creditCard.name];
            self.noteLabel.text = [[AppManager defaultManager] getBankName:creditCard.bankId];
            self.subTitleLabel.text = [NSString stringWithFormat:@"卡号：%@",creditCard.number];
            break;
            break;
        }
            
            
        default:
            break;
    }

    self.indexPath = aIndexPath;
    
    if (isMultiple) {
        [self.selectButton setImage:[UIImage imageNamed:@"no_s.png"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"yes_s.png"] forState:UIControlStateSelected];
        [self.selectButton setContentEdgeInsets:UIEdgeInsetsMake(11, 10, 11, 213)];
    } else {
        [self.selectButton setImage:[UIImage imageNamed:@"select_radio_off.png"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"select_radio_on.png"] forState:UIControlStateSelected];
        [self.selectButton setContentEdgeInsets:UIEdgeInsetsMake(18, 13, 18, 215)];
    }
    
    self.selectButton.selected = isSelected;
}

- (IBAction)clickSelectButton:(id)sender {    
    if ([delegate respondsToSelector:@selector(didClickSelectButton:)]) {
        [delegate didClickSelectButton:indexPath];
    }
}

- (IBAction)clickEditButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickEditButton:)]) {
        [delegate didClickEditButton:indexPath];
    }
}

- (IBAction)clickDeleteButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
        [delegate didClickDeleteButton:indexPath];
    }
}

@end
