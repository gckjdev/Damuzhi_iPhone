//
//  AddCreditCardController.m
//  Travel
//
//  Created by haodong on 12-12-26.
//
//

#import "AddCreditCardController.h"
#import "AirHotel.pb.h"
#import "ImageManager.h"
#import "FontSize.h"
#import "CreditCardManager.h"
#import "AppManager.h"
#import "UIViewUtils.h"
#import "TimeUtils.h"
#import "IdCardUtil.h"

@interface AddCreditCardController ()
@property (assign, nonatomic) BOOL isAdd;
@property (retain, nonatomic) CreditCard *creditCard;
@property (retain, nonatomic) CreditCard_Builder *creditCardBuilder;
@property (assign, nonatomic) int validYear;
@property (assign, nonatomic) int validMonth;
@property (retain, nonatomic) NSMutableArray *bankSelectedItemIds;
@property (retain, nonatomic) NSMutableArray *idCardSelectedItemIds;
@property (assign, nonatomic) BOOL isMember;
@end

@implementation AddCreditCardController

#define TITLE_BANK           @"发卡银行:"
#define TITLE_CARD_NUMBER    @"卡   号:"
#define TITLE_CCV            @"CCV:"
#define TITLE_NAME           @"持卡人姓名:"
#define TITLE_VALID_DATE     @"有效期:"
#define TITLE_ID_CARD_TYPE   @"证件类型:"
#define TITLE_ID_CARD_NUMBER @"证件号码:"

- (void)dealloc
{
    [_creditCard release];
    [_creditCardBuilder release];
    [_bankSelectedItemIds release];
    [_idCardSelectedItemIds release];
    [_datePickerHolderView release];
    [_monthPicker release];
    [super dealloc];
}

