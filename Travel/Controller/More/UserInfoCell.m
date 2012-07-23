//
//  UserInfoCell.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoCell.h"
#import "LogUtil.h"

@interface UserInfoCell()

@end

@implementation UserInfoCell
@synthesize backgroundImageVeiw;
@synthesize titleLabel;
@synthesize inputTextField;
@synthesize pointImageView;
@synthesize aDelegate;

- (void)dealloc {
    [titleLabel release];
    [inputTextField release];
    [backgroundImageVeiw release];
    [pointImageView release];
    [super dealloc];
}


#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"UserInfoCell";
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
    if ([aDelegate respondsToSelector:@selector(inputTextFieldDidBeginEditing:)]) {
        [aDelegate inputTextFieldDidBeginEditing:self.indexPath];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([aDelegate respondsToSelector:@selector(inputTextFieldDidEndEditing:)]) {
        [aDelegate inputTextFieldDidEndEditing:self.indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([aDelegate respondsToSelector:@selector(inputTextFieldShouldReturn:)]) {
        [aDelegate inputTextFieldShouldReturn:self.indexPath];
    }
    
    return YES;
}

@end
