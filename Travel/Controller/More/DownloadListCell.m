//
//  CityListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DownloadListCell.h"
#import "AppManager.h"
#import "LocaleUtils.h"
#import "ImageName.h"
#import "PackageManager.h"
#import "PPDebug.h"
#import "AppConstants.h"
#import "AppUtils.h"
#import "Reachability.h"
#import "SSZipArchive.h"
#import "TKAlertCenter.h"

@implementation DownloadListCell
@synthesize cityNameLabel;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize dataSizeLabel;
@synthesize updateProgressView;
@synthesize updatePercentLabel;
@synthesize pauseBtn;
@synthesize activityIndicator;

@synthesize city = _city;
@synthesize downloadListCellDelegate = _downloadListCellDelegate;

+ (NSString*)getCellIdentifier
{
    return @"DownloadListCell";
}

+ (CGFloat)getCellHeight
{
    return 54.0f;
}

- (void)dealloc {
    [_city release];
    
    [cityNameLabel release];
    [updateButton release];
    [deleteButton release];
    [dataSizeLabel release];
    
    [updateProgressView release];
    [pauseBtn release];
    [activityIndicator release];
    [updatePercentLabel release];
    [_cancelButton release];
    [super dealloc];
}

- (void)setCellData:(City*)city
{
    self.city = city;
    
    self.cityNameLabel.text = [NSString stringWithFormat:NSLS(@"%@"),_city.cityName];
        
    [self setApperance:city];
}

- (void)setApperance:(City*)city
{
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:city.cityId];
    
    switch (localCity.updateStatus) {
        case UPDATING:   
            [self setUpdatingAppearance];
            [self setUpdateProgress:localCity.downloadProgress];
            break;
        case UPDATE_PAUSE:
            [self setUpdatePauseAppearance];
            [self setUpdateProgress:localCity.downloadProgress];
            break;
            
        default:
            [self setDefaultAppearance];          
            break;
    }
    
}

- (void)setDefaultAppearance
{
    dataSizeLabel.hidden = NO;
    self.dataSizeLabel.text = [self getCityDataSizeString];
    
    if ([_city.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:_city.cityId]]) {
        updateButton.hidden = YES;
    }
    else {
        updateButton.hidden = NO;
        _cancelButton.hidden = YES;
    }
    
    updateProgressView.hidden = YES;
    updatePercentLabel.hidden = YES;
    pauseBtn.hidden = YES;
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;   
}

- (void)setUpdatingAppearance
{
    dataSizeLabel.hidden = YES;
    updateButton.hidden = YES;
     _cancelButton.hidden = NO;
    
    updateProgressView.hidden = NO;
    updatePercentLabel.hidden = NO;
    
    pauseBtn.hidden = NO;
    
    pauseBtn.selected = NO;
    activityIndicator.hidden = NO;  
    [activityIndicator startAnimating];
}

- (void)setUpdatePauseAppearance
{
    dataSizeLabel.hidden = YES;
    updateButton.hidden = YES;
     _cancelButton.hidden = NO;
    
    updateProgressView.hidden = NO;
    updatePercentLabel.hidden = NO;
    
    pauseBtn.hidden = NO;
    
    pauseBtn.selected = YES;
    activityIndicator.hidden = YES; 
    [activityIndicator stopAnimating];
}
                                       
- (void)setUpdateProgress:(float)progress
{
    updateProgressView.progress = progress;
    float persent = progress*100;
    updatePercentLabel.text = [NSString stringWithFormat:@"%2.f%%", persent];
}

- (NSString*)getCityDataSizeString
{
    return [NSString stringWithFormat:@"%0.2fM", _city.dataSize/1024.0/1024.0];
}

#pragma mark -
#pragma mark: implementation of button action.

- (IBAction)clickDeleteBtn:(id)sender {    
    [AppUtils showDeleteCityDataAlertViewWithTag:ALERT_DELETE_CITY delegate:self];
}

- (IBAction)clickUpdateBtn:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
        [AppUtils showAlertViewWhenUsingCellNetworkForDownloadWithTag:ALERT_USING_CELL_NEWORK delegate:self];
    }
    else {
        [self updateCity];
    }
}

- (IBAction)clickPauseBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self pause];
    }
    else {
        //TODO, resume download request
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
            [AppUtils showAlertViewWhenUsingCellNetworkForDownloadWithTag:ALERT_USING_CELL_NEWORK delegate:self];
        }
        else {
            [self updateCity];
        }
    }
}

- (IBAction)clickCancelButton:(id)sender {
    UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"是否取消更新" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil] autorelease];
    alert.tag = ALERT_CANCEL_UPDATE_CITT;
    [alert show];
}


#pragma mark -
#pragma mark: implementation of alert view delegate.

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_DELETE_CITY:
            if (buttonIndex == 1) {
                [self deleteCity];
            }
            break;
            
        case ALERT_USING_CELL_NEWORK:
            if (buttonIndex == 1) {
                [self updateCity];
            }
            break;
        case ALERT_CANCEL_UPDATE_CITT:
            if (buttonIndex == 0) {
                [[CityDownloadService defaultService] cancel:_city];
                self.cancelButton.hidden = YES;
                self.updateButton.hidden = NO;
                
                if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didCancelUpdate:)]) {
                    [_downloadListCellDelegate didCancelUpdate:_city];
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark: implementation of functions.

- (void)deleteCity
{           
    // Delete city data.
    [AppUtils deleteCityData:_city.cityId];
    // Remove local city info.
    [[LocalCityManager defaultManager] removeLocalCity:_city.cityId];
    
    // Call delegete method to do some addition work.
    if ([_downloadListCellDelegate respondsToSelector:@selector(didDeleteCity:)]) {
        if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didDeleteCity:)]) {
            [_downloadListCellDelegate didDeleteCity:_city];
            
        }
    }
}

- (void)updateCity
{
    // Update city data.
    [[CityDownloadService defaultService] update:_city delegate:self];
    
    // Call delegate method to do some addition work.
    if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didStartUpdate:)]) {
        [_downloadListCellDelegate didStartUpdate:_city];
    } 
}

- (void)pause
{
    // Pause update request
    [[CityDownloadService defaultService] pause:_city];
    
    if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didPauseUpdate:)]) {
        [_downloadListCellDelegate didPauseUpdate:_city];
    }
}

- (void)didFinishUpdate:(City*)city
{
    if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didFinishUpdate:)]) {
        [_downloadListCellDelegate didFinishUpdate:city];
    }   
}

- (void)didFailUpdate:(City*)city error:(NSError*)error
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@""];
    
    if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didFailUpdate:error:)]) {
        [_downloadListCellDelegate didFailUpdate:city error:error];
    }
}

@end
