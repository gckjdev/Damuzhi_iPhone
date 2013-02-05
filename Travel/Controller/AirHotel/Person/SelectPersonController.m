//
//  SelectPersonController.m
//  Travel
//
//  Created by haodong on 12-12-4.
//
//

#import "SelectPersonController.h"
#import "FontSize.h"
#import "ImageManager.h"
#import "AirHotel.pb.h"
#import "PersonManager.h"
#import "CreditCardManager.h"
#import "AddCheckInPersonController.h"
#import "AddPassengerController.h"
#import "AddCreditCardController.h"
#import "AddContactPersonController.h"

@interface SelectPersonController ()

@property (retain, nonatomic) NSMutableArray *selectedIndexList;
@property (assign, nonatomic) SelectPersonViewType type;
@property (assign, nonatomic) BOOL isMultipleChoice;
@property (assign, nonatomic) id<SelectPersonControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isSelect;
@property (assign, nonatomic) BOOL isEidtingTable;
@property (assign, nonatomic) NSUInteger selectCount;
@property (assign, nonatomic) BOOL isMember;

@end


@implementation SelectPersonController
@synthesize selectedIndexList = _selectedIndexList;
@synthesize type = _type;
@synthesize isMultipleChoice = _isMultipleChoice;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_selectedIndexList release];
    [_headeTitleLabel release];
    [_headerHolderView release];
    [super dealloc];
}

- (id)initWithType:(SelectPersonViewType)type 
       selectCount:(NSUInteger)selectCount
          delegate:(id<SelectPersonControllerDelegate>)delegate
             title:(NSString *)title
          isSelect:(BOOL)isSelect
          isMember:(BOOL)isMember
{
    self = [super init];
    if (self) {
        self.type = type;
        self.selectCount = selectCount;
        self.isMultipleChoice = (selectCount > 1);
        self.delegate = delegate;
        self.title = title;
        self.isSelect = isSelect;
        self.isMember = isMember;
        
        self.selectedIndexList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)updateTitleAndDataSource
{
    switch (_type) {
        case ViewTypePassenger:
            self.headeTitleLabel.text = NSLS(@"添加航班登机人");
            self.dataList = [[PersonManager defaultManager:PersonTypePassenger isMember:_isMember] findAllPersons];
            break;
            
        case ViewTypeCheckIn:
            self.headeTitleLabel.text = NSLS(@"添加入住人");
            self.dataList = [[PersonManager defaultManager:PersonTypeCheckIn isMember:_isMember] findAllPersons];
            break;
            
        case ViewTypeContact:
            self.headeTitleLabel.text = NSLS(@"添加联系人");
            self.dataList = [[PersonManager defaultManager:PersonTypeContact isMember:_isMember] findAllPersons];
            break;
            
        case ViewTypeCreditCard:
            self.headeTitleLabel.text = NSLS(@"添加常用信用卡");
            if (_isMember) {
                self.dataList = [[CreditCardManager defaultManager] findAllCreditCards];
            } else {
                self.dataList = [[CreditCardManager defaultManager] findAllTempCreditCards];
            }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[ImageManager defaultManager] allBackgroundImage]]];
    [self setNavigationLeftButton:NSLS(@" 返回")
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    NSString *rightButtonTitle = nil;
    if (_isSelect) {
        rightButtonTitle = NSLS(@"确定");
    } else {
        rightButtonTitle = NSLS(@"管理");
    }
    
    [self setNavigationRightButton:rightButtonTitle
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTitleAndDataSource];
}

- (void)moveHeaderToRight
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    self.headerHolderView.frame = CGRectMake(41, self.headerHolderView.frame.origin.y, self.headerHolderView.frame.size.width, self.headerHolderView.frame.size.height);
    [UIImageView commitAnimations];
}

- (void)resetHeader
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.30];
    self.headerHolderView.frame = CGRectMake(9, self.headerHolderView.frame.origin.y, self.headerHolderView.frame.size.width, self.headerHolderView.frame.size.height);
    [UIImageView commitAnimations];
}

