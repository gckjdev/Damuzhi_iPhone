//
//  SelectController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"

@protocol SelectControllerDelegate <NSObject>
@optional
- (void)didSelectFinish:(NSArray*)selectedItems;

@end

@interface SelectController : PPTableViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) id<SelectControllerDelegate> delegate;
@property (retain, nonatomic) UIColor *cellTextColor;

- (SelectController*)initWithTitle:(NSString *)title
                          itemList:(NSArray *)itemList
                   selectedItemIds:(NSMutableArray *)selectedItemIds
                      multiOptions:(BOOL)multiOptions
                       needConfirm:(BOOL)needConfirm
                     needShowCount:(BOOL)needShowCount;
@end
