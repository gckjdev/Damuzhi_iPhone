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
@property (assign, nonatomic) BOOL isAdd;
@property (retain, nonatomic) Person *person;
@property (retain, nonatomic) Person_Builder *personBuilder;
@property (assign, nonatomic) BOOL isMember;
@end

@implementation AddContactPersonController

#define NAME_TEXT_FIELD_TAG     2012122701
#define PHONE_TEXT_FIELD_TAG    2012122702

- (void)dealloc {
    [_person release];
    [_personBuilder release];
    [_nameTextField release];
    [_phoneTextField release];
    [super dealloc];
}

- (id)initWithIsAdd:(BOOL)isAdd person:(Person *)person isMember:(BOOL)isMember
{
    self = [super init];
    if (self) {
        self.isAdd = isAdd;
        self.isMember = isMember;
        self.personBuilder = [[[Person_Builder alloc] init] autorelease];
        
        if (isAdd == NO) {
            self.person = person;
            self.personBuilder.name = person.name;
            self.personBuilder.phone = person.phone;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    if (_isAdd) {
        self.title = NSLS(@"添加联系人");
    } else {
        self.title = NSLS(@"修改联系人");
    }
    
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    self.nameTextField.text = _personBuilder.name;
    self.phoneTextField.text = _personBuilder.phone;
    
    self.nameTextField.tag = NAME_TEXT_FIELD_TAG;
    self.phoneTextField.tag = PHONE_TEXT_FIELD_TAG;
}

- (void)clickFinish:(id)sender
{
    if ([_nameTextField.text length] == 0) {
        [self popupMessage:NSLS(@"请输入姓名") title:nil];
        return;
    }
    
    NSMutableCharacterSet *mutableSet = [NSCharacterSet symbolCharacterSet];
    [mutableSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [mutableSet removeCharactersInString:@"/"];
    if ([_nameTextField.text rangeOfCharacterFromSet:mutableSet].location != NSNotFound) {
        [self popupMessage:NSLS(@"姓名含有非法字符") title:nil];
        return;
    }
    
    NSUInteger phoneLen = [_phoneTextField.text length];
    if (phoneLen != 11) {
        if (phoneLen == 0) {
            [self popupMessage:NSLS(@"请输入联系电话") title:nil];
        } else {
            [self popupMessage:NSLS(@"请输入11位的电话号码") title:nil];
        }
        return;
    }
    
    [_personBuilder setName:_nameTextField.text];
    [_personBuilder setPhone:_phoneTextField.text];
    
    PersonManager *manager = [PersonManager defaultManager:PersonTypeContact isMember:_isMember];
    
    if (self.isAdd == NO) {
        [manager deletePerson:_person];
    }
    Person *person = [_personBuilder build];
    [manager savePerson:person];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhoneTextField:nil];
    [super viewDidUnload];
}
@end
