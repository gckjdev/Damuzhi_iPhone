//
//  SelectCityController.m
//  Travel
//
//  Created by haodong qiu on 12年7月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "SelectCityController.h"
#import "Item.h"
#import "AppConstants.h"
#import "AppManager.h"
#import "StringUtil.h"

@interface SelectCityController ()
{
    typeCity _typeCity;
    BOOL _multiOptions;
}
@property (copy, nonatomic) NSString *navigationTitle;
@property (retain, nonatomic) NSArray *allDataList;
@property (assign, nonatomic) id<SelectCityDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *selectedItemIds;
@property (retain, nonatomic) NSMutableArray *selectedItemIdsBeforConfirm;
@property (retain, nonatomic) NSArray *areaList;

@end

@implementation SelectCityController

@synthesize navigationTitle = _navigationTitle;
@synthesize searchBar = _searchBar;
@synthesize areaView = _areaView;
@synthesize delegate = _delegate;
@synthesize allDataList = _allDataList;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize selectedItemIdsBeforConfirm = _selectedItemIdsBeforConfirm;
@synthesize areaList = _areaList;


- (void)dealloc
{
    PPRelease(_navigationTitle);
    PPRelease(_allDataList);
    PPRelease(_searchBar);
    PPRelease(_selectedItemIds);
    PPRelease(_selectedItemIdsBeforConfirm);
    PPRelease(_areaList);
    PPRelease(_areaView);
    [super dealloc];
}


- (id)initWithTitle:(NSString *)title 
         regionList:(NSArray *)regionList
           itemList:(NSArray *)itemList
   selectedItemIdList:(NSMutableArray *)selectedItemIdList
               type:(typeCity)typeCity
       multiOptions:(BOOL)multiOptions
           delegate:(id<SelectCityDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.navigationTitle = title;
        self.areaList = regionList;
        self.allDataList = itemList;
        self.dataList = itemList;
        self.selectedItemIds = selectedItemIdList;
        self.selectedItemIdsBeforConfirm = [NSMutableArray arrayWithArray:selectedItemIdList];
        _typeCity = typeCity;
        _multiOptions = multiOptions;
        self.delegate = delegate;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_navigationTitle];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    dataTableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    _areaView.frame = CGRectMake(_areaView.frame.origin.x, _areaView.frame.origin.y, _areaView.frame.size.width, 0);
    
    if (_typeCity == destination) {
        [self addAreaButton];
        
        //默认选中第一个按钮
        [self clickAreaButton:[[self buttonList] objectAtIndex:0]];
    }
}


- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setAreaView:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SelectCityControllerCell";
    UITableViewCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    Item *item = [dataList objectAtIndex:indexPath.row];
    NSString *text;
    if (_typeCity == depart && item.count != 0) {
        text = [NSString stringWithFormat:@"%@ (%d)", item.itemName, item.count];
    } else {
        text = item.itemName;
    }
    cell.textLabel.text = text;
    
    BOOL found = [self isSelectedId: item.itemId];
    if (found) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [dataList objectAtIndex:indexPath.row];
    
    BOOL found = [self isSelectedId:item.itemId];
    
    if (_multiOptions) {
        if (item.itemId == ALL_CATEGORY) {
            [_selectedItemIdsBeforConfirm removeAllObjects];
        } else {
            NSNumber *delNumber = [self findSelectedId:ALL_CATEGORY];
            [_selectedItemIdsBeforConfirm removeObject:delNumber];
        }
        
        if (found) {
            NSNumber *delNumber = [self findSelectedId:item.itemId];
            [_selectedItemIdsBeforConfirm removeObject:delNumber];
        } else {
            [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
        }
    } else {
        [_selectedItemIdsBeforConfirm removeAllObjects];
        [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
    }

    [dataTableView reloadData];
}


#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}


#pragma mark - searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar; 
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self updateHideKeyboardButton];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self update:searchBar.text];
    [self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateHideKeyboardButton];
    [self update:searchBar.text];
    
    NSArray *list = [self buttonList];
    for (UIButton *button in list) {
        button.selected = NO;
    }
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self clickHideKeyboardButton:nil];
}


