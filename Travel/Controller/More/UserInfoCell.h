//
//  UserInfoCell.h
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewCell.h"

@protocol UserInfoCellDelegate <NSObject>

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath;
- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath;
- (void)inputTextFieldShouldReturn:(NSIndexPath *)aIndexPath;

@end

@interface UserInfoCell : PPTableViewCell <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageVeiw;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) IBOutlet UIImageView *pointImageView;

@property (assign, nonatomic) id<UserInfoCellDelegate> aDelegate;

- (void)setCellIndexPath:(NSIndexPath *)aIndexPath;

@end
    