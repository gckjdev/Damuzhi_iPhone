//
//  ChangePasswordController.m
//  Travel
//
//  Created by haodong qiu on 12年7月5日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ChangePasswordController.h"
#import "PPDebug.h"
#import "PPViewController.h"
#import "PPTableViewController.h"
#import "PPNetworkRequest.h"

//#import "UserService.h"
#define ROWS_COUNT 3

#define TITLE_OLD_PASSWORD          NSLS(@"原  密  码:")
#define TITLE_NEW_PASSWORD          NSLS(@"新  密  码:")
#define TITLE_NEW_PASSWORD_AGAIN    NSLS(@"确认密码:")

#define PLACEHOLDER_1               NSLS(@"请输入旧密码")
#define PLACEHOLDER_2               NSLS(@"请输入新密码")
#define PLACEHOLDER_3               NSLS(@"请再次输入新密码")

@interface ChangePasswordController ()
{
    UITextField *_currentInputTextField;
}
@property (retain, nonatomic) NSString *oldPassword;
@property (retain, nonatomic) NSString *lastPassword;
@property (retain, nonatomic) NSString *lastPasswordAgain;

@end


@implementation ChangePasswordController
@synthesize oldPassword;
@synthesize lastPassword;
@synthesize lastPasswordAgain;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"修改密码");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ROWS_COUNT;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonalInfoCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [PersonalInfoCell getCellIdentifier];
    PersonalInfoCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [PersonalInfoCell createCell:self];
        cell.titleLabel.frame = CGRectOffset(cell.titleLabel.frame, -5, 0);
        cell.inputTextField.frame = CGRectOffset(cell.inputTextField.frame, 5, 0);
    }
    [cell setPersonalInfoCellDelegate:self];
    [cell setCellIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = TITLE_OLD_PASSWORD;
        cell.inputTextField.placeholder = PLACEHOLDER_1;
        
    } else if (indexPath.row == 1){
        cell.titleLabel.text = TITLE_NEW_PASSWORD;
        cell.inputTextField.placeholder = PLACEHOLDER_2;
    
    } else if (indexPath.row == 2){
        cell.titleLabel.text = TITLE_NEW_PASSWORD_AGAIN;
        cell.inputTextField.placeholder = PLACEHOLDER_3;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)clickSubmit:(id)sender
{
    [_currentInputTextField resignFirstResponder];

    if (oldPassword.length < 6 || oldPassword.length > 16) {
        [self popupMessage:NSLS(@"您输入的原密码长度不对") title:nil];
        return;
    }
    
    if (lastPassword.length < 6 || lastPassword.length > 16) {
        [self popupMessage:NSLS(@"您输入的新密码长度不对") title:nil];
        return;
    }
    
    if (![lastPassword isEqualToString:lastPasswordAgain]) {
        [self popupMessage:NSLS(@"您两次输入的密码不一致") title:nil];
        return;
    }
    
    [[UserService defaultService] modifyPassword:oldPassword
                                newPassword:lastPassword
                                    delegate:self];
    
}


-(void) modifyPasswordDidDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，修改失败") title:nil];
        return;
    }
    
    if (result != 0) {
        [self popupMessage:resultInfo title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"修改成功") title:nil];
}

#pragma mark - PersonalInfoCellDelegate methods
- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath
{
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;

}


- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath
{
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;
    if (aIndexPath.row == 0)
    {
        oldPassword = _currentInputTextField.text;
    }    
    else if(aIndexPath.row == 1)
    {
        lastPassword = _currentInputTextField.text;
    }
    else if (aIndexPath.row == 2)
    {
        lastPasswordAgain = _currentInputTextField.text;
    }
    

    
}



@end
