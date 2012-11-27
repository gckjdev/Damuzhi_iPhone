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
#import "PPNetworkRequest.h"
#import "FontSize.h"
#import "ImageManager.h"

#define TITLE_OLD_PASSWORD          NSLS(@"原  密  码:")
#define TITLE_NEW_PASSWORD          NSLS(@"新  密  码:")
#define TITLE_NEW_PASSWORD_AGAIN    NSLS(@"确认密码:")

#define PLACEHOLDER_OLD_PASSWORD               NSLS(@"请输入旧密码")
#define PLACEHOLDER_NEW_PASSWORD               NSLS(@"请输入新密码")
#define PLACEHOLDER_NEW_PASSWORD_AGAIN         NSLS(@"请再次输入新密码")

#define CELL_ROW_OLD_PASSWORD 0
#define CELL_ROW_NEW_PASSWORD  1
#define CELL_ROW_NEW_PASSWORD_AGAIN  2




@interface ChangePasswordController ()

@property (retain, nonatomic) NSString *oldPassword;
@property (retain, nonatomic) NSString *lastPassword;
@property (retain, nonatomic) NSString *lastPasswordAgain;

@property (retain, nonatomic) NSMutableDictionary *titleDic;
@property (retain, nonatomic) NSMutableDictionary *placeHolderDic;
@property (retain, nonatomic) NSMutableDictionary *passwordDic;

@property (retain, nonatomic) UITextField *currentInputTextField;

@end


@implementation ChangePasswordController
@synthesize oldPassword;
@synthesize lastPassword;
@synthesize lastPasswordAgain;

@synthesize titleDic = _titleDic;
@synthesize placeHolderDic = _placeHolderDic;
@synthesize passwordDic = _passwordDic;

@synthesize currentInputTextField = _currentInputTextField;

- (void)dealloc
{
    [_titleDic release];
    [_placeHolderDic release];
    [_passwordDic release];
    [oldPassword release];
    [lastPassword release];
    [lastPasswordAgain release];
    [_currentInputTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"修改密码");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    self.titleDic = [NSMutableDictionary dictionary];
    self.placeHolderDic = [NSMutableDictionary dictionary];
    self.passwordDic = [NSMutableDictionary dictionary];
    
    [self.titleDic setObject:TITLE_OLD_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_OLD_PASSWORD]];
    [self.placeHolderDic setObject:PLACEHOLDER_OLD_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_OLD_PASSWORD]];

    [self.titleDic setObject:TITLE_NEW_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD]];
    [self.placeHolderDic setObject:PLACEHOLDER_NEW_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD]];

    [self.titleDic setObject:TITLE_NEW_PASSWORD_AGAIN forKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD_AGAIN]];
    [self.placeHolderDic setObject:PLACEHOLDER_NEW_PASSWORD_AGAIN forKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD_AGAIN]];
    
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.dataTableView addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleDic count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserInfoCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [UserInfoCell getCellIdentifier];
    UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [UserInfoCell createCell:self];
        cell.titleLabel.frame = CGRectOffset(cell.titleLabel.frame, -5, 0);
        cell.inputTextField.frame = CGRectOffset(cell.inputTextField.frame, 5, 0);
        cell.inputTextField.returnKeyType = (indexPath.row == CELL_ROW_NEW_PASSWORD_AGAIN) ? UIReturnKeyDone : UIReturnKeyNext;
        [cell.inputTextField setSecureTextEntry:YES];
    }
    
    cell.aDelegate = self;
    cell.indexPath = indexPath; 
    
    cell.titleLabel.text = [_titleDic objectForKey:[NSNumber numberWithInt:indexPath.row]];
    cell.inputTextField.placeholder = [_placeHolderDic objectForKey:[NSNumber numberWithInt:indexPath.row]];    
        
    return cell;
}

- (void)clickSubmit:(id)sender
{
    [_currentInputTextField resignFirstResponder];
    
    self.oldPassword = [_passwordDic objectForKey:[NSNumber numberWithInt:CELL_ROW_OLD_PASSWORD]];
    self.lastPassword = [_passwordDic objectForKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD]];
    self.lastPasswordAgain = [_passwordDic objectForKey:[NSNumber numberWithInt:CELL_ROW_NEW_PASSWORD_AGAIN]];

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)indexPath
{
    UserInfoCell * cell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        self.currentInputTextField = cell.inputTextField;
    }
}

- (void)inputTextFieldDidEndEditing:(NSIndexPath *)indexPath
{
    UserInfoCell * cell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        [_passwordDic setObject:cell.inputTextField.text forKey:[NSNumber numberWithInt:indexPath.row]];
    }
}

- (void)inputTextFieldShouldReturn:(NSIndexPath *)indexPath
{
    UserInfoCell * cell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    UserInfoCell * nextCell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:nextIndexPath];

    if (nextCell == nil) {
        [cell.inputTextField resignFirstResponder];
    }else{
        [nextCell.inputTextField becomeFirstResponder];
    }
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer 
{
    [_currentInputTextField resignFirstResponder];
}


@end
