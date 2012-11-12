//
//  CommonDialog.m
//  Travel
//
//  Created by haodong on 12-10-15.
//
//

#import "CommonDialog.h"

@interface CommonDialog()
@property (assign, nonatomic) id<CommonDialogDelegate> delegate;
@end

@implementation CommonDialog
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize contentTextView = _contentTextView;
@synthesize OKButton = _OKButton;
@synthesize cancelButton = _cancelButton;
@synthesize delegate = _delegate;

+ (CommonDialog *)createDialogWithTitle:(NSString *)title
                               subTitle:(NSString *)subTitle
                                content:(NSString *)content
                          OKButtonTitle:(NSString *)OKButtonTitle
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                               delegate:(id<CommonDialogDelegate>)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommonDialog" owner:self options:nil];
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create CommonDialog but cannot find object from Nib");
        return nil;
    }
    
    CommonDialog *commonDialog = (CommonDialog*)[topLevelObjects objectAtIndex:0];
    
    commonDialog.titleLabel.text = title;
    commonDialog.subTitleLabel.text = subTitle;
    commonDialog.contentTextView.text = content;
    [commonDialog.OKButton setTitle:OKButtonTitle forState:UIControlStateNormal];
    [commonDialog.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    
    commonDialog.delegate = delegate;
    
    return commonDialog;
}

- (void)showInView:(UIView*)view
{
    self.frame = view.frame;
    [view addSubview:self];
}

- (IBAction)clickOKButton:(id)sender
{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(didClickOkButton)]) {
        [_delegate didClickOkButton];
    }
}

- (IBAction)clickCancelButton:(id)sender
{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(didClickCancelButton)]) {
        [_delegate didClickCancelButton];
    }
}

- (void)dealloc {
    [_titleLabel release];
    [_subTitleLabel release];
    [_contentTextView release];
    [_OKButton release];
    [_cancelButton release];
    [super dealloc];
}
@end
