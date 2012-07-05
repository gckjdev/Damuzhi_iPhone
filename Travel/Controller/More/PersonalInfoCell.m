//
//  PersonalInfoCell.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoCell.h"

@interface PersonalInfoCell()

@property (retain, nonatomic) NSIndexPath *indexPath;

@end

@implementation PersonalInfoCell
@synthesize backgroundImageVeiw;
@synthesize titleLabel;
@synthesize inputTextField;
@synthesize indexPath = _indexPath;
@synthesize personalInfoCellDelegate;

- (void)dealloc {
    [_indexPath release];
    [titleLabel release];
    [inputTextField release];
    [backgroundImageVeiw release];
    [super dealloc];
}


#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"PersonalInfoCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)setCellIndexPath:(NSIndexPath *)aIndexPath
{
    self.indexPath = aIndexPath;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (personalInfoCellDelegate && [personalInfoCellDelegate respondsToSelector:@selector(inputTextFieldDidBeginEditing:)]) {
        [personalInfoCellDelegate inputTextFieldDidBeginEditing:_indexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (personalInfoCellDelegate && [personalInfoCellDelegate respondsToSelector:@selector(inputTextFieldDidEndEditing:)]) {
        [personalInfoCellDelegate inputTextFieldDidEndEditing:_indexPath];
    }
}

@end
