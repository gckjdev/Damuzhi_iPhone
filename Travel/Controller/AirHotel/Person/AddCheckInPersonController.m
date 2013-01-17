//
//  AddCheckInPersonController.m
//  Travel
//
//  Created by haodong on 12-12-24.
//
//

#import "AddCheckInPersonController.h"
#import "FontSize.h"
#import "ImageManager.h"
#import "PersonManager.h"
#import "AirHotel.pb.h"

@interface AddCheckInPersonController ()
@property (assign, nonatomic) BOOL isAdd;
@property (retain, nonatomic) Person *person;
@property (retain, nonatomic) Person_Builder *personBuilder;
@property (assign, nonatomic) BOOL isMember;
@end

@implementation AddCheckInPersonController

- (void)dealloc {
    [_person release];
    [_personBuilder release];
    [_chineseNameTextField release];
    [_englishNameTextField release];
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
            self.personBuilder.nameEnglish = person.nameEnglish;
        }
    }
    return self;
}

#define CHINESE_NAME_TEXT_FIELD_TAG 2012122601
#define ENGLISH_NAME_TEXT_FIELD_TAG 2012122602
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    if (_isAdd) {
        self.title = NSLS(@"添加入住人");
    } else {
        self.title = NSLS(@"修改入住人");
    }
    
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    self.chineseNameTextField.text = _personBuilder.name;
    self.englishNameTextField.text = _personBuilder.nameEnglish;
    
    self.chineseNameTextField.tag = CHINESE_NAME_TEXT_FIELD_TAG;
    self.englishNameTextField.tag = ENGLISH_NAME_TEXT_FIELD_TAG;
}

- (void)viewDidUnload {
    [self setChineseNameTextField:nil];
    [self setEnglishNameTextField:nil];
    [super viewDidUnload];
}

- (void)clickFinish:(id)sender
{
    if ([_chineseNameTextField.text length] == 0) {
        [self popupMessage:NSLS(@"请输入中文名") title:nil];
        return;
    }
    
    if ([_englishNameTextField.text length] == 0) {
        [self popupMessage:NSLS(@"请输入英文名") title:nil];
        return;
    }
    
    if ([_englishNameTextField.text rangeOfString:@"/"].location == NSNotFound) {
        [self popupMessage:NSLS(@"英文名的格式不对") title:nil];
        return;
    }
    
    [_personBuilder setName:_chineseNameTextField.text];
    [_personBuilder setNameEnglish:_englishNameTextField.text];
    
    PersonManager *manager = [PersonManager defaultManager:PersonTypeCheckIn isMember:_isMember];
    
    if (self.isAdd == NO) {
        [manager deletePerson:_person];
    }
    Person *person = [_personBuilder build];
    [manager savePerson:person];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
