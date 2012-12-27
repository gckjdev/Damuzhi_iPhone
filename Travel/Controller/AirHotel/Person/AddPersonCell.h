//
//  AddPersonCell.h
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "PPTableViewCell.h"

@protocol AddPersonCellDelegate <NSObject>
@optional
- (void)didClickRadio1Button:(NSIndexPath *)indexPath;
- (void)didClickRadio2Button:(NSIndexPath *)indexPath;
- (void)didClickSelectButton:(NSIndexPath *)indexPath;
- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)indexPath text:(NSString *)text;
- (void)inputTextFieldDidEndEditing:(NSIndexPath *)indexPath text:(NSString *)text;
- (void)inputTextFieldShouldReturn:(NSIndexPath *)indexPath text:(NSString *)text;
@end


typedef enum{
    TypeInput = 1,
    TypeRadio = 2,
    TypeSelect = 3,
} AddPersonCellType;


@interface AddPersonCell : PPTableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIView *inputHolderView;
@property (retain, nonatomic) IBOutlet UIView *radioHolderView;
@property (retain, nonatomic) IBOutlet UIView *selectHolderView;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextField;
@property (retain, nonatomic) IBOutlet UILabel *radio1Title;
@property (retain, nonatomic) IBOutlet UILabel *radio2Title;
@property (retain, nonatomic) IBOutlet UIButton *radio1Button;
@property (retain, nonatomic) IBOutlet UIButton *radio2Button;
@property (retain, nonatomic) IBOutlet UIButton *selectButton;
@property (retain, nonatomic) IBOutlet UIView *topLineView;

- (void)setCellWithType:(AddPersonCellType)type
              indexPath:(NSIndexPath *)aIndexPath
                  title:(NSString *)title
              inputText:(NSString *)inputText
       inputPlaceholder:(NSString *)inputPlaceholder
            radio1Title:(NSString *)radio1Title
            radio2Title:(NSString *)radio2Title
         radio1Selected:(BOOL)radio1Selected
         radio2Selected:(BOOL)radio2Selected
      selectButtonTitle:(NSString *)selectButtonTitle;

@end
