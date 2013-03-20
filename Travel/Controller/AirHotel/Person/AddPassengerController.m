//
//  AddPassengerController.m
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "AddPassengerController.h"
#import "ImageManager.h"
#import "FontSize.h"
#import "AirHotel.pb.h"
#import "TimeUtils.h"
#import "AppManager.h"
#import "PersonManager.h"
#import "IdCardUtil.h"

@interface AddPassengerController ()

@property (assign, nonatomic) BOOL isAdd;
@property (retain, nonatomic) Person *person;
@property (retain, nonatomic) Person_Builder *personBuilder;
@property (retain, nonatomic) NSDate *birthday;
@property (retain, nonatomic) NSMutableArray *selectedItemIds;
@property (assign, nonatomic) BOOL isMember;
@end

#define TITLE_PASSENGE_TYPE     @"登机人类型:"
#define TITLE_NAME              @"姓       名:"
#define TITLE_CARD_TYPE         @"证件类型:"
#define TITLE_CARD_NUMBER       @"证件号码:"
#define TITLE_GENDER            @"性       别:"
#define TITLE_BIRTHDAY          @"出生日期:"

@implementation AddPassengerController
@synthesize personBuilder = _personBuilder;

- (void)dealloc
{
    [_person release];
    [_personBuilder release];
    [_datePickerView release];
    [_datePickerHolderView release];
    [_birthday release];
    [_selectedItemIds release];
    [super dealloc];
}

- (id)initWithIsAdd:(BOOL)isAdd person:(Person *)person isMember:(BOOL)isMember
{
    self = [super init];
    if (self) {
        self.isAdd = isAdd;
        self.isMember = isMember;
        self.personBuilder = [[[Person_Builder alloc] init] autorelease];
        self.selectedItemIds = [[[NSMutableArray alloc] init] autorelease];
        
        if (isAdd == NO) {
            self.person = person;
            self.personBuilder.ageType = person.ageType;
            self.personBuilder.name = person.name;
            self.personBuilder.cardTypeId = person.cardTypeId;
            self.personBuilder.cardNumber = person.cardNumber;
            self.personBuilder.gender = person.gender;
            self.personBuilder.birthday = person.birthday;
            self.birthday = [NSDate dateWithTimeIntervalSince1970:_personBuilder.birthday];
            
            [_selectedItemIds addObject:[NSNumber numberWithInt:person.cardTypeId]];
        }
    }
    return self;
}

- (void)updateCellTitles
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:TITLE_PASSENGE_TYPE, TITLE_NAME, TITLE_GENDER, TITLE_CARD_TYPE, nil];
    
    NSString *cardTypeName = [[AppManager defaultManager] getCardName:_personBuilder.cardTypeId];
    BOOL isOther = [cardTypeName isEqualToString:@"其他"];
    
    if (!(_personBuilder.ageType == PersonAgeTypePersonAgeChild && isOther)) {
        [mutableArray addObject:TITLE_CARD_NUMBER];
    } else {
        [_personBuilder clearCardNumber];
    }
    
    if (_personBuilder.ageType == PersonAgeTypePersonAgeChild) {
        [mutableArray addObject:TITLE_BIRTHDAY];
    } else {
        [_personBuilder clearBirthday];
    }
    
    
    self.dataList = mutableArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    
    if (_isAdd) {
        self.title = NSLS(@"添加登机人");
    } else {
        self.title = NSLS(@"修改登机人");
    }
    
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"完成")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    [self updateCellTitles];
    
    self.datePickerHolderView.hidden = YES;
    if (self.birthday == nil) {
        self.birthday = [NSDate date];
    }
    self.datePickerView.date = _birthday;
    self.datePickerView.maximumDate = [NSDate date];
}

- (NSInteger)age
{
    NSDate *today = [NSDate date];
    
    NSInteger age = getYear(today) - getYear(_birthday);
    
    if (age <= 0) {
        return 0;
    }
    
    if (getMonth(today) < getMonth(_birthday)){
        age -- ;
    } else if (getMonth(today) == getMonth(_birthday)){
        if (getDay(today) < getDay(_birthday)) {
            age --;
        }
    }
    
    return age;
}

- (BOOL)isRightAgeTypeAndBirthday
{
    if ([self age] >= 12 && _personBuilder.ageType == PersonAgeTypePersonAgeChild) {
        [self popupMessage:NSLS(@"年满12周岁儿童视为成人登机人，请更改为成人") showSeconds:3];
        return NO;
    }
    
    if ([self age] < 12 && _personBuilder.ageType == PersonAgeTypePersonAgeAdult) {
        [self popupMessage:NSLS(@"未满12周岁视为儿童，请更改为儿童")  showSeconds:3];
        return NO;
    }
    
    return YES;
}

