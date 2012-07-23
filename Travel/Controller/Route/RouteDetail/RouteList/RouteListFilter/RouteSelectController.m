//
//  RouteSelectController.m
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteSelectController.h"
#import "TravelNetworkConstants.h"
#import "AppManager.h"
#import "RouteSelectCell.h"

#define SECTION_TITLE_PRICE_RANK NSLS(@"价格区间")
#define SECTION_TITLE_DAYS_RANGE NSLS(@"出行天数")
#define SECTION_TITLE_ROUTE_THEME NSLS(@"路线主题")

#define FONT_SECTION_TITLE [UIFont systemFontOfSize:14]

@interface RouteSelectController ()

@property (assign, nonatomic) int routeType;
@property (retain, nonatomic) NSMutableDictionary *sectionTitleDic;
@property (retain, nonatomic) NSMutableDictionary *itemListInfoDic;
@property (retain, nonatomic) NSMutableDictionary *selectedItemListInfoDic;
@property (retain, nonatomic) NSMutableDictionary *selectedItemListInfoDicBeforeComfirm;

@property (retain, nonatomic) RouteSelectedItemIds *selectedItemIds;


@end

@implementation RouteSelectController

@synthesize aDelegate = _aDelegate;

@synthesize routeType = _routeType;
@synthesize sectionTitleDic = _sectionTitleDic;
@synthesize itemListInfoDic = _itemListInfoDic;
@synthesize selectedItemListInfoDic = _selectedItemListInfoDic;
@synthesize selectedItemListInfoDicBeforeComfirm = _selectedItemListInfoDicBeforeComfirm;
@synthesize selectedItemIds = _selectedItemIds;

- (void)dealloc
{    
    [_sectionTitleDic release];
    [_itemListInfoDic release];
    [_selectedItemListInfoDic release];
    [_selectedItemListInfoDicBeforeComfirm release];
    
    [_selectedItemIds release];
    
    [super dealloc];
}

- (id)initWithRouteType:(int)routeType
        selectedItemIds:(RouteSelectedItemIds *)selectedItemIds
{
    if (self = [super init]) {
        self.routeType = routeType;
        self.selectedItemIds = selectedItemIds;
        self.sectionTitleDic = [NSMutableDictionary dictionary];
        self.itemListInfoDic = [NSMutableDictionary dictionary];
        self.selectedItemListInfoDic = [NSMutableDictionary dictionary];
        self.selectedItemListInfoDicBeforeComfirm = [NSMutableDictionary dictionary];
    }
    
    return self;
}
    

- (void)viewDidLoad
{
    self.title = NSLS(@"筛选");
    [self setBackgroundImageName:@"all_page_bg2.jpg"];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Init UI Interface
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickFinish:)];
    
    NSArray *priceRankItemList = [[AppManager defaultManager] buildRoutePriceRankItemList];
    NSArray *daysRangeItemList = [[AppManager defaultManager] buildDaysRangeItemList];
    NSArray *routeThemeItemList = [[AppManager defaultManager] getRouteThemeItemList];
    
    int row = 0;
    if (_routeType == OBJECT_LIST_ROUTE_PACKAGE_TOUR) {
        [self.sectionTitleDic setObject:SECTION_TITLE_PRICE_RANK forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_DAYS_RANGE forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_ROUTE_THEME forKey:[NSNumber numberWithInt:row++]];
        
        [self.itemListInfoDic setObject:priceRankItemList forKey:SECTION_TITLE_PRICE_RANK];
        [self.itemListInfoDic setObject:daysRangeItemList forKey:SECTION_TITLE_DAYS_RANGE];
        [self.itemListInfoDic setObject:routeThemeItemList forKey:SECTION_TITLE_ROUTE_THEME];
        
        [self.selectedItemListInfoDic setObject:_selectedItemIds.priceRankItemIds 
                                        forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDic setObject:_selectedItemIds.daysRangeItemIds
                                        forKey:SECTION_TITLE_DAYS_RANGE];
        [self.selectedItemListInfoDic setObject:_selectedItemIds.themeIds 
                                        forKey:SECTION_TITLE_ROUTE_THEME];
        
        [self.selectedItemListInfoDicBeforeComfirm setObject:[NSMutableArray arrayWithArray:_selectedItemIds.priceRankItemIds] forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDicBeforeComfirm setObject:[NSMutableArray arrayWithArray:_selectedItemIds.daysRangeItemIds] forKey:SECTION_TITLE_DAYS_RANGE];
        [self.selectedItemListInfoDicBeforeComfirm setObject:[NSMutableArray arrayWithArray:_selectedItemIds.themeIds] forKey:SECTION_TITLE_ROUTE_THEME];
        
    }else if (_routeType == OBJECT_LIST_ROUTE_UNPACKAGE_TOUR) {
        [self.sectionTitleDic setObject:SECTION_TITLE_PRICE_RANK forKey:[NSNumber numberWithInt:row++]];
        [self.sectionTitleDic setObject:SECTION_TITLE_DAYS_RANGE forKey:[NSNumber numberWithInt:row++]];
        
        [self.itemListInfoDic setObject:priceRankItemList forKey:SECTION_TITLE_PRICE_RANK];
        [self.itemListInfoDic setObject:daysRangeItemList forKey:SECTION_TITLE_DAYS_RANGE];
        
        [self.selectedItemListInfoDic setObject:_selectedItemIds.priceRankItemIds 
                                        forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDic setObject:_selectedItemIds.daysRangeItemIds
                                        forKey:SECTION_TITLE_DAYS_RANGE];
        
        [self.selectedItemListInfoDicBeforeComfirm setObject:[NSMutableArray arrayWithArray:_selectedItemIds.priceRankItemIds] forKey:SECTION_TITLE_PRICE_RANK];
        [self.selectedItemListInfoDicBeforeComfirm setObject:[NSMutableArray arrayWithArray:_selectedItemIds.daysRangeItemIds] forKey:SECTION_TITLE_DAYS_RANGE];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark: Implementation for UITableView datasource.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[RouteSelectCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteSelectCell createCell:self];		
    }
    
    int row = [indexPath row];	
    int count = 1;
    if (row >= count){
        PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
        return cell;
    }
    
    NSArray *itemList = [self itemListForSection:indexPath.section];
    NSMutableArray *selectedItemIds = [self selectedItemIdsBeforeComfirmForSection:indexPath.section];
    
    RouteSelectCell* routeSelectCell = (RouteSelectCell*)cell;
    [routeSelectCell setCellData:itemList
                 selectedItemIds:selectedItemIds
                    multiOptions:YES 
                     needConfirm:YES 
                   needShowCount:NO];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitleDic count];
}

#pragma mark -
#pragma mark: Implementation for UITableView delegate.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemList = [self itemListForSection:indexPath.section];
    int count = [itemList count];
    int rows = (count + NUM_OF_SELECT_BUTTON_IN_LINE - 1) / NUM_OF_SELECT_BUTTON_IN_LINE;
    
    return rows * HEIGHT_SELECT_BUTTON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    label.font = FONT_SECTION_TITLE;
    [view addSubview:label];
    
    return view;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}

#pragma mark -
#pragma mark: Pravite methods.

- (NSArray *)itemListForSection:(NSInteger)section
{
    NSString *title = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    
    return [_itemListInfoDic objectForKey:title];
}

- (NSMutableArray *)selectedItemIdsForSection:(NSInteger)section
{
    NSString *title = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    
    return [_selectedItemListInfoDic objectForKey:title];
}

- (NSMutableArray *)selectedItemIdsBeforeComfirmForSection:(NSInteger)section
{
    NSString *title = [_sectionTitleDic objectForKey:[NSNumber numberWithInt:section]];
    
    return [_selectedItemListInfoDicBeforeComfirm objectForKey:title];
}

- (void)clickFinish:(id)sender
{
    NSDictionary *dic = [self checkSelectItemList];
    for (NSString *key in [dic allKeys]) {
        if ([[dic valueForKey:key] boolValue] == NO) {
            NSString *message = [NSString stringWithFormat:NSLS(@"亲，您还没有选择%@哦！"), key];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:message delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            return;
        }
    }


    [self copyAllSelectedItemIds];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([_aDelegate respondsToSelector:@selector(didClickFinish)]) {
        [_aDelegate didClickFinish];
    }
}

- (NSDictionary *)checkSelectItemList
{
    NSDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *keys = [[self selectedItemListInfoDicBeforeComfirm] allKeys];
    for (NSString *key in keys) {
        NSArray *selectedItemList = [_selectedItemListInfoDicBeforeComfirm objectForKey:key];
        if ([selectedItemList count] == 0) {
            [dic setValue:[NSNumber numberWithBool:NO] forKey:key]; 
        }else {
            [dic setValue:[NSNumber numberWithBool:YES] forKey:key];
        }
    }
    
    return dic;
}

- (void)copyAllSelectedItemIds
{
    for (NSString *key in [_selectedItemListInfoDicBeforeComfirm allKeys]) {
        NSMutableArray *array1 = [_selectedItemListInfoDicBeforeComfirm objectForKey:key];
        NSMutableArray *array2 = [_selectedItemListInfoDic objectForKey:key];
        [self copyItemIdsFrom:array1 To:array2];
    }
    
}

- (void)copyItemIdsFrom:(NSMutableArray *)itemIdsScr To:(NSMutableArray *)itemIdsDes
{
    [itemIdsDes removeAllObjects];
    for (NSNumber *itemId in itemIdsScr) {
        [itemIdsDes addObject:itemId];
    }
}

@end
