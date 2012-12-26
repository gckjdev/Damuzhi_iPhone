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
#import "AddCheckInPersonController.h"
#import "PersonManager.h"
#import "AddPassengerController.h"
#import "AddCreditCardController.h"

@interface SelectPersonController ()

@property (retain, nonatomic) NSMutableArray *selectedIndexList;
@property (assign, nonatomic) SelectPersonViewType type;
@property (assign, nonatomic) BOOL isMultipleChoice;
@property (assign, nonatomic) id<SelectPersonControllerDelegate> delegate;

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
    [super dealloc];
}

- (id)initWithType:(SelectPersonViewType)type
  isMultipleChoice:(BOOL)isMultipleChoice
          delegate:(id<SelectPersonControllerDelegate>)delegate
             title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.type = type;
        self.isMultipleChoice = isMultipleChoice;
        self.delegate = delegate;
        self.title = title;
        
        self.selectedIndexList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)updateTitleAndDataSource
{
    switch (_type) {
        case ViewTypePassenger:
            self.headeTitleLabel.text = NSLS(@"添加国际航班登机人");
            self.dataList = [[PersonManager defaultManager:PersonTypePassenger] findAllPersons];
            break;
        case ViewTypeCheckIn:
            self.headeTitleLabel.text = NSLS(@"添加入住人");
            self.dataList = [[PersonManager defaultManager:PersonTypeCheckIn] findAllPersons];
            break;
        case ViewTypeContact:
            self.headeTitleLabel.text = NSLS(@"添加联系人");
            break;
        case ViewTypeCreditCard:
            self.headeTitleLabel.text = NSLS(@"添加常用信用卡");
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
    [self setNavigationRightButton:NSLS(@"确定")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png"
                            action:@selector(clickFinish:)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTitleAndDataSource];
}

- (void)clickFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSIndexPath *indexPath in _selectedIndexList) {
        [resultArray addObject:[dataList objectAtIndex:indexPath.row]];
    }
    
    if ([_delegate respondsToSelector:@selector(finishSelectPerson:objectList:)]) {
        [_delegate finishSelectPerson:_type objectList:resultArray];
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
    
    id oneObject = [dataList objectAtIndex:indexPath.row];
    if ([[oneObject class] isSubclassOfClass:[Person class]]) {
        Person *person = (Person *)oneObject;
        [cell setCellWithTitle:person.name
                      subTitle:person.nameEnglish
                          note:nil
                     indexPath:indexPath];
    } else{
        CreditCard *creditCard = (CreditCard *)oneObject;
        [cell setCellWithTitle:creditCard.name
                      subTitle:creditCard.number
                          note:nil
                     indexPath:indexPath];
    }
    
    return cell;
}


#pragma mark -
#pragma SelectPersonCellDelegate method
- (void)didClickSelectButton:(NSIndexPath *)indexPath isSelect:(BOOL)isSelect
{
    int i = 0;
    BOOL found = NO;
    for (NSIndexPath *oneIndexPath in _selectedIndexList) {
        if (oneIndexPath.row == indexPath.row) {
            found = YES;
            break;
        }
        i++;
    }
    if (found) {
        [_selectedIndexList removeObjectAtIndex:i];
    }
    
    if (isSelect) {
        if (!self.isMultipleChoice) {
            [_selectedIndexList removeAllObjects];
        }
        
        [_selectedIndexList addObject:indexPath];
    }
    
}

- (IBAction)clickAddPersonButton:(id)sender {
    
    switch (_type) {
        case ViewTypePassenger:
        {
            AddPassengerController *controller = [[[AddPassengerController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCheckIn:
        {
            AddCheckInPersonController *controller  = [[[AddCheckInPersonController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeContact:
        {
            //for test
            AddPassengerController *controller = [[[AddPassengerController alloc] init] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case ViewTypeCreditCard:
        {
            AddCreditCardController *controller = [[[AddCreditCardController alloc] init] autorelease];
            [self.navigationController pushViewController:controller
                                                 animated:YES];
            break;
        }
            
        default:
            break;
    }
    

}

- (void)viewDidUnload {
    [self setHeadeTitleLabel:nil];
    [super viewDidUnload];
}
@end
