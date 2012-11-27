//
//  SignUpController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SignUpController.h"
#import "StringUtil.h"
#import "PPNetworkRequest.h"
#import "VerificationController.h"
#import "FontSize.h"
#import "ImageManager.h"

#define TITLE_SIGN_UP_ID                NSLS(@"用 户 名 :")
#define TITLE_SIGN_UP_PASSWORD          NSLS(@"密     码 :")
#define TITLE_SIGN_UP_PASSWORD_AGAIN    NSLS(@"确认密码:")

#define PLACEHOLDER_SIGN_UP_ID                    NSLS(@"请输入您的手机号码")
#define PLACEHOLDER_SIGN_UP_PASSWORD              NSLS(@"6-16个字符")
#define PLACEHOLDER_SIGN_UP_PASSWORD_AGAIN        NSLS(@"请重复上面的密码")

#define CELL_ROW_SIGN_UP_ID 0
#define CELL_ROW_SIGN_UP_PASSWORD  1
#define CELL_ROW_SIGN_UP_PASSWORD_AGAIN  2

@interface SignUpController ()
@property (retain, nonatomic) NSString *signUpId;
@property (retain, nonatomic) NSString *signUpPassword;
@property (retain, nonatomic) NSString *signUpPasswordAgain;

@property(retain, nonatomic)NSMutableDictionary *titleDic;
@property(retain, nonatomic)NSMutableDictionary *placeHolderDic;
@property(retain, nonatomic)NSMutableDictionary *inputTextFieldDic;
@property (retain, nonatomic) UITextField *currentInputTextField;

@end


@implementation SignUpController
@synthesize titleDic = _titleDic;
@synthesize placeHolderDic = _placeHolderDic;
@synthesize inputTextFieldDic = _inputTextFieldDic;
@synthesize signUpId = _signUpId;
@synthesize signUpPassword = _signUpPassword;
@synthesize signUpPasswordAgain = _signUpPasswordAgain;

@synthesize currentInputTextField = _currentInputTextField;

- (void)dealloc {
    PPRelease(_titleDic);
    PPRelease(_placeHolderDic);
    PPRelease(_inputTextFieldDic);
    PPRelease(_signUpId);
    PPRelease(_signUpPassword);
    PPRelease(_signUpPasswordAgain);
    PPRelease(_currentInputTextField);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"注册") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSignUp:)];
    
    [self setTitle:NSLS(@"注册账号")];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    self.titleDic = [NSMutableDictionary dictionary];
    self.placeHolderDic = [NSMutableDictionary dictionary];
    self.inputTextFieldDic = [NSMutableDictionary dictionary];
    
    [self.titleDic setObject:TITLE_SIGN_UP_ID forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_ID]];
    [self.placeHolderDic setObject:PLACEHOLDER_SIGN_UP_ID forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_ID]];
    
    [self.titleDic setObject:TITLE_SIGN_UP_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD]];
    [self.placeHolderDic setObject:PLACEHOLDER_SIGN_UP_PASSWORD forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD]];
    
    [self.titleDic setObject:TITLE_SIGN_UP_PASSWORD_AGAIN forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD_AGAIN]];
    [self.placeHolderDic setObject:PLACEHOLDER_SIGN_UP_PASSWORD_AGAIN forKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD_AGAIN]];
    
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.dataTableView addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];

    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    
    if (cell == nil) 
    {
        cell = [UserInfoCell createCell:self];
        cell.titleLabel.frame = CGRectOffset(cell.titleLabel.frame, -5, 0);
        cell.inputTextField.frame = CGRectOffset(cell.inputTextField.frame, 5, 0);
        
        switch (indexPath.row) 
        {
            case CELL_ROW_SIGN_UP_ID:
                 cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.inputTextField setSecureTextEntry:NO];
                break;
            case CELL_ROW_SIGN_UP_PASSWORD:
                cell.inputTextField.returnKeyType = UIReturnKeyNext;
                [cell.inputTextField setSecureTextEntry:YES];
                break;
            case CELL_ROW_SIGN_UP_PASSWORD_AGAIN:
                cell.inputTextField.returnKeyType = UIReturnKeyDone;
                [cell.inputTextField setSecureTextEntry:YES];
                break;
            default:
                break;
        }
        
    
    }
    
    cell.aDelegate = self;
    cell.indexPath = indexPath; 
    
    cell.titleLabel.text = [_titleDic objectForKey:[NSNumber numberWithInt:indexPath.row]];
    cell.inputTextField.placeholder = [_placeHolderDic objectForKey:[NSNumber numberWithInt:indexPath.row]];    
    
    return cell;
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)clickSignUp:(id)sender
{
    
    [_currentInputTextField resignFirstResponder];
    
    self.signUpId = [_inputTextFieldDic objectForKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_ID]];
    self.signUpPassword = [_inputTextFieldDic objectForKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD]];
    self.signUpPasswordAgain = [_inputTextFieldDic objectForKey:[NSNumber numberWithInt:CELL_ROW_SIGN_UP_PASSWORD_AGAIN]];
    
    
    if (!NSStringIsValidPhone(_signUpId)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    if (_signUpPassword.length < 6) {
        [self popupMessage:NSLS(@"您输入的密码长度太短") title:nil];
        return;
    }
    
    if (_signUpPassword.length > 16) {
        [self popupMessage:NSLS(@"您输入的密码长度太长") title:nil];
        return;
    }
    
    if (![_signUpPassword isEqualToString:_signUpPasswordAgain]) {
        [self popupMessage:NSLS(@"两次输入密码不一致") title:nil];
        return;
    }
    
    [[UserService defaultService] signUp:_signUpId
                                password:_signUpPassword
                                delegate:self];
    
}

- (IBAction)clickHideKeyboardButton:(id)sender {
    [self popupMessage:@"button clicked" title:nil];
}




- (void)signUpDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，注册失败") title:nil];
        return;
    }
    
    if (result != 0 ) {
        NSString *text = [NSString stringWithFormat:NSLS(@"注册失败: %@"), resultInfo];
        [self popupMessage:text title:nil];
        return;
    }
    
    VerificationController *controller = [[[VerificationController alloc] initWithTelephone:_signUpId] autorelease];
    [self.navigationController pushViewController:controller animated:YES];

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
        [_inputTextFieldDic setObject:cell.inputTextField.text forKey:[NSNumber numberWithInt:indexPath.row]];
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
