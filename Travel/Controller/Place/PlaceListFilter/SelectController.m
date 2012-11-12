//
//  SelectController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SelectController.h"
#import "PPTableViewCell.h"
#import "PPDebug.h"
#import "AppManager.h"
#import "UIImageUtil.h"
#import "PlaceUtils.h"
#import "Item.h"
#import "AppConstants.h"
#import "FontSize.h"
@interface SelectController ()

@property (copy, nonatomic) NSString *navigationTitle;
@property (retain, nonatomic) NSArray *itemList;
@property (retain, nonatomic) NSMutableArray *selectedItemIds;
@property (retain, nonatomic) NSMutableArray *selectedItemIdsBeforConfirm;

@property (assign, nonatomic) BOOL multiOptions;
@property (assign, nonatomic) BOOL needConfirm;
@property (assign, nonatomic) BOOL needShowCount;

@end

@implementation SelectController

@synthesize navigationTitle = _navigationTitle;
@synthesize itemList = _itemList;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize selectedItemIdsBeforConfirm = _selectedItemIdsBeforConfirm;

@synthesize multiOptions = _multiOptinos;
@synthesize needConfirm = _needConfirm;
@synthesize needShowCount = _needShowCount;

@synthesize tableView;
@synthesize delegate;
@synthesize cellTextColor = _cellTextColor;

- (void)dealloc {
    [_navigationTitle release];
    [_itemList release];
    [_selectedItemIds release];
    [_selectedItemIdsBeforConfirm release];
    
    [tableView release];
    [_cellTextColor release];
    [super dealloc];
}

- (SelectController*)initWithTitle:(NSString *)title
                          itemList:(NSArray *)itemList
                   selectedItemIds:(NSMutableArray *)selectedItemIds
                      multiOptions:(BOOL)multiOptions
                       needConfirm:(BOOL)needConfirm
                     needShowCount:(BOOL)needShowCount;
{
    self = [super init];
    if (self) {
        self.navigationTitle = title;
        self.itemList = itemList;
        
        self.selectedItemIds = selectedItemIds;
        self.selectedItemIdsBeforConfirm = [NSMutableArray arrayWithArray:selectedItemIds];
        
        self.multiOptions = multiOptions;
        self.needConfirm = needConfirm;
        self.needShowCount = needShowCount;
    }
    
    return self;
}

- (void)viewDidLoad
{        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    if (_needConfirm) {
        [self setNavigationRightButton:NSLS(@"确定") 
                              fontSize:FONT_SIZE
                             imageName:@"topmenu_btn_right.png" 
                                action:@selector(clickFinish:)];
    }
    
    [self setTitle:_navigationTitle];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 36;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_itemList count];			// default implementation
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    int row = [indexPath row];	
	int count = [_itemList count];
	if (row >= count){
		PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return nil;
	}
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForCategory"] autorelease];
    
    Item *item = [_itemList objectAtIndex:row];

    if (_needShowCount) {
        NSString *text = [NSString stringWithFormat:@"%@ (%d)", item.itemName, item.count];
        [[cell textLabel] setText:text];
    }else {
        NSString *text = [NSString stringWithFormat:@"%@", item.itemName];
        [[cell textLabel] setText:text];
    }
    
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (_cellTextColor) {
        cell.textLabel.textColor = _cellTextColor;
    }
    
    if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:item.itemId]) {
        [cell.imageView setImage:[self getSelectedImage]];
        cell.backgroundView = [self getBackgoundImageView:row];
        if (!_multiOptinos) {
            cell.accessoryView =[self getCheckedImageView];
        }
    }else {
        [cell.imageView setImage:[self getUnselectedImage]];
        cell.accessoryView = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;	
}

- (UIImageView*)getCheckedImageView
{
    CGRect rect = CGRectMake(0, 0, 36, 36);
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    [imageView setImage:[UIImage imageNamed:@"select_btn_1.png"]];
    
    return  imageView;
}

- (UIView*)getBackgoundImageView:(int)row
{
    UIImageView *view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)] autorelease];
  
    if (row == 0) {
        [view setImage:[UIImage imageNamed:@"select_bg_top.png"]];
    }
    else if(row == [_itemList count]-1){
        [view setImage:[UIImage imageNamed:@"select_bg_down.png"]];
    }
    else {
        [view setImage:[UIImage strectchableImageName:@"select_bg_center.png"]];
    }
    
    return view;
}

- (UIImage*)getUnselectedImage
{
    return _multiOptinos ? [UIImage imageNamed:@"no_s.png"] : [UIImage imageNamed:@"radio_1.png"];
}

- (UIImage*)getSelectedImage
{
    return _multiOptinos ? [UIImage imageNamed:@"yes_s.png"] : [UIImage imageNamed:@"radio_2.png"];
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [_itemList objectAtIndex:indexPath.row];

    if(self.multiOptions == YES){          
        if (item.itemId == ALL_CATEGORY) {
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:item.itemId]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:item.itemId]];
            }else {
                [_selectedItemIdsBeforConfirm removeAllObjects];
                [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
            }
        }else {
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:ALL_CATEGORY]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:ALL_CATEGORY]];
            }
            
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:item.itemId]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:item.itemId]];
            }else {
                [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
            }
        }
        
        [tableView1 reloadData];
        
    } else {
        [_selectedItemIdsBeforConfirm removeAllObjects];
        [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:item.itemId]];
        
        [tableView1 reloadData];
    }
    
    if (!_needConfirm) {
        [self.navigationController popViewControllerAnimated:YES];
        [self copyItemIdsForm:_selectedItemIdsBeforConfirm To:_selectedItemIds];
        if (delegate && [delegate respondsToSelector:@selector(didSelectFinish:)]) {
            [delegate didSelectFinish:_selectedItemIdsBeforConfirm];
        }
    }
}

- (void)clickFinish:(id)sender
{
    if ([_selectedItemIdsBeforConfirm count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:NSLS(@"您还没有进行选择！") delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        [self copyItemIdsForm:_selectedItemIdsBeforConfirm To:_selectedItemIds];
        if (delegate && [delegate respondsToSelector:@selector(didSelectFinish:)]) {
            [delegate didSelectFinish:_selectedItemIdsBeforConfirm];
        }
    }
}

- (void)copyItemIdsForm:(NSMutableArray *)itemIdsScr To:(NSMutableArray *)itemIdsDes
{
    [itemIdsDes removeAllObjects];
    for (NSNumber *itemId in itemIdsScr) {
        [itemIdsDes addObject:itemId];
    }
}

- (BOOL)isSelectedItemIds:(NSArray *)selectedItemIds containItemId:(int)itemId
{
    for (NSNumber *selectedItemId in selectedItemIds) {
        if ([selectedItemId intValue] == itemId) {
            return YES;
        }
    }
    
    return NO;
}


@end
