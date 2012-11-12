//
//  CityListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "App.pb.h"
#import "CityDownloadService.h"

@protocol  DownloadListCellDelegate <NSObject>
@optional

- (void)didDeleteCity:(City*)city;
- (void)didStartUpdate:(City*)city;
- (void)didCancelUpdate:(City*)city;
- (void)didPauseUpdate:(City*)city;
- (void)didFinishUpdate:(City*)city;
- (void)didFailUpdate:(City*)city error:(NSError*)error;
@end

@interface DownloadListCell : PPTableViewCell<PPTableViewCellProtocol, LocalCityDelegate>

@property (retain, nonatomic) City *city;
@property (assign, nonatomic) id<DownloadListCellDelegate> downloadListCellDelegate;

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *updateButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *dataSizeLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *updateProgressView;
@property (retain, nonatomic) IBOutlet UILabel *updatePercentLabel;
@property (retain, nonatomic) IBOutlet UIButton *pauseBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

- (void)setCellData:(City*)city;

@end
