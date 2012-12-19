//
//  UserInfoController.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserInfoController.h"
#import "UserInfoCell.h"
#import "ImageManager.h"
#import "ChangePasswordController.h"
#import "UserManager.h"
#import "StringUtil.h"
#import "PPNetworkRequest.h"
#import "UIViewUtils.h"
#import "FontSize.h"
enum{
    SECTION_0 = 0,
    SECTION_1 = 1,
};

#define ROW_LOGINID   0
#define ROW_MODIFY_PASSWORD   1

#define ROW_NICKNAME   0
#define ROW_FULLNAME  1
#define ROW_TELEPHONE_OR_EMAIL 2

#define SEPRATOR_STRING @"|"

#define TITLE_LOGINID       NSLS(@"用户名:")
#define TITLE_EMAIL         NSLS(@"邮   箱:|请输入您的邮箱地址")
#define TITLE_TELEPHONE     NSLS(@"手机号码:|请输入您的电话号码")

#define TITLE_MODIFY_PASSWORD NSLS(@"密码修改")

#define TITLE_NICKNAME   NSLS(@"昵   称:|请输入您的昵称")
#define TITLE_FULLNAME   NSLS(@"姓   名:|请输入您的真实姓名")

@interface UserInfoController ()
{
    CGPoint viewCenter;
}

@property (retain, nonatomic) UserInfo *userInfo;

@property (retain, nonatomic) NSMutableDictionary *titleDic;
@property (retain, nonatomic) NSMutableDictionary *inputTextDic;

@property (retain, nonatomic) UITextField *currentInputTextField;

@end

@implementation UserInfoController
@synthesize userInfo = _userInfo;

@synthesize titleDic = _titleDic;
@synthesize inputTextDic = _inputTextDic;

@synthesize currentInputTextField  = _currentInputTextField;

- (void)dealloc
{
    PPRelease(_userInfo);
    PPRelease(_titleDic);
    PPRelease(_inputTextDic);
    PPRelease(_currentInputTextField);

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"个人资料");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickOk:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    
    self.titleDic = [NSMutableDictionary dictionary];
    self.inputTextDic = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *section0TitleDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *section1TitleDic = [NSMutableDictionary dictionary];
    
    [section0TitleDic setObject:TITLE_LOGINID forKey:[NSNumber numberWithInt:ROW_LOGINID]];
    [section0TitleDic setObject:TITLE_MODIFY_PASSWORD forKey:[NSNumber numberWithInt:ROW_MODIFY_PASSWORD]];

    [section1TitleDic setObject:TITLE_NICKNAME forKey:[NSNumber numberWithInt:ROW_NICKNAME]];
    [section1TitleDic setObject:TITLE_FULLNAME forKey:[NSNumber numberWithInt:ROW_FULLNAME]];
    
    if ( [[UserManager defaultManager] loginId]) {
        
        [section1TitleDic setObject:TITLE_EMAIL forKey:[NSNumber numberWithInt:ROW_TELEPHONE_OR_EMAIL]];
    }else{
        [section1TitleDic setObject:TITLE_TELEPHONE forKey:[NSNumber numberWithInt:ROW_TELEPHONE_OR_EMAIL]];
    }
    
    [self.titleDic setObject:section0TitleDic forKey:[NSNumber numberWithInt:0]];
    [self.titleDic setObject:section1TitleDic forKey:[NSNumber numberWithInt:1]];
    
    NSMutableDictionary *section0InputTextDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *section1InputTextDic = [NSMutableDictionary dictionary];
    
    [self.inputTextDic setObject:section0InputTextDic forKey:[NSNumber numberWithInt:0]];
    [self.inputTextDic setObject:section1InputTextDic forKey:[NSNumber numberWithInt:1]];
    
    viewCenter = self.view.center;
    PPDebug(@"center :%f %f",viewCenter.x, viewCenter.y);
    
    // Add a single tap Recognizer
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
    [self.dataTableView addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
    
    [[UserService defaultService] retrieveUserInfo:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_titleDic objectForKey:[NSNumber numberWithInt:section]] count];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserInfoCell getCellHeight];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [UserInfoCell getCellIdentifier];
    UserInfoCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [UserInfoCell createCell:self];
    }
    cell.aDelegate = self;
    cell.indexPath = indexPath;
    
    NSString *title = [[_titleDic objectForKey:[NSNumber numberWithInt:indexPath.section]] objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    NSArray *strArr = [title componentsSeparatedByString:SEPRATOR_STRING];
    
    NSString *inputText = [[_inputTextDic objectForKey:[NSNumber numberWithInt:indexPath.section]] objectForKey:[NSNumber numberWithInt:indexPath.row]];
    
    if ([strArr count] == 1) {
        cell.titleLabel.text = [strArr objectAtIndex:0];
        cell.inputTextField.enabled = NO;
    }
    if ([strArr count] >= 2) {
        cell.titleLabel.text = [strArr objectAtIndex:0];
        cell.inputTextField.placeholder = [strArr objectAtIndex:1];
        cell.inputTextField.returnKeyType = UIReturnKeyNext;
    }
    
    cell.inputTextField.text = inputText;
    
    if ([title isEqualToString:TITLE_MODIFY_PASSWORD]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([title isEqualToString:TITLE_TELEPHONE] || [title isEqualToString:TITLE_EMAIL]) {
        cell.inputTextField.returnKeyType = UIReturnKeyDone;
    }
   
    return cell;
}



//hide the keyboard when "Done" is tapped.
- (void)inputTextFieldShouldReturn:(NSIndexPath *)aIndexPath
{
    UserInfoCell * cell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(aIndexPath.row+1) inSection:aIndexPath.section];
    UserInfoCell * nextCell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:nextIndexPath];

    if (nextCell == nil) {
        [cell.inputTextField resignFirstResponder];
    }else{
        [nextCell.inputTextField becomeFirstResponder];
    }
    
    if (nextCell == nil) {
        [self.view moveTtoCenter:viewCenter needAnimation:YES animationDuration:0.5];
    }
}


