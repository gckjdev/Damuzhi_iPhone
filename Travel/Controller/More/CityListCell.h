//
//  DownloadListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "App.pb.h"
#import "AppService.h"

@protocol CityListCellDelegate <NSObject>

@optional
- (void)didSelectCurrendCity:(City*)city;
- (void)didStartDownload:(City*)city;
- (void)didCancelDownload:(City*)city;
- (void)didPauseDownload:(City*)city;
- (void)didClickOnlineBtn:(City*)city;
- (void)didFinishDownload:(City*)city;
- (void)didFailDownload:(City*)city error:(NSError*)error;
@end

@interface CityListCell : PPTableViewCell<PPTableViewCellProtocol, LocalCityDelegate>
{
    City *_city;
}

@property (retain, nonatomic) City *city;
@property (assign, nonatomic) id<AppManagerProtocol> appManagerDelegate;
@property (assign, nonatomic) id<CityListCellDelegate> cityListCellDelegate;

@property (retain, nonatomic) IBOutlet UIButton *selectCurrentCityBtn;
@property (retain, nonatomic) IBOutlet UILabel *dataSizeLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgressView;
@property (retain, nonatomic) IBOutlet UILabel *downloadPersentLabel;
@property (retain, nonatomic) IBOutlet UIButton *pauseDownloadBtn;
@property (retain, nonatomic) IBOutlet UIButton *downloadButton;
@property (retain, nonatomic) IBOutlet UIButton *onlineButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelDownloadBtn;
@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *downloadDoneLabel;
@property (retain, nonatomic) IBOutlet UIButton *moreDetailBtn;

- (void)setCellData:(City*)city;

@end
