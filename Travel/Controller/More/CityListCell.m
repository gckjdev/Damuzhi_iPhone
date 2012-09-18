//
//  DownloadListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityListCell.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "LocalCityManager.h"
#import "LocaleUtils.h"
#import "Reachability.h"
#import "CityDownloadService.h"
#import "SSZipArchive.h"
#import "AppConstants.h"
#import "PPViewController.h"
@implementation CityListCell

@synthesize city = _city;
@synthesize appManagerDelegate = _appManagerDelegate;
@synthesize cityListCellDelegate = _cityListCellDelegate;
@synthesize selectCurrentCityBtn;
@synthesize dataSizeLabel;
@synthesize downloadProgressView;
@synthesize downloadPersentLabel;
@synthesize pauseDownloadBtn;
@synthesize downloadButton;
@synthesize onlineButton;
@synthesize cancelDownloadBtn;
@synthesize cityNameLabel;
@synthesize downloadDoneLabel;
@synthesize moreDetailBtn;

#pragma mark -
#pragma mark: 
- (void)dealloc {
    [_city release];
    
    [downloadProgressView release];
    [downloadButton release];
    [onlineButton release];
    [cityNameLabel release];
    [dataSizeLabel release];
    [downloadPersentLabel release];
    [downloadDoneLabel release];
    [pauseDownloadBtn release];
    [cancelDownloadBtn release];
    [moreDetailBtn release];
    [selectCurrentCityBtn release];
    [super dealloc];
}

#pragma mark -
#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"CityListCell";
}

+ (CGFloat)getCellHeight
{
    return 54.0f;
}


#pragma mark -
#pragma mark: Customize the appearance of cell.
- (void)setCellData:(City*)city
{
    self.city = city;    
    self.selectCurrentCityBtn.selected = ([[AppManager defaultManager] getCurrentCityId] == _city.cityId); 
    self.cityNameLabel.text = [NSString stringWithFormat:NSLS(@"%@"),_city.cityName];
    self.cityNameLabel.textColor = ([[AppManager defaultManager] getCurrentCityId] == _city.cityId)?[UIColor redColor]:[UIColor darkGrayColor];
    self.dataSizeLabel.text = [self getCityDataSizeString];
    self.downloadDoneLabel.textColor = [UIColor darkGrayColor];
    
    [self setCellAppearance];
    return;
}

- (NSString*)getCityDataSizeString
{
    return [NSString stringWithFormat:@"%0.2fM", _city.dataSize/1024.0/1024.0];
}

- (void)setCellAppearance
{
    if ([AppUtils hasLocalCityData:_city.cityId]) {
        [self setDownloadSuccessAppearance];
    }
    else {
        LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:_city.cityId];
        [self setDownloadAppearance:localCity];
    }
}

- (void)setDefaultAppearance
{
    dataSizeLabel.hidden = NO;
    downloadProgressView.hidden = YES;
    downloadPersentLabel.hidden = YES;
    pauseDownloadBtn.hidden = YES;
    
    if (_city.dataSize == 0) {
        downloadButton.hidden = YES;
    }
    else {
        downloadButton.hidden = NO;
    }
    cancelDownloadBtn.hidden = YES;
    onlineButton.hidden = NO;
    
    downloadDoneLabel.hidden = YES;
    moreDetailBtn.hidden = YES;
}

- (void)setDownloadAppearance:(LocalCity*)localCity
{
    switch (localCity.downloadStatus) {
        case DOWNLOADING:
            [self setDownloadingAppearance];
            [self setDownloadProgress:localCity.downloadProgress];
            break;
            
        case DOWNLOAD_PAUSE:
            [self setDownloadPauseAppearance];
            [self setDownloadProgress:localCity.downloadProgress];
            break;
            
        case DOWNLOAD_SUCCEED:
            [self setUnzipingAppearance];
            break;
            
        case DOWNLOAD_FAILED:
            [self setDefaultAppearance];
            break;
            
        default:
            [self setDefaultAppearance];
            break;
    }
}

- (void)setDownloadProgress:(float)downloadProgress
{
    downloadProgressView.progress = downloadProgress;
    int persent = downloadProgress*100.0;
//    PPDebug(@"text progress = %@", [NSString stringWithFormat:@"%d%%", persent]);
    downloadPersentLabel.text = [NSString stringWithFormat:@"%d%%", persent];
}

- (void)setDownloadingAppearance
{
    dataSizeLabel.hidden = YES;
    downloadProgressView.hidden = NO;
    downloadPersentLabel.hidden = NO;
    pauseDownloadBtn.hidden = NO;
    
    downloadButton.hidden = YES;
    cancelDownloadBtn.hidden = NO;
    onlineButton.hidden = YES;
    
    downloadDoneLabel.hidden = YES;
    moreDetailBtn.hidden = YES;
    
    pauseDownloadBtn.selected = NO;
}