- (id)initWithIsAdd:(BOOL)isAdd creditCard:(CreditCard *)creditCard isMember:(BOOL)isMember;
{
    self = [super init];
    if (self) {
        self.isAdd = isAdd;
        self.isMember = isMember;
        self.creditCardBuilder = [[[CreditCard_Builder alloc] init] autorelease];
        self.bankSelectedItemIds = [[[NSMutableArray alloc] init] autorelease];
        self.idCardSelectedItemIds = [[[NSMutableArray alloc] init] autorelease];
        
        if (isAdd == NO) {
            self.creditCard = creditCard;
            self.creditCardBuilder.bankId = creditCard.bankId;
            self.creditCardBuilder.number = creditCard.number;
            self.creditCardBuilder.ccv = creditCard.ccv;
            self.creditCardBuilder.name = creditCard.name;
            self.creditCardBuilder.validDateYear = creditCard.validDateYear;
            self.creditCardBuilder.validDateMonth = creditCard.validDateMonth;
            self.creditCardBuilder.idCardTypeId = creditCard.idCardTypeId;
            self.creditCardBuilder.idCardNumber = creditCard.idCardNumber;
            
            [_bankSelectedItemIds addObject:[NSNumber numberWithInt:creditCard.bankId]];
            [_idCardSelectedItemIds addObject:[NSNumber numberWithInt:creditCard.idCardTypeId]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    if (_isAdd) {
        self.title = NSLS(@"添加信用卡");
    } else {
        self.title = NSLS(@"修改信用卡");
    }
    
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"完成")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
    self.dataList = [NSArray arrayWithObjects:TITLE_BANK, TITLE_CARD_NUMBER, TITLE_CCV, TITLE_NAME, TITLE_VALID_DATE, TITLE_ID_CARD_TYPE, TITLE_ID_CARD_NUMBER, nil];
    [self setDefaultMonthPicker];
}

- (void)setDefaultMonthPicker
{
    self.datePickerHolderView.hidden = YES;
    
    self.monthPicker.monthPickerDelegate = self;
    self.monthPicker.date = [NSDate date];
    self.validYear = getYear(self.monthPicker.date);
    self.validMonth = getMonth(self.monthPicker.date);
    self.monthPicker.minimumYear = [NSNumber numberWithInt:_validYear];
    self.monthPicker.maximumYear = [NSNumber numberWithInt:_validYear + 100];
    self.monthPicker.yearFirst = YES;
    self.monthPicker.enableColourRow = YES;
}

- (void)clickFinish:(id)sender
{
    [self resetViewSite];
    
    if ([_creditCardBuilder hasBankId] == NO) {
        [self popupMessage:NSLS(@"请选择发卡银行") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasNumber] == NO) {
        [self popupMessage:NSLS(@"请输入卡号") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasCcv] == NO) {
        [self popupMessage:NSLS(@"请输入卡背面的数字") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasName] == NO) {
        [self popupMessage:NSLS(@"请输入持卡人姓名") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasValidDateYear] == NO || [_creditCardBuilder hasValidDateMonth] == NO) {
        [self popupMessage:NSLS(@"请选择有效期") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasIdCardTypeId] == NO) {
        [self popupMessage:NSLS(@"请选择证件类型") title:nil];
        return;
    }
    
    if ([_creditCardBuilder hasIdCardNumber] == NO) {
        [self popupMessage:NSLS(@"请输入证件号码") title:nil];
        return;
    }
    
    NSString *cardTypeName = [[AppManager defaultManager] getCardName:_creditCardBuilder.idCardTypeId];
    if ([cardTypeName isEqualToString:@"身份证"]) {
        NSString *resultTips = @"";
        if ([IdCardUtil checkIdcard:_creditCardBuilder.idCardNumber resultTips:&resultTips] == NO) {
            [self popupMessage:resultTips title:nil];
            return;
        }
    }
    
    
    CreditCardManager *manager = [CreditCardManager defaultManager];
    
    if (self.isAdd == NO) {
        if (_isMember) {
            [manager deleteCreditCard:_creditCard];
        } else {
            [manager deleteTempCreditCard:_creditCard];
        }
    }
    CreditCard *creditCard = [self.creditCardBuilder build];
    if (_isMember) {
        [manager saveCreditCard:creditCard];
    } else {
        [manager addTempCreditCard:creditCard];
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
    
    if ([cellTitle isEqualToString:TITLE_BANK]) {
        NSString *bankName = nil;
        if ([_creditCardBuilder hasBankId]) {
            bankName = [[AppManager defaultManager] getBankName:_creditCardBuilder.bankId];
        } else {
            bankName = NSLS(@"请选择");
        }
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:bankName];
    }
    
    else if ([cellTitle isEqualToString:TITLE_CARD_NUMBER]) {        
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_creditCardBuilder.number
             inputPlaceholder:NSLS(@"请输入卡号")
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_CCV]) {
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_creditCardBuilder.ccv
             inputPlaceholder:NSLS(@"卡背面的数字")
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_NAME]) {
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_creditCardBuilder.name
             inputPlaceholder:NSLS(@"请输入姓名")
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    else if ([cellTitle isEqualToString:TITLE_VALID_DATE]) {
        NSString *dateStr = nil;
        if ([_creditCardBuilder hasValidDateYear] && [_creditCardBuilder hasValidDateMonth]) {
            dateStr = [NSString stringWithFormat:@"%d年%d月", _creditCardBuilder.validDateYear, _creditCardBuilder.validDateMonth];
        } else {
            dateStr = NSLS(@"请选择");
        }
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:dateStr];
    }
    
    else if ([cellTitle isEqualToString:TITLE_ID_CARD_TYPE]) {
        NSString *idCardName = nil;
        if ([_creditCardBuilder hasIdCardTypeId]) {
            idCardName = [[AppManager defaultManager] getCardName:_creditCardBuilder.idCardTypeId];
        } else {
            idCardName = NSLS(@"请选择");
        }
        
        [cell setCellWithType:TypeSelect
                    indexPath:indexPath
                        title:cellTitle
                    inputText:nil
             inputPlaceholder:nil
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:idCardName];
    }
    
    else if ([cellTitle isEqualToString:TITLE_ID_CARD_NUMBER]) {
        [cell setCellWithType:TypeInput
                    indexPath:indexPath
                        title:cellTitle
                    inputText:_creditCardBuilder.idCardNumber
             inputPlaceholder:NSLS(@"请输入证件号码")
                  radio1Title:nil
                  radio2Title:nil
               radio1Selected:NO
               radio2Selected:NO
            selectButtonTitle:nil];
    }
    
    return cell;
}