#pragma mark - button action
- (void)clickSubmit:(id)sender
{
    if ([_selectedItemIdsBeforConfirm count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:NSLS(@"亲，您还没有选择哦！") delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCity:)]) {
        
        [_selectedItemIds removeAllObjects];
        for (NSNumber *itemId in _selectedItemIdsBeforConfirm) {
            [_selectedItemIds addObject:itemId];
        }
        [_delegate didSelectCity:_selectedItemIds];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - custom methods
- (BOOL)isSelectedId:(int)itemId
{
    if ([self findSelectedId:itemId] != nil)
        return YES;
    else 
        return NO;
}


- (NSNumber *)findSelectedId:(int)itemId
{
    NSNumber *returnNumber = nil;
    for (NSNumber *oneNumber in self.selectedItemIdsBeforConfirm) {
        if ([oneNumber intValue] == itemId) {
            returnNumber = oneNumber;
            break;
        }
    }
    
    return returnNumber;
}


- (void)update:(NSString *)keyword
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(Item *item in self.allDataList){
        int i=[item.itemName rangeOfString:keyword].location;
        if(i<item.itemName.length || [keyword isEqualToString:[item.itemName pinyinFirstLetter]]){
            [array addObject:item];
        }
    }
    
    self.dataList = array;
    if(keyword.length==0){
        self.dataList = _allDataList;
    }
    [array release];
    [dataTableView reloadData];
}


- (void)updateHideKeyboardButton
{
    if ([self.searchBar.text length] == 0) {
         [self addHideKeyboardButton];
    } else {
        [self removeHideKeyboardButton];
    }
}


#define HIDE_KEYBOARDBUTTON_TAG 77
- (void)removeHideKeyboardButton
{
    UIButton *button = (UIButton*)[self.view viewWithTag:HIDE_KEYBOARDBUTTON_TAG];
    [button removeFromSuperview];
}


- (void)addHideKeyboardButton
{
    [self removeHideKeyboardButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height)];
    button.backgroundColor = [UIColor blackColor];
    button.alpha = 0.5;
    button.tag = HIDE_KEYBOARDBUTTON_TAG;
    [button addTarget:self action:@selector(clickHideKeyboardButton:) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:button];
    [button release];
}


- (void)clickHideKeyboardButton:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self removeHideKeyboardButton];
}


#define BUTTON_START_TAG    100
#define BUTTON_COLUMNS      4
#define BUTTON_WIDTH        80
#define BUTTON_HEIGHT       30
- (void)addAreaButton
{
    if ([_areaList count] <= 1) {
        return;
    }

    CGFloat buttonWidth = BUTTON_WIDTH;
    CGFloat buttonHeight = BUTTON_HEIGHT;
    
    CGFloat totalHeight = (([_areaList count]-1) / 4 + 1) * buttonHeight; 
    _areaView.frame = CGRectMake(_areaView.frame.origin.x, _areaView.frame.origin.y, _areaView.frame.size.width, totalHeight);
    
    CGFloat x;
    CGFloat y;
    int count = 0;
    for (Region *region in _areaList) {
        //PPDebug(@"<SelectCityController> Region:%d n:%@",region.regionId, region.regionName);
        int column = count % BUTTON_COLUMNS;
        int row = count / BUTTON_COLUMNS;
        x = column * buttonWidth;
        y = row * buttonHeight;
        CGRect frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.tag = BUTTON_START_TAG + count;
        [button addTarget:self action:@selector(clickAreaButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"filter_2_off.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"filter_2_on.png"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:region.regionName forState:UIControlStateNormal];
        [_areaView addSubview:button];
        [button release];
        count++;
    }
}


- (NSArray *)buttonList
{
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    int num = 0;
    for (Region *region in _areaList) {
        UIButton *button = (UIButton *)[_areaView viewWithTag:BUTTON_START_TAG + num];
        [mutableArray addObject:button];
        
        num ++;
    }
    return mutableArray;
}


- (int)selectedRegionIdBySelectedButton:(UIButton *)button
{
    int index = button.tag - BUTTON_START_TAG;
    Region *region = [_areaList objectAtIndex:index];
    return region.regionId;
}


- (void)filterByRegionId:(int)regionId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    for(Item *item in self.allDataList){
        int cityRegionId = [[AppManager defaultManager] getRegionIdByCityId:item.itemId];
        if (cityRegionId == regionId) {
            [array addObject:item];
        }
    }
    
    self.dataList = array;
    [array release];
    [dataTableView reloadData];
}


- (void)clickAreaButton:(id)sender
{
    UIButton *currentButton = (UIButton *)sender;
    
    NSArray *list = [self buttonList];
    for (UIButton *button in list) {
        if (currentButton.tag != button.tag) {
            button.selected = NO;
        }
    }
    
    currentButton.selected = !currentButton.selected;
    
    if (currentButton.selected) {
        int selectedRegionId = [self selectedRegionIdBySelectedButton:currentButton];
        [self filterByRegionId:selectedRegionId];
    } else {
        self.dataList = _allDataList;
        [dataTableView reloadData];
    }
}

@end