- (void)clickFinish:(id)sender
{
    [self.dataTableView reloadData];
    
    if ([_personBuilder hasAgeType] == NO) {
        [self popupMessage:NSLS(@"请选择登机人类型") title:nil];
        return;
    }
    
    if ([_personBuilder hasName] == NO) {
        [self popupMessage:NSLS(@"请输入姓名") title:nil];
        return;
    }
    
    if ([_personBuilder hasCardTypeId] == NO) {
        [self popupMessage:NSLS(@"请选择证件类型") title:nil];
        return;
    }
    
    
    NSString *cardTypeName = [[AppManager defaultManager] getCardName:_personBuilder.cardTypeId];
    BOOL isOther = [cardTypeName isEqualToString:@"其他"];
    if (!(_personBuilder.ageType == PersonAgeTypePersonAgeChild && isOther)) {
        if ([_personBuilder hasCardNumber] == NO || [[_personBuilder cardNumber] length] == 0) {
            [self popupMessage:NSLS(@"请输入证件号码") title:nil];
            return;
        }
    }
    
    
    if ([_personBuilder hasGender] == NO) {
        [self popupMessage:NSLS(@"请选择性别") title:nil];
        return;
    }

    
    if (_personBuilder.ageType == PersonAgeTypePersonAgeChild) {
        if ([_personBuilder hasBirthday] == NO) {
            [self popupMessage:NSLS(@"请选择出生日期") title:nil];
            return;
        }
        
        if ([self isRightAgeTypeAndBirthday] == NO) {
            return;
        }
    }
    
    NSMutableCharacterSet *mutableSet = [NSCharacterSet symbolCharacterSet];
    [mutableSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    if ([_personBuilder.cardNumber rangeOfCharacterFromSet:mutableSet].location != NSNotFound) {
        [self popupMessage:NSLS(@"证件号码含有非法字符") title:nil];
        return;
    }
    
    [mutableSet removeCharactersInString:@"/"];
    if ([_personBuilder.name rangeOfCharacterFromSet:mutableSet].location != NSNotFound) {
        [self popupMessage:NSLS(@"姓名含有非法字符") title:nil];
        return;
    }
    
    
    if ([cardTypeName isEqualToString:@"身份证"]) {
        NSString *resultTips = @"";
        if ([IdCardUtil checkIdcard:_personBuilder.cardNumber resultTips:&resultTips] == NO) {
            [self popupMessage:NSLS(@"输入身份证号码不正确，请重新输入") title:nil];
            return;
        }
    }
    
    
    PersonManager *manager = [PersonManager defaultManager:PersonTypePassenger isMember:_isMember];
    
    if (_isAdd) {
        if ([manager isExistName:_personBuilder.name]) {
            [self popupMessage:NSLS(@"已经存在此姓名") title:nil];
            return;
        }
        
        if ([manager isExistCardTypeId:_personBuilder.cardTypeId cardNumber:_personBuilder.cardNumber]) {
            [self popupMessage:NSLS(@"已经存在此证件号码") title:nil];
            return;
        }
        
    } else {
        [manager deletePerson:_person];
    }
    
    Person *person = [self.personBuilder build];
    [manager savePerson:person];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AddPersonCell getCellHeight];
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [AddPersonCell getCellIdentifier];
    AddPersonCell *cell = (AddPersonCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [AddPersonCell createCell:self];
    }
    
    NSString *cellTitle = [dataList objectAtIndex:indexPath.row];
    
    if ([cellTitle isEqualToString:TITLE_PASSENGE_TYPE]) {
        BOOL isAdult = NO;
        BOOL isChild = NO;
        if ([_personBuilder hasAgeType]) {
            isAdult = (_personBuilder.ageType == PersonAgeTypePersonAgeAdult);
            isChild = !isAdult;
        }
        [cell setCellWithType:TypeRadio
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                 hasInputTips:NO
                  radio1Title:NSLS(@"成人")
                  radio2Title:NSLS(@"儿童")
               radio1Selected:isAdult
               radio2Selected:isChild
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_NAME]) {
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_personBuilder.name
             inputPlaceholder:NSLS(@"请输入姓名")
                 hasInputTips:YES
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_CARD_TYPE]) {
        NSString *cardTypeName = nil;
        if ([_personBuilder hasCardTypeId]) {
            cardTypeName = [[AppManager defaultManager] getCardName:_personBuilder.cardTypeId];
        } else {
            cardTypeName = NSLS(@"请选择");
        }
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                 hasInputTips:NO
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:cardTypeName];
        
    }
    
    else if ([cellTitle isEqualToString:TITLE_CARD_NUMBER]) {
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_personBuilder.cardNumber
             inputPlaceholder:NSLS(@"请输入证件号码")
                 hasInputTips:NO
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    
    else if ([cellTitle isEqualToString:TITLE_GENDER]) {
        BOOL isMale = NO;
        BOOL isFemale = NO;
        if ([_personBuilder hasGender]) {
            isMale = (_personBuilder.gender == PersonGenderPersonGenderMale);
            isFemale = !isMale;
        }
        [cell setCellWithType:TypeRadio
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                 hasInputTips:NO
                  radio1Title:NSLS(@"男")
                  radio2Title:NSLS(@"女")
               radio1Selected:isMale
               radio2Selected:isFemale
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_BIRTHDAY]) {
        NSString *birthStr = nil;
        if ([_personBuilder hasBirthday]) {
            NSDate *birthDay = [NSDate dateWithTimeIntervalSince1970:_personBuilder.birthday];
            birthStr = dateToChineseString(birthDay);
        } else {
            birthStr = NSLS(@"请选择");
        }
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                 hasInputTips:NO
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:birthStr];
    }
    
    return cell;
}

