//
//  PersonalInfoCell.h
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewCell.h"

@protocol PersonalInfoCellDelegate <NSObject>

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath;
- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath;

@end

@interface PersonalInfoCell : PPTableViewCell<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageVeiw;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (assign, nonatomic) id<PersonalInfoCellDelegate> personalInfoCellDelegate;

- (void)setCellIndexPath:(NSIndexPath *)aIndexPath;

@end
