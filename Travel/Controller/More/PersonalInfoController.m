//
//  PersonalInfoController.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoController.h"
#import "PersonalInfoCell.h"

enum{
    SECTION_0 = 0,
    SECTION_1 = 1,
    SECTION_COUNT = 2
};

#define ROWS_SECTION_0  2
#define ROWS_SECTION_1  2

#define TITLE_SECTION_0_ROW_0   NSLS(@"用户名:")
#define TITLE_SECTION_0_ROW_1   NSLS(@"昵    称:")

#define TITLE_SECTION_1_ROW_0   NSLS(@"密码修改")
#define TITLE_SECTION_1_ROW_1   NSLS(@"资料修改")

@interface PersonalInfoController ()
{
    UITextField *_currentInputTextField;
}
@property (retain ,nonatomic) NSString *userName;
@property (retain ,nonatomic) NSString *nickName;

- (void)removeHideKeyboardButton;
- (void)addHideKeyboardButton;
- (void)clickHideKeyboardButton:(id)sender;

@end


@implementation PersonalInfoController
@synthesize userName = _userName;
@synthesize nickName = _nickName;

- (void)dealloc
{
    PPRelease(_userName);
    PPRelease(_nickName);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"个人资料");
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickOK:)];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:222.0/255.0 green:239.0/255.0 blue:248.0/255.0 alpha:1]];
    
//    UITapGestureRecognizer* singleTapRecognizer;
//    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
//    singleTapRecognizer.numberOfTapsRequired = 1; // For single tap
//    [self.dataTableView addGestureRecognizer:singleTapRecognizer];
//    [singleTapRecognizer release];
}

//- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
//    [_currentInputTextField resignFirstResponder];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_0:
            return ROWS_SECTION_0;
            break;
        case SECTION_1:
            return ROWS_SECTION_1;
            break;
        default:
            break;
    }
    return 0;
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
    }
    [cell setPersonalInfoCellDelegate:self];
    [cell setCellIndexPath:indexPath];
    
    cell.inputTextField.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == SECTION_0) {
        if (indexPath.row == 0) {
            cell.inputTextField.hidden = NO;
            cell.inputTextField.placeholder = NSLS(@"请输入用户名");
            cell.titleLabel.text = TITLE_SECTION_0_ROW_0;
        } else if (indexPath.row == 1) {
            cell.inputTextField.hidden = NO;
            cell.inputTextField.placeholder = NSLS(@"请输入昵称");
            cell.titleLabel.text = TITLE_SECTION_0_ROW_1;
        }
        
    } else if (indexPath.section == SECTION_1) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = TITLE_SECTION_1_ROW_0;
        } else if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = TITLE_SECTION_1_ROW_1;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)clickOK:(id)sender
{
    
}

#pragma mark - PersonalInfoCellDelegate methods
- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)aIndexPath
{
    [self addHideKeyboardButton];
    
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;
}


- (void)inputTextFieldDidEndEditing:(NSIndexPath *)aIndexPath
{
    PersonalInfoCell * cell = (PersonalInfoCell*)[dataTableView cellForRowAtIndexPath:aIndexPath];
    _currentInputTextField = cell.inputTextField;
}

#define HIDE_KEYBOARDBUTTON_TAG 77
#define TOP_HEIGHT 100
- (void)removeHideKeyboardButton
{
    UIButton *button = (UIButton*)[self.view viewWithTag:HIDE_KEYBOARDBUTTON_TAG];
    [button removeFromSuperview];
}

- (void)addHideKeyboardButton
{
    [self removeHideKeyboardButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-TOP_HEIGHT)];
    button.tag = HIDE_KEYBOARDBUTTON_TAG;
    [button addTarget:self action:@selector(clickHideKeyboardButton:) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:button];
    [button release];
}

- (void)clickHideKeyboardButton:(id)sender
{
    [_currentInputTextField resignFirstResponder];
    [self removeHideKeyboardButton];
}


@end