- (void)clickFinish:(id)sender
{
    if (_isSelect) {
        if ([_selectedIndexList count] == 0) {
            [self popupMessage:NSLS(@"请选择") title:nil];
            return;
        }
        
        if (_type == ViewTypeCheckIn && [_selectedIndexList count] != _selectCount) {
            [self popupMessage:NSLS(@"入住人数与房间数不一致") title:nil];
            return;
        }
        
        NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
        for (NSIndexPath *indexPath in _selectedIndexList) {
            [resultArray addObject:[dataList objectAtIndex:indexPath.row]];
        }
        
        if ([_delegate respondsToSelector:@selector(finishSelectPerson:objectList:)]) {
            [_delegate finishSelectPerson:_type objectList:resultArray];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        _isEidtingTable = !_isEidtingTable;
        if (_isEidtingTable) {
            [self setNavigationRightButton:NSLS(@"完成")
                                  fontSize:FONT_SIZE
                                 imageName:@"topmenu_btn_right.png"
                                    action:@selector(clickFinish:)];
        } else {
            [self setNavigationRightButton:NSLS(@"管理")
                                  fontSize:FONT_SIZE
                                 imageName:@"topmenu_btn_right.png"
                                    action:@selector(clickFinish:)];
        }
        
        [dataTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SelectPersonCell getCellHeight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSelect) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark -
#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [SelectPersonCell getCellIdentifier];
    SelectPersonCell *cell = (SelectPersonCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [SelectPersonCell createCell:self];
    }
    
    if (_isSelect == NO) {
        cell.selectButton.hidden = YES;
    }
    
    id oneObject = [dataList objectAtIndex:indexPath.row];
    if ([[oneObject class] isSubclassOfClass:[Person class]]) {
        Person *person = (Person *)oneObject;
        [cell setCellWithType:_type
                       person:person
                   creditCard:nil
                    indexPath:indexPath
                   isSelected:[self isChoose:indexPath]
                   isMultiple:_isMultipleChoice];
    } else{
        CreditCard *creditCard = (CreditCard *)oneObject;
        [cell setCellWithType:_type
                       person:nil
                   creditCard:creditCard
                    indexPath:indexPath
                   isSelected:[self isChoose:indexPath]
                   isMultiple:_isMultipleChoice];
    }
    
    if (_isEidtingTable) {
        [cell showDeleteButton];
    }else{
        [cell showNormalAppearance];
    }
    
    return cell;
}

- (BOOL)isChoose:(NSIndexPath *)indexPath
{
    for (NSIndexPath *oneIndexPath in _selectedIndexList) {
        if (oneIndexPath.row == indexPath.row) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma SelectPersonCellDelegate method
- (void)didClickSelectButton:(NSIndexPath *)indexPath
{
    if ([self isChoose:indexPath]) {
        int i = 0;
        for (NSIndexPath *oneIndexPath in _selectedIndexList) {
            if (oneIndexPath.row == indexPath.row) {
                break;
            }
            i++;
        }
        
        [_selectedIndexList removeObjectAtIndex:i];
    } else {
        if (self.isMultipleChoice == NO) {
            [_selectedIndexList removeAllObjects];
        } else {
            if ([_selectedIndexList count] == _selectCount) {
                [self popupMessage:[NSString stringWithFormat:@"最多选择%d个",_selectCount] title:nil];
                return;
            }
        }
        [_selectedIndexList addObject:indexPath];
    }
    
    [dataTableView reloadData];
}

- (void)didClickEditButton:(NSIndexPath *)indexPath
{
    switch (_type) {
        case ViewTypePassenger:
        {
            Person *person = [dataList objectAtIndex:indexPath.row];
            AddPassengerController *controller  = [[[AddPassengerController alloc] initWithIsAdd:NO person:person isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCheckIn:
        {
            Person *person = [dataList objectAtIndex:indexPath.row];
            AddCheckInPersonController *controller  = [[[AddCheckInPersonController alloc] initWithIsAdd:NO person:person isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeContact:
        {
            Person *person = [dataList objectAtIndex:indexPath.row];
            AddContactPersonController *controller  = [[[AddContactPersonController alloc] initWithIsAdd:NO person:person isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCreditCard:
        {
            CreditCard *creditCard = [dataList objectAtIndex:indexPath.row];
            AddCreditCardController *controller = [[[AddCreditCardController alloc] initWithIsAdd:NO creditCard:creditCard isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)clickAddPersonButton:(id)sender {
    
    switch (_type) {
        case ViewTypePassenger:
        {
            AddPassengerController *controller = [[[AddPassengerController alloc] initWithIsAdd:YES person:nil isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCheckIn:
        {
            AddCheckInPersonController *controller  = [[[AddCheckInPersonController alloc] initWithIsAdd:YES person:nil isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeContact:
        {
            AddContactPersonController *controller = [[[AddContactPersonController alloc] initWithIsAdd:YES person:nil isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCreditCard:
        {
            AddCreditCardController *controller = [[[AddCreditCardController alloc] initWithIsAdd:YES creditCard:nil isMember:_isMember] autorelease];
            [self.navigationController pushViewController:controller
                                                 animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void)didClickDeleteButton:(NSIndexPath *)indexPath
{
    if (_type == ViewTypeCreditCard) {
        CreditCard *creditCard = (CreditCard *)[dataList objectAtIndex:indexPath.row];
        if (_isMember) {
            [[CreditCardManager defaultManager] deleteCreditCard:creditCard];
        } else {
            [[CreditCardManager defaultManager] deleteTempCreditCard:creditCard];
        }
    } else {
        PersonType storeType;
        if (_type == ViewTypeCheckIn) {
            storeType = PersonTypeCheckIn;
        } else if (_type == ViewTypeContact) {
            storeType = PersonTypeContact;
        } if (_type == ViewTypePassenger) {
            storeType = PersonTypePassenger;
        }
        
        Person *person = (Person *)[dataList objectAtIndex:indexPath.row];
        [[PersonManager defaultManager:storeType isMember:_isMember] deletePerson:person];
    }
    
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
    [mutableDataList removeObjectAtIndex:indexPath.row];
    self.dataList = mutableDataList;
    
    [self.dataTableView reloadData];
}

- (void)viewDidUnload {
    [self setHeadeTitleLabel:nil];
    [self setHeaderHolderView:nil];
    [super viewDidUnload];
}
@end
