//
//  CityManagementController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "CityListCell.h"
#import "DownloadListCell.h"
#import "AppService.h"
#import "CityDownloadService.h"


@interface CityManagementController : PPTableViewController <CityListCellDelegate, DownloadListCellDelegate, CityDownloadServiceDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    UITableView *_downloadTableView;
    NSArray *_downloadList;
}

@property (assign ,nonatomic) id<AppManagerProtocol> delegate;

@property (nonatomic, retain) NSArray *downloadList;
@property (nonatomic, retain) IBOutlet UITableView *downloadTableView;


@property (retain, nonatomic) IBOutlet UILabel *promptLabel;

@property (retain, nonatomic) IBOutlet UISearchBar *citySearchBar;

@property (retain, nonatomic) UIButton *cityListBtn;
@property (retain, nonatomic) UIButton *downloadListBtn;
@property (retain, nonatomic) IBOutlet UIImageView *cityListBackgroundImageView;



+ (CityManagementController*)getInstance;
- (void)clickDownloadListButton:(id)sender;

@end
