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

@interface SelectPersonController ()

@property (retain, nonatomic) NSMutableArray *selectedIndexList;
@property (assign, nonatomic) PersonType personType;
@property (assign, nonatomic) BOOL isMultipleChoice;
@property (assign, nonatomic) id<SelectPersonControllerDelegate> delegate;

@end


@implementation SelectPersonController
@synthesize selectedIndexList = _selectedIndexList;
@synthesize personType = _personType;
@synthesize isMultipleChoice = _isMultipleChoice;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_selectedIndexList release];
    [super dealloc];
}

- (id)initWithType:(PersonType)personType
  isMultipleChoice:(BOOL)isMultipleChoice
          delegate:(id<SelectPersonControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.personType = personType;
        self.isMultipleChoice = isMultipleChoice;
        self.delegate = delegate;
        
        self.selectedIndexList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataList = [[PersonManager defaultManager] personList:_personType];
    
    self.title = NSLS(@"信用卡支付");
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

- (void)clickFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSIndexPath *indexPath in _selectedIndexList) {
        [resultArray addObject:[dataList objectAtIndex:indexPath.row]];
    }
    
    if ([_delegate respondsToSelector:@selector(finishSelectPerson:object:)]) {
        [_delegate finishSelectPerson:_personType objectList:resultArray];
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
    return 5;
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
        [_selectedIndexList addObject:indexPath];
    }
    
}


@end
