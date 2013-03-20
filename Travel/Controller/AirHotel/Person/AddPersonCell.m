//
//  AddPersonCell.m
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "AddPersonCell.h"
#import "LogUtil.h"
#import "UIViewUtils.h"

@interface AddPersonCell()
@property (assign, nonatomic) AddPersonCellType type;
@end

@implementation AddPersonCell

- (void)dealloc {
    [_titleLabel release];
    [_inputTextField release];
    [_radio1Title release];
    [_radio2Title release];
    [_radio1Button release];
    [_radio2Button release];
    [_selectButton release];
    [_inputHolderView release];
    [_radioHolderView release];
    [_selectHolderView release];
    [_topLineView release];
    [_inputTipsButton release];
    [super dealloc];
}

+(NSString *)getCellIdentifier
{
    return @"AddPersonCell";
}

+ (CGFloat)getCellHeight
{
    return 44;
}

- (void)updateCellTypeView
{
    self.inputHolderView.hidden = YES;
    self.radioHolderView.hidden = YES;
    self.selectHolderView.hidden = YES;
    
    switch (_type) {
        case TypeInput:
            self.inputHolderView.hidden = NO;
            break;
        case TypeRadio:
            self.radioHolderView.hidden = NO;
            break;
        case TypeSelect:
            self.selectHolderView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setCellWithType:(AddPersonCellType)type
              indexPath:(NSIndexPath *)aIndexPath
                  title:(NSString *)title
              inputText:(NSString *)inputText
       inputPlaceholder:(NSString *)inputPlaceholder
           hasInputTips:(BOOL)hasInputTips
            radio1Title:(NSString *)radio1Title
            radio2Title:(NSString *)radio2Title
         radio1Selected:(BOOL)radio1Selected
         radio2Selected:(BOOL)radio2Selected
      selectButtonTitle:(NSString *)selectButtonTitle
{
    self.type = type;
    [self updateCellTypeView];
    
    self.indexPath = aIndexPath;
    self.titleLabel.text = title;
    
    self.inputTextField.text = inputText;
    self.inputTextField.placeholder = inputPlaceholder;
    
    if (hasInputTips == YES) {
        self.inputTipsButton.hidden = NO;
        [self.inputTextField updateWidth:158];
    } else {
        self.inputTipsButton.hidden = YES;
        [self.inputTextField updateWidth:214];
    }
    
    
    self.radio1Title.text = radio1Title;
    self.radio2Title.text = radio2Title;
    self.radio1Button.selected = radio1Selected;
    self.radio2Button.selected = radio2Selected;
    
    [self.selectButton setTitle:selectButtonTitle forState:UIControlStateNormal];
    
    if (indexPath.row == 0) {
        self.topLineView.hidden = NO;
    } else {
        self.topLineView.hidden = YES;
    }
}

- (void)cancelInput
{
    [self.inputTextField resignFirstResponder];
}

- (IBAction)clickRadio1Button:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickRadio1Button:)]) {
        [delegate didClickRadio1Button:indexPath];
    }
}

- (IBAction)clickRadio2Button:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickRadio2Button:)]) {
        [delegate didClickRadio2Button:indexPath];
    }
}

- (IBAction)clickSelectButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickSelectButton:)]) {
        [delegate didClickSelectButton:indexPath];
    }
}

- (IBAction)clickInputTipsButton:(id)sender {
    if ([delegate respondsToSelector:@selector(didClickInputTipsButton:)]) {
        [delegate didClickInputTipsButton:indexPath];
    }
}

#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([delegate respondsToSelector:@selector(inputTextFieldshouldChange:text:)]) {
        [delegate inputTextFieldshouldChange:indexPath text:textField.text];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(inputTextFieldDidBeginEditing:text:)]) {
        [delegate inputTextFieldDidBeginEditing:indexPath text:textField.text];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([delegate respondsToSelector:@selector(inputTextFieldDidEndEditing:text:)]) {
        [delegate inputTextFieldDidEndEditing:indexPath text:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([delegate respondsToSelector:@selector(inputTextFieldShouldReturn:text:)]) {
        [delegate inputTextFieldShouldReturn:indexPath text:textField.text];
    }
    
    return YES;
}




@end
