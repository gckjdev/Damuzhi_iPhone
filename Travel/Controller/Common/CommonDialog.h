//
//  CommonDialog.h
//  Travel
//
//  Created by haodong on 12-10-15.
//
//

#import <UIKit/UIKit.h>

@protocol CommonDialogDelegate <NSObject>

@optional
- (void)didClickOkButton;
- (void)didClickCancelButton;

@end


@interface CommonDialog : UIView

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet UIButton *OKButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;


+ (CommonDialog *)createDialogWithTitle:(NSString *)title
                                message:(NSString *)message
                               delegate:(id<CommonDialogDelegate>)aDelegate;

- (void)showInView:(UIView*)view;

@end
