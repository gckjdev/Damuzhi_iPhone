//
//  RouteSelectCell.m
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteSelectCell.h"
#import "Item.h"
#import "AppConstants.h"
#import "LocaleUtils.h"
#import "ImageManager.h"
#import "PPDebug.h"
#import "UIViewUtils.h"

#define WIDTH_SELECT_BUTTON 75
#define EDGE ((320 - WIDTH_SELECT_BUTTON * NUM_OF_SELECT_BUTTON_IN_LINE) / 2)
#define INVALID_ITEM_ID -99
#define FONT_BUTTON_TITLE [UIFont systemFontOfSize:15]


@interface RouteSelectCell ()

@property (retain, nonatomic) NSArray *itemList;
@property (retain, nonatomic) NSMutableArray *selectedItemIds;

@property (assign, nonatomic) BOOL multiOptions;
@property (assign, nonatomic) BOOL needShowCount;

@end

@implementation RouteSelectCell

@synthesize itemList = _itemList;
@synthesize selectedItemIds = _selectedItemIds;

@synthesize multiOptions = _multiOptions;
@synthesize needShowCount = _needShowCount;

+ (NSString *)getCellIdentifier
{
    return NSLS(@"RouteSelectCell");
}

- (void)dealloc
{
    [_itemList release];
    [_selectedItemIds release];
    
    [super dealloc];
}

- (void)setCellData:(NSArray *)itemList
    selectedItemIds:(NSMutableArray *)selectedItemIds
       multiOptions:(BOOL)multiOptions
        needConfirm:(BOOL)needConfirm
      needShowCount:(BOOL)needShowCount
{
    [self removeAllSubviews];
    
    self.itemList = itemList;
    
    self.selectedItemIds = selectedItemIds;
    
    self.multiOptions = multiOptions;
    self.needShowCount = needShowCount;
    
    
    int totalRows = ([itemList count] + NUM_OF_SELECT_BUTTON_IN_LINE - 1) / NUM_OF_SELECT_BUTTON_IN_LINE;
    
    Item *item;
    int itemId;
    NSString *itemName;
    int row;
    int column;
    BOOL enabled;
    CGRect rect;
    BOOL selected;
    
    for (int i = 0; i < totalRows * 4; i ++) {
        if (i < [itemList count]) {
            item = [itemList objectAtIndex:i];
        }else {
            item = nil;
        }
        
        itemId = (item == nil) ? INVALID_ITEM_ID : item.itemId;
        itemName = (item == nil) ? nil : item.itemName;
        enabled = (item == nil) ? NO : YES;
        selected = [self isSelectedItemIds:_selectedItemIds containItemId:itemId] ? YES : NO;

        row = i / NUM_OF_SELECT_BUTTON_IN_LINE;
        column = i % 4;
        rect = CGRectMake(EDGE + column * WIDTH_SELECT_BUTTON, row * HEIGHT_SELECT_BUTTON, WIDTH_SELECT_BUTTON, HEIGHT_SELECT_BUTTON);
        
        UIButton *button = [self buttonWithFrame:rect
                                             tag:itemId
                                           title:itemName 
                                         enabled:enabled 
                                        selected:selected
                                             row:row 
                                          column:column 
                                       totalRows:totalRows];
        
        [self addSubview:button];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                          tag:(int)tag
                        title:(NSString *)title
                      enabled:(BOOL)enabled
                     selected:(BOOL)selected
                          row:(int)row
                       column:(int)column
                    totalRows:(int)totalRows
{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    button.tag = tag;
    button.enabled = enabled;
    button.titleLabel.font = FONT_BUTTON_TITLE;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image1 = [[ImageManager defaultManager] routeClassifyButtonBgImage1WithRow:row 
                                                                                 column:column 
                                                                              totalRows:totalRows 
                                                                            totalColumn:NUM_OF_SELECT_BUTTON_IN_LINE];
    UIImage *image2 = [[ImageManager defaultManager] routeClassifyButtonBgImage2WithRow:row 
                                                                                 column:column 
                                                                              totalRows:totalRows 
                                                                            totalColumn:NUM_OF_SELECT_BUTTON_IN_LINE];
    [button setBackgroundImage:image1 forState:UIControlStateNormal];
    [button setBackgroundImage:image2 forState:UIControlStateSelected];
    
    button.selected = selected;
    
    return button;
}


- (void)clickSelectItem:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int itemId = button.tag;
    button.selected = !button.selected;

    if(self.multiOptions == YES){          
        if (itemId == ALL_CATEGORY) {
            if ([self isSelectedItemIds:_selectedItemIds containItemId:itemId]) {
                [_selectedItemIds removeObject:[NSNumber numberWithInt:itemId]];
            }else {
                [self setButtonsState:_selectedItemIds selected:NO];
                [_selectedItemIds removeAllObjects];
                [_selectedItemIds addObject:[NSNumber numberWithInt:itemId]];
            }
        }else {
            if ([self isSelectedItemIds:_selectedItemIds containItemId:ALL_CATEGORY]) {
                [self setButtonsState:_selectedItemIds selected:NO];
                [_selectedItemIds removeObject:[NSNumber numberWithInt:ALL_CATEGORY]];
            }
            
            if ([self isSelectedItemIds:_selectedItemIds containItemId:itemId]) {
                [_selectedItemIds removeObject:[NSNumber numberWithInt:itemId]];
            }else {
                [_selectedItemIds addObject:[NSNumber numberWithInt:itemId]];
            }
        }
        
    } else {
        [_selectedItemIds removeAllObjects];
        [_selectedItemIds addObject:[NSNumber numberWithInt:itemId]];
    }

}

- (void)setButtonsState:(NSArray *)itemIdList selected:(BOOL)selected
{
    for (NSNumber *itemId in itemIdList) {
        PPDebug(@"itemId = %d", [itemId intValue]);
        UIButton *button =(UIButton *)[self viewWithTag:[itemId intValue]];
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = selected;
        }
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