- (void)setDownloadPauseAppearance
{
    dataSizeLabel.hidden = YES;
    downloadProgressView.hidden = NO;
    downloadPersentLabel.hidden = NO;
    pauseDownloadBtn.hidden = YES;
    
    downloadButton.hidden = NO;
    downloadButton.selected = YES;
    cancelDownloadBtn.hidden = NO;
    onlineButton.hidden = YES;
    
    downloadDoneLabel.hidden = YES;
    moreDetailBtn.hidden = YES;
    
    pauseDownloadBtn.selected = YES;
}

- (void)setDownloadSuccessAppearance
{
    dataSizeLabel.hidden = NO;
    downloadProgressView.hidden = YES;
    downloadPersentLabel.hidden = YES;
    pauseDownloadBtn.hidden = YES;
    
    downloadButton.hidden = YES;
    cancelDownloadBtn.hidden = YES;
    onlineButton.hidden = YES;
    
    downloadDoneLabel.hidden = NO;
    downloadDoneLabel.text = NSLS(@"已下载");
    moreDetailBtn.hidden = NO;
}

- (void)setUnzipingAppearance
{
    dataSizeLabel.hidden = NO;
    downloadProgressView.hidden = YES;
    downloadPersentLabel.hidden = YES;
    pauseDownloadBtn.hidden = YES;
    
    downloadButton.hidden = YES;
    cancelDownloadBtn.hidden = YES;
    onlineButton.hidden = YES;
    
    downloadDoneLabel.hidden = NO;
    downloadDoneLabel.text = NSLS(@"安装中...");
    moreDetailBtn.hidden = YES;
}

#pragma mark -
#pragma mark: Imlementation for buttons event.
- (IBAction)clickDownload:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
        [AppUtils showAlertViewWhenUsingCellNetworkForDownloadWithTag:ALERT_USING_CELL_NEWORK delegate:self];
    }
    else {
        [self download];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_USING_CELL_NEWORK:
            if (buttonIndex == 1) {
                [self download];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)clickPauseBtn:(id)sender {
    PPViewController *pointer = [[[PPViewController alloc]init] autorelease];
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [pointer popupMessage:@"已暂停" title:nil];
        [self pause];
        
    }
    else {
        //TODO, resume download request
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
            // user is using Mobile Network
            [AppUtils showAlertViewWhenUsingCellNetworkForDownloadWithTag:ALERT_USING_CELL_NEWORK delegate:self];
        }
        else {
            [pointer popupMessage:@"开始下载" title:nil];
            [self download];
        }
    }
}

- (void)pause
{
    //TODO, pause download request
    [[CityDownloadService defaultService] pause:_city];
    
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didPauseDownload:)]) {
        [_cityListCellDelegate didPauseDownload:_city];
    }
}

- (void)download
{
    // Download city data.
    [[CityDownloadService defaultService] download:_city delegate:self];
    
    // Call delegate method to do some addition work.
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didStartDownload:)]) {
        [_cityListCellDelegate didStartDownload:_city];
    } 
}

- (IBAction)clickCancel:(id)sender {
    
    
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"是否取消下载" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil] autorelease];
    [alert show];
}

//delegate method
- (void)alertView:(UIAlertView *)alertView1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString * str1 = [alertView1 buttonTitleAtIndex:buttonIndex];
    if ([str1 isEqualToString:@"是"])
    {
        [[CityDownloadService defaultService] cancel:_city];
        self.pauseDownloadBtn.selected = NO;
        downloadButton.selected = NO;
        if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didCancelDownload:)]) {
            [_cityListCellDelegate didCancelDownload:_city];
        } 
    }

}  

- (IBAction)clickOnlineBtn:(id)sender {
    [self selectCurrentCity];
    
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didClickOnlineBtn:)]) {
        [_cityListCellDelegate didClickOnlineBtn:_city];
    }
}

- (IBAction)clickCurrentCityBtn:(id)sender {
    [self selectCurrentCity];
}

- (void)selectCurrentCity
{
    if (_city.cityId == [[AppManager defaultManager] getCurrentCityId]) {
        return;
    }
    
    // Set current cityId.
//    [[AppManager defaultManager] setCurrentCityId:_city.cityId delegate:_appManagerDelegate];
    
    // Call delegate metchod to do some addition work.
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didSelectCurrendCity:)]) {
        [_cityListCellDelegate didSelectCurrendCity:_city];
    }
}

- (void)didFinishDownload:(City*) city
{
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didFinishDownload:)]) {
        [_cityListCellDelegate didFinishDownload:city];
    }    
}

- (void)didFailDownload:(City*)city error:(NSError *)error;
{
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didFailDownload:error:)]) {
        [_cityListCellDelegate didFailDownload:city error:error];
    }
}

@end