- (void)moveView:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, - (40 + indexPath.row * 20), self.view.frame.size.width, self.view.frame.size.height);
        [UIImageView commitAnimations];
    } else {
        [self resetViewSite];
    }
}

- (void)resetViewSite
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIImageView commitAnimations];
}

#pragma mark -
#pragma AddPersonCellDelegate methods
- (void)didClickSelectButton:(NSIndexPath *)indexPath
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_BANK]) {
        NSArray *itemList = [[AppManager defaultManager] getBankItemList];
        
        SelectController *controller = [[[SelectController alloc] initWithTitle:NSLS(@"银行") itemList:itemList selectedItemIds:_bankSelectedItemIds multiOptions:NO needConfirm:YES needShowCount:NO] autorelease];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    else if ([title isEqualToString:TITLE_VALID_DATE]) {
        self.datePickerHolderView.hidden = NO;
    }
    
    else if ([title isEqualToString:TITLE_ID_CARD_TYPE]) {
        NSArray *itemList = [[AppManager defaultManager] getCardItemList];
        
        SelectController *controller = [[[SelectController alloc] initWithTitle:NSLS(@"证件类型") itemList:itemList selectedItemIds:_idCardSelectedItemIds multiOptions:NO needConfirm:YES needShowCount:NO] autorelease];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [self resetViewSite];
    [dataTableView reloadData];
}

- (void)inputTextFieldDidEndEditing:(NSIndexPath *)indexPath text:(NSString *)text
{
    NSString *title = [dataList objectAtIndex:indexPath.row];
    if ([title isEqualToString:TITLE_CARD_NUMBER]) {
        [_creditCardBuilder setNumber:text];
    } else if ([title isEqualToString:TITLE_CCV]) {
        [_creditCardBuilder setCcv:text];
    } else if ([title isEqualToString:TITLE_NAME]) {
        [_creditCardBuilder setName:text];
    } else if ([title isEqualToString:TITLE_ID_CARD_NUMBER]) {
        [_creditCardBuilder setIdCardNumber:text];
    }
    
    [dataTableView reloadData];
}

- (void)inputTextFieldDidBeginEditing:(NSIndexPath *)indexPath text:(NSString *)text
{
    [self moveView:indexPath];
}

- (void)inputTextFieldShouldReturn:(NSIndexPath *)indexPath text:(NSString *)text
{
    [self resetViewSite];
}

#pragma mark -
#pragma SelectControllerDelegate methods
- (void)didSelectFinish:(NSArray*)selectedItems
{
    if ([_bankSelectedItemIds count] > 0) {
        int bankId = [[_bankSelectedItemIds objectAtIndex:0] intValue];
        [_creditCardBuilder setBankId:bankId];
    }
    
    if ([_idCardSelectedItemIds count] > 0) {
        int idCardTypeId = [[_idCardSelectedItemIds objectAtIndex:0] intValue];
        [_creditCardBuilder setIdCardTypeId:idCardTypeId];
    }
    
    [dataTableView reloadData];
}

- (IBAction)clickCancelDatePickerButton:(id)sender {
    self.datePickerHolderView.hidden = YES;
}

- (IBAction)clickFinishDatePickerButton:(id)sender {
    self.datePickerHolderView.hidden = YES;
    [_creditCardBuilder setValidDateYear:_validYear];
    [_creditCardBuilder setValidDateMonth:_validMonth];
    [dataTableView reloadData];
}

#pragma mark - 
#pragma SRMonthPickerDelegate methods
- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    self.validYear = getYear(monthPicker.date);
    self.validMonth = getMonth(monthPicker.date);
}

- (void)viewDidUnload {
    [self setDatePickerHolderView:nil];
    [self setMonthPicker:nil];
    [super viewDidUnload];
}
@end