- (void)clickOk:(id)sender
{
    [_currentInputTextField resignFirstResponder];
    [self.view moveTtoCenter:viewCenter needAnimation:YES animationDuration:0.5];

    NSString *nickName = [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] objectForKey:[NSNumber numberWithInt:ROW_NICKNAME]];
    NSString *fullName = [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] objectForKey:[NSNumber numberWithInt:ROW_FULLNAME]];
    NSString *telephoneOrEmail = [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] objectForKey:[NSNumber numberWithInt:ROW_TELEPHONE_OR_EMAIL]];
    nickName = [nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
    fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];        
    telephoneOrEmail = [telephoneOrEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
    
    if (telephoneOrEmail != nil && ![telephoneOrEmail isEqualToString:@""]) {
        if (_userInfo.loginType == LoginTypeTelephone && !NSStringIsValidEmail(telephoneOrEmail)) {
            [self popupMessage:@"您输入的邮箱格式不正确，请重新输入" title:nil];
            return;
        }else if(_userInfo.loginType == LoginTypeEmail && !NSStringIsValidPhone(telephoneOrEmail)){
            [self popupMessage:@"您输入的电话号码格式不正确，请重新输入" title:nil];
            return;
        }
    }
    
    [[UserService defaultService] modifyUserFullName:fullName
                                            nickName:nickName
                                              gender:3 
                                           telephone:(_userInfo.loginType == LoginTypeTelephone) ? _userInfo.loginId : telephoneOrEmail
                                               email:(_userInfo.loginType == LoginTypeEmail) ? _userInfo.loginId : telephoneOrEmail
                                             address:nil
                                            delegate:self];
} 

#pragma mark - UserInfoCellDelegate methods
- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath
{
    UserInfoCell *cell = (UserInfoCell *)[self.dataTableView cellForRowAtIndexPath:aIndexPath];
    self.currentInputTextField = cell.inputTextField;

    if (aIndexPath.section >= 1 ) {
        [self.view moveTtoCenter:CGPointMake(viewCenter.x, viewCenter.y - 100) needAnimation:YES animationDuration:0.5];
    }
}


- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath
{
    UserInfoCell * cell = (UserInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    
    NSMutableDictionary *sectionDic = [self.inputTextDic objectForKey:[NSNumber numberWithInt:aIndexPath.section]];
    [sectionDic setObject:cell.inputTextField.text forKey:[NSNumber numberWithInt:aIndexPath.row]];
}



#define HIDE_KEYBOARDBUTTON_TAG 77
#define TOP_HEIGHT 100
- (void)removeHideKeyboardButton
{
    UIButton *button = (UIButton*)[self.view viewWithTag:HIDE_KEYBOARDBUTTON_TAG];
    [button removeFromSuperview];
}

- (void)retrieveUserInfoDidDone:(int)resultCode userInfo:(UserInfo *)userInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"网络不稳定，失败") title:nil];
        return;
    }
    
    self.userInfo = userInfo;

    [[self.inputTextDic objectForKey:[NSNumber numberWithInt:0]] setObject:userInfo.loginId forKey:[NSNumber numberWithInt:ROW_LOGINID]];
    [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] setObject:userInfo.nickName forKey:[NSNumber numberWithInt:ROW_NICKNAME]];
    [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] setObject:userInfo.fullName forKey:[NSNumber numberWithInt:ROW_FULLNAME]];
    
    
    
    NSString *telephoneOrEmail = (userInfo.loginType == LoginTypeTelephone) ? userInfo.email : userInfo.telephone;
    [[self.inputTextDic objectForKey:[NSNumber numberWithInt:1]] setObject:telephoneOrEmail forKey:[NSNumber numberWithInt:ROW_TELEPHONE_OR_EMAIL]];
    
    [dataTableView  reloadData];
}



- (void)modifyPasswordDidDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
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

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer 
{
    CGPoint point = [recognizer locationInView:self.dataTableView];
    NSIndexPath *index = [self.dataTableView indexPathForRowAtPoint:point];
    NSString *title = [[_titleDic objectForKey:[NSNumber numberWithInt:index.section]] objectForKey:[NSNumber numberWithInt:index.row]];
    if ([title isEqualToString:TITLE_MODIFY_PASSWORD]) 
    {
        ChangePasswordController *contrller = [[ChangePasswordController alloc] init];
        [self.navigationController pushViewController:contrller animated:YES];
        [contrller release];
    }
    
    [_currentInputTextField resignFirstResponder];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    //[self.view moveTtoCenter:viewCenter needAnimation:YES animationDuration:0.5];
}


@end
