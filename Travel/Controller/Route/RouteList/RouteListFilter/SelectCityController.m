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
#import "FontSize.h"
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
@property (retain, nonatomic) NSMutableArray *regionList;
@property (assign, nonatomic) int selectedRegionRow;

@end


#define TAG_REGION_TABLEVIEW    12072701
#define TAG_DATA_TABLEVIEW      12072702


@implementation SelectCityController

@synthesize navigationTitle = _navigationTitle;
@synthesize searchBar = _searchBar;
@synthesize regionTableView = _regionTableView;
@synthesize delegate = _delegate;
@synthesize allDataList = _allDataList;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize selectedItemIdsBeforConfirm = _selectedItemIdsBeforConfirm;
@synthesize regionList = _regionList;
@synthesize selectedRegionRow = _selectedRegionRow;

- (void)dealloc
{
    PPRelease(_navigationTitle);
    PPRelease(_allDataList);
    PPRelease(_searchBar);
    PPRelease(_selectedItemIds);
    PPRelease(_selectedItemIdsBeforConfirm);
    PPRelease(_regionList);
    [_regionTableView release];
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
        self.regionList = [NSMutableArray arrayWithArray:regionList];
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


- (NSArray *)sortsCityList:(NSArray *)sourceList
{
    NSMutableArray *selectedList = [[NSMutableArray alloc] init];
    NSMutableArray *noSelectedList = [[NSMutableArray alloc] init];
    
    for (Item *item in sourceList){
        if (item.itemId == ALL_CATEGORY || [self isSelectedId:item.itemId]) {
            [selectedList addObject:item];
        }else {
            [noSelectedList addObject:item];
        }
    }
    
    NSMutableArray *returnList = [[[NSMutableArray alloc] initWithArray:selectedList] autorelease];
    [returnList addObjectsFromArray:noSelectedList];
    [selectedList release];
    [noSelectedList release];
    
    return returnList;
}

#define WIDTH_REGION_TABLEVIEW  85
#define WIDTH_DATA_TABLEVIEW    235

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_navigationTitle];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    [self setNavigationRightButton:NSLS(@"确定") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickSubmit:)];
    
    self.dataTableView.tag = TAG_DATA_TABLEVIEW;
    self.regionTableView.tag = TAG_REGION_TABLEVIEW;
    
    UIColor *backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.dataTableView.backgroundColor = backgroundColor;
    self.regionTableView.backgroundColor = backgroundColor;
    
    self.allDataList = [self sortsCityList:_allDataList];
    self.dataList = _allDataList;
    
    if (_typeCity == destination) {
        _regionTableView.frame = CGRectMake(_regionTableView.frame.origin.x, _regionTableView.frame.origin.y, WIDTH_REGION_TABLEVIEW, _regionTableView.frame.size.height);
        dataTableView.frame = CGRectMake(WIDTH_REGION_TABLEVIEW, dataTableView.frame.origin.y, WIDTH_DATA_TABLEVIEW, dataTableView.frame.size.height);
        
        _regionTableView.showsVerticalScrollIndicator = NO;
        
        Region_Builder *builder = [[[Region_Builder alloc] init] autorelease];
        [builder setRegionId:ALL_CATEGORY];
        [builder setRegionName:NSLS(@"全部")];
        Region *region = [builder build];
        [_regionList insertObject:region atIndex:0];
        
        [self filterCityByRegionRow:0];
    } else {
        _regionTableView.frame = CGRectMake(_regionTableView.frame.origin.x, _regionTableView.frame.origin.y, 0, _regionTableView.frame.size.height);
        dataTableView.frame = CGRectMake(0, dataTableView.frame.origin.y, dataTableView.frame.size.width, dataTableView.frame.size.height);
    }
}


- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setRegionTableView:nil];
    [super viewDidUnload];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TAG_REGION_TABLEVIEW) {
        if ([_regionList count] > 9) {
            return [_regionList count];
        }else {
            return 9;
        }
    } else {
        return [dataList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_REGION_TABLEVIEW) {
        NSString *regionCell = @"RegionCell";
        UITableViewCell *cell = [_regionTableView dequeueReusableCellWithIdentifier:regionCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:regionCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *lineView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_bg3.png"]] autorelease];
            lineView.frame = CGRectMake(0, 0, 79, 1.5);
            [cell.contentView addSubview:lineView];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        
        if (indexPath.row < [_regionList count]) {
            Region *region = [_regionList objectAtIndex:indexPath.row];
            cell.textLabel.text = region.regionName;
        }else {
            cell.textLabel.text = nil;
        }
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        UIImage *iamge = nil;
        if (indexPath.row == _selectedRegionRow) {
            iamge = [UIImage imageNamed:@"city_left_off.png"];
            cell.textLabel.textColor = [UIColor whiteColor];
        }else {
            iamge = [UIImage imageNamed:@"city_bg2.png"];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        UIImageView* backgroundView = [[[UIImageView alloc] initWithImage:iamge] autorelease];	
        cell.backgroundView = backgroundView;
        
        return cell;
    }
    else {
        NSString *cellIdentifier = @"CityCell";
        UITableViewCell *cell = [dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.imageView.image = [UIImage imageNamed:@"yes_s.png"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"no_s.png"];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TAG_REGION_TABLEVIEW) {
        if (indexPath.row < [_regionList count]) {
            [self filterCityByRegionRow:indexPath.row];
        }
    } else if (tableView.tag == TAG_DATA_TABLEVIEW){
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
    
    [self showNoSelectRegion];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:NSLS(@"您还没有进行选择！") delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
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


- (void)showNoSelectRegion
{
    _selectedRegionRow = -1;
    [_regionTableView reloadData];
}


- (void)filterCityByRegionRow:(int)row;
{
    self.allDataList = [self sortsCityList:_allDataList];
    
    _selectedRegionRow = row;
    [_regionTableView reloadData];
    
    Region *region = [_regionList objectAtIndex:_selectedRegionRow];
    
    if (region.regionId == ALL_CATEGORY) {
        self.dataList = _allDataList;
    }else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(Item *item in self.allDataList){
            int cityRegionId = [[AppManager defaultManager] getRegionIdByCityId:item.itemId];
            if (cityRegionId == region.regionId) {
                [array addObject:item];
            }
        }
        
        self.dataList = array;
        [array release];
    }

    [dataTableView reloadData];
}


@end
