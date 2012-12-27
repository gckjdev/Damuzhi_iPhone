//
//  AddContactPersonController.m
//  Travel
//
//  Created by haodong on 12-12-27.
//
//

#import "AddContactPersonController.h"
#import "FontSize.h"
#import "ImageManager.h"
#import "AirHotel.pb.h"
#import "PersonManager.h"

@interface AddContactPersonController ()

@end

@implementation AddContactPersonController

#define NAME_TEXT_FIELD_TAG     2012122701
#define PHONE_TEXT_FIELD_TAG    2012122702

- (void)dealloc {
    [_nameTextField release];
    [_phoneTextField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    self.title = NSLS(@"添加入住人");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    self.nameTextField.tag = NAME_TEXT_FIELD_TAG;
    self.phoneTextField.tag = PHONE_TEXT_FIELD_TAG;
}

- (void)clickFinish:(id)sender
{
    if ([_nameTextField.text length] == 0) {
        [self popupMessage:NSLS(@"请输入姓名") title:nil];
        return;
    }
    
    if ([_phoneTextField.text length] == 0) {
        [self popupMessage:NSLS(@"请输入联系电话") title:nil];
        return;
    }
    
    Person_Builder *builder = [[[Person_Builder alloc] init] autorelease];
    [builder setName:_nameTextField.text];
    [builder setPhone:_phoneTextField.text];
    Person *person = [builder build];
    [[PersonManager defaultManager:PersonTypeContact] savePerson:person];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhoneTextField:nil];
    [super viewDidUnload];
}
@end