#pragma mark -
#pragma AddPersonCellDelegate methods
- (void)didClickRadio1Button:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_PASSENGE_TYPE]) {
        [_personBuilder setAgeType:PersonAgeTypePersonAgeAdult];
        [self updateCellTitles];
    } else if ([title isEqualToString:TITLE_GENDER]) {
        [_personBuilder setGender:PersonGenderPersonGenderMale];
    }
    //[self resetViewSite];
    [dataTableView reloadData];
}

- (void)didClickRadio2Button:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_PASSENGE_TYPE]) {
        [_personBuilder setAgeType:PersonAgeTypePersonAgeChild];
        [self updateCellTitles];
    }else if ([title isEqualToString:TITLE_GENDER]) {
        [_personBuilder setGender:PersonGenderPersonGenderFemale];
    }
    //[self resetViewSite];
    [dataTableView reloadData];
}

- (void)didClickSelectButton:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_CARD_TYPE]) {
        NSArray *itemList = [[AppManager defaultManager] getCardItemList];
        
        SelectController *controller = [[[SelectController alloc] initWithTitle:NSLS(@"证件类型") itemList:itemList selectedItemIds:_selectedItemIds multiOptions:NO needConfirm:YES needShowCount:NO] autorelease];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([title isEqualToString:TITLE_BIRTHDAY]) {
        self.datePickerHolderView.hidden = NO;
    }
    //[self resetViewSite];
    [dataTableView reloadData];
}

- (void)didClickInputTipsButton:(NSIndexPath *)indexPath
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLS(@"英文姓名填写格式") message:NSLS(@"姓名填写必须用字母，与登机所持证件一直（按“姓/名”）的格式填写，例如zhang/sansan") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLS(@"确定"), nil];
    [myAlertView show];
    [myAlertView release];
}


- (void)inputTextFieldDidEndEditing:(NSIndexPath *)indexPath text:(NSString *)text
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_NAME]) {
        [_personBuilder setName:text];
    } if ([title isEqualToString:TITLE_CARD_NUMBER]) {
        [_personBuilder setCardNumber:text];
    }
    
    [dataTableView reloadData];
}

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)indexPath text:(NSString *)text
{
}

- (void)inputTextFieldShouldReturn:(NSIndexPath *)indexPath text:(NSString *)text
{
}

- (void)inputTextFieldshouldChange:(NSIndexPath *)indexPath text:(NSString *)text
{
}

#pragma mark - 
#pragma SelectControllerDelegate methods
- (void)didSelectFinish:(NSArray*)selectedItems
{
    if ([_selectedItemIds count] > 0) {
        int cardTypeId = [[_selectedItemIds objectAtIndex:0] intValue];
        [_personBuilder setCardTypeId:cardTypeId];
        [self updateCellTitles];
    }
    [dataTableView reloadData];
}

- (IBAction)clickCancelDatePickerButton:(id)sender {
    self.datePickerHolderView.hidden = YES;
}

- (IBAction)clickFinishDatePickerButton:(id)sender {
    self.datePickerHolderView.hidden = YES;
    [_personBuilder setBirthday:[_birthday timeIntervalSince1970]];
    [dataTableView reloadData];
}

- (IBAction)dateChange:(id)sender {
    self.birthday = self.datePickerView.date;
}

- (void)viewDidUnload {
    [self setDatePickerView:nil];
    [self setDatePickerHolderView:nil];
    [super viewDidUnload];
}

#pragma mark Keyboard Methods
- (void)keyboardDidShowWithRect:(CGRect)keyboardRect
{
    self.dataTableView.frame = CGRectMake(self.dataTableView.frame.origin.x, self.dataTableView.frame.origin.y, self.dataTableView.frame.size.width, self.view.frame.size.height - keyboardRect.size.height - 10);
}

- (void)keyboardWillHideWithRect:(CGRect)keyboardRect
{
    self.dataTableView.frame = CGRectMake(self.dataTableView.frame.origin.x, self.dataTableView.frame.origin.y, self.dataTableView.frame.size.width, self.view.frame.size.height);
}

@end
