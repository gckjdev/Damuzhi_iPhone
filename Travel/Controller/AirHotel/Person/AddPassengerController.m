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
#import "SelectController.h"
#import "TimeUtils.h"

@interface AddPassengerController ()
@property (retain, nonatomic) Person_Builder *personBuilder;
@property (retain, nonatomic) NSDate *birthday;
@end

#define TITLE_PASSENGE_TYPE     @"登机人类型:"
#define TITLE_NAME              @"姓   名:"
#define TITLE_CARD_TYPE         @"证件类型:"
#define TITLE_CARD_NUMBER       @"证件号码:"
#define TITLE_GENDER            @"性   别:"
#define TITLE_BIRTHDAY          @"出生日期:"

@implementation AddPassengerController
@synthesize personBuilder = _personBuilder;

- (void)dealloc
{
    [_personBuilder release];
    [_datePickerView release];
    [_datePickerHolderView release];
    [_birthday release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.personBuilder = [[[Person_Builder alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    self.title = NSLS(@"添加登机人");
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"完成")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    self.dataList = [NSArray arrayWithObjects:TITLE_PASSENGE_TYPE, TITLE_NAME, TITLE_CARD_TYPE, TITLE_CARD_NUMBER, TITLE_GENDER, TITLE_BIRTHDAY, nil];
    
    self.datePickerHolderView.hidden = YES;
    self.birthday = [NSDate date];
    self.datePickerView.date = _birthday;
}


- (void)clickFinish:(id)sender
{
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
    
    if ([_personBuilder hasCardNumber] == NO) {
        [self popupMessage:NSLS(@"请输入证件号码") title:nil];
        return;
    }
    
    if ([_personBuilder hasGender] == NO) {
        [self popupMessage:NSLS(@"请选择性别") title:nil];
        return;
    }
    
    if ([_personBuilder hasBirthday] == NO) {
        [self popupMessage:NSLS(@"请选择出生日期") title:nil];
        return;
    }
    
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
                  radio1Title:NSLS(@"成人")
                  radio2Title:NSLS(@"儿童")
               radio1Selected:isAdult
               radio2Selected:isChild
            selectButtonTitle:nil];
    } else if ([cellTitle isEqualToString:TITLE_NAME]) {
        
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_personBuilder.name
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    } else if ([cellTitle isEqualToString:TITLE_CARD_TYPE]) {
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:NSLS(@"请选择")];
        
    } else if ([cellTitle isEqualToString:TITLE_CARD_NUMBER]) {
        
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_personBuilder.cardNumber
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
        
    } else if ([cellTitle isEqualToString:TITLE_GENDER]) {
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
                  radio1Title:NSLS(@"男")
                  radio2Title:NSLS(@"女")
               radio1Selected:isMale
               radio2Selected:isFemale
            selectButtonTitle:nil];
        
    } else if ([cellTitle isEqualToString:TITLE_BIRTHDAY]) {
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
    } else if ([title isEqualToString:TITLE_GENDER]) {
        [_personBuilder setGender:PersonGenderPersonGenderMale];
    }
    
    [dataTableView reloadData];
}

- (void)didClickRadio2Button:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_PASSENGE_TYPE]) {
        [_personBuilder setAgeType:PersonAgeTypePersonAgeChild];
    }else if ([title isEqualToString:TITLE_GENDER]) {
        [_personBuilder setGender:PersonGenderPersonGenderFemale];
    }
    
    [dataTableView reloadData];
}

- (void)didClickSelectButton:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_CARD_TYPE]) {
        //SelectController *controller = [[[SelectController alloc] initWithTitle:<#(NSString *)#> itemList:<#(NSArray *)#> selectedItemIds:<#(NSMutableArray *)#> multiOptions:<#(BOOL)#> needConfirm:<#(BOOL)#> needShowCount:<#(BOOL)#>] autorelease];
        
    } else if ([title isEqualToString:TITLE_BIRTHDAY]) {
        self.datePickerHolderView.hidden = NO;
    }
    
    [dataTableView reloadData];
}

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)indexPath text:(NSString *)text
{
    
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

- (void)inputTextFieldShouldReturn:(NSIndexPath *)indexPath text:(NSString *)text
{
    
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
@end
