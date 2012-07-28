//
//  SelectCityController.h
//  Travel
//
//  Created by haodong qiu on 12年7月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewController.h"
#import "CommonRouteListFilter.h"

@class Item;
@protocol SelectCityDelegate <NSObject>
@optional
- (void)didSelectCity:(NSArray *)selectedItemList;
@end


@interface SelectCityController : PPTableViewController <UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *regionTableView;

- (id)initWithTitle:(NSString *)title 
         regionList:(NSArray *)regionList
           itemList:(NSArray *)itemList
 selectedItemIdList:(NSMutableArray *)selectedItemIdList
               type:(typeCity)typeCity
       multiOptions:(BOOL)multiOptions
           delegate:(id<SelectCityDelegate>)delegate;

@end
