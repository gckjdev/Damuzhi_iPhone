//
//  CityManagementController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityManagementController.h"
#import "AppManager.h"
#import "App.pb.h"
#import "LogUtil.h"
#import "ImageName.h"
#import "PackageManager.h"
#import "AppUtils.h"

@implementation CityManagementController 

static CityManagementController *_instance;

@synthesize downloadList = _downloadList;
@synthesize promptLabel = _promptLabel;
@synthesize downloadTableView = _downloadTableView;
@synthesize cityListBtn = _cityListBtn;
@synthesize downloadListBtn = _downloadListBtn;


+ (CityManagementController*)getInstance
{
    if (_instance == nil) {
        _instance = [[CityManagementController alloc] init];
    }
    
    return _instance;
}

- (void)dealloc {
    [_downloadTableView release];
    [_downloadList release];
    [_tipsLabel release];
    [_promptLabel release];
    [_cityListBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:IMAGE_CITY_MAIN_BOTTOM];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.dataList = [[AppManager defaultManager] getCityList];
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    
    UIColor *color = [[UIColor alloc] initWithRed:121.0/255.0 green:164.0/255.0 blue:180.0/255.0 alpha:1]; 
    [self.promptLabel setBackgroundColor:color];
    [color release];
    
    [self addCityManageButtons];
    
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    // Show city list table view.
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
        
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 26)];
    [imageView setImage:[UIImage imageNamed:@"city_ing.png"]];
    dataTableView.tableFooterView = imageView; 
    
    _downloadTableView.tableFooterView = [self labelWithTitle:NSLS(@"您暂未下载离线城市数据")];
}

- (UILabel *)labelWithTitle:(NSString*)title
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, _downloadTableView.frame.size.width, 30)] autorelease];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.hidden = YES;
    return label;
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view
    // e.g. self.myOutlet = nil;
    [self setTipsLabel:nil];
    [self setPromptLabel:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

#define WIDTH_BUTTON  80
#define HEIGHT_BUTTON  30

-(void)addCityManageButtons
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_BUTTON*2, HEIGHT_BUTTON)];
    
    // set position of the two button
    self.cityListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityListBtn.frame = CGRectMake(0, 0, WIDTH_BUTTON, HEIGHT_BUTTON);
    
    self.downloadListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _downloadListBtn.frame = CGRectMake(WIDTH_BUTTON, 0, WIDTH_BUTTON, HEIGHT_BUTTON);
    
    // Customize the appearance 
    [_cityListBtn setTitle:@"城市列表" forState:UIControlStateNormal];
    [_cityListBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_cityListBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];    
    [_cityListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_cityListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_OFF] forState:UIControlStateNormal];
    [_cityListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_LEFT_BTN_ON] forState:UIControlStateSelected];
       
    [_downloadListBtn setTitle:@"下载管理" forState:UIControlStateNormal];
    _downloadListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_downloadListBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_downloadListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_downloadListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_OFF] forState:UIControlStateNormal];
    [_downloadListBtn setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_RIGHT_BTN_ON] forState:UIControlStateSelected];
    
    // Add target to the two buttons
    [_downloadListBtn addTarget:self action:@selector(clickDownloadListButton:) forControlEvents:UIControlEventTouchUpInside];
    [_cityListBtn addTarget:self action:@selector(clickCityListButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:_cityListBtn];
    [buttonView addSubview:_downloadListBtn];
    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    self.navigationItem.titleView = buttonView;
    [buttonView release];
    
//    [barButton release];
}


#pragma mark - 
#pragma mark: Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.downloadTableView) {
        if ([_downloadList count] == 0) {
            _downloadTableView.tableFooterView.hidden = NO;
        }
        else {
            _downloadTableView.tableFooterView.hidden = YES;

        }
        
        return [_downloadList count];
    }
    else{
        return [dataList count];			// default implementation
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (theTableView == self.downloadTableView) {
        cell = [theTableView dequeueReusableCellWithIdentifier:[DownloadListCell getCellIdentifier]];
        if (cell == nil) {
            cell = [DownloadListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Customize the appearance of table view cells at first time
            UIImageView *view = [[UIImageView alloc] init];
            [view setImage:[UIImage imageNamed:IMAGE_CITY_CELL_BG]];
            [cell setBackgroundView:view];
            [view release];
        }
        
        int row = [indexPath row];	
        int count = [_downloadList count];
        
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        DownloadListCell* downloadCell = (DownloadListCell*)cell;
        [downloadCell setCellData:[_downloadList objectAtIndex:row]];
        downloadCell.downloadListCellDelegate = self;
    }
    else {
        cell = [theTableView dequeueReusableCellWithIdentifier:[CityListCell getCellIdentifier]];
        
        if (cell == nil) {
            cell = [CityListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // Customize the appearance of table view cells at first time
            UIImageView *view = [[UIImageView alloc] init];
            [view setImage:[UIImage imageNamed:IMAGE_CITY_CELL_BG]];
            [cell setBackgroundView:view];
            [view release];
        }
        
        // set text label
        int row = [indexPath row];	
        int count = [dataList count];
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        CityListCell* cityCell = (CityListCell*)cell;
        [cityCell setCellData:[self.dataList objectAtIndex:row]];
        cityCell.cityListCellDelegate = self;
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.dataTableView) {
        City *city = [self.dataList objectAtIndex:indexPath.row];
        [[AppManager defaultManager] setCurrentCityId:city.cityId];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self didSelectCurrendCity:[dataList objectAtIndex:indexPath.row]];
    }
}

#pragma mark -
#pragma mark: implementation of buttons event
- (void)clickCityListButton:(id)sender
{
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    // Show city list table view.
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
    
    // reload city list table view
    [self.dataTableView reloadData];
}

- (void)clickDownloadListButton:(id)sender
{
    // Set buttons status.
    _downloadListBtn.selected = YES;
    _cityListBtn.selected = NO;
    
    // Show download management table view.
    dataTableView.hidden = YES;
    _downloadTableView.hidden = NO;
    
    // Reload download table view
    [_downloadTableView reloadData];
}

#pragma mark -
#pragma mark: implementation of Timer
- (void)createTimer
{
    if (timer != nil){
        [timer invalidate];
        timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector: @selector(handleTimer)
                                                userInfo: nil
                                                 repeats: YES];
}

- (void)killTimer
{
    [timer invalidate];
    timer = nil; 
}

- (void)handleTimer
{
    [dataTableView reloadData];
    [_downloadTableView reloadData];
}

#pragma mark -
#pragma mark: implementation of CityListCellDelegate
- (void)didSelectCurrendCity:(City*)city
{
    NSString *message = [NSString stringWithFormat:NSLS(@"已设置查看%@.%@!"), city.countryName, city.cityName];
    [self popupMessage:message title:NSLS(@"提示")];
    [self.dataTableView reloadData];
}

- (void)didStartDownload:(City*)city
{
    [self createTimer];
    [dataTableView reloadData];
}

- (void)didCancelDownload:(City*)city
{
    [self killTimer];
    [dataTableView reloadData];
}

- (void)didPauseDownload:(City*)city
{
    [self killTimer];
    [dataTableView reloadData];
}

- (void)didClickOnlineBtn:(City*)city
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didFinishDownload:(City*)city
{
    [self killTimer];
    [dataTableView reloadData];
    
    [[CityDownloadService defaultService] UnzipCityDataAsynchronous:city.cityId unzipDelegate:self];
}

- (void)didFailDownload:(City *)city error:(NSError *)error
{
    [self killTimer];
    
    PPDebug(@"download failed, error = %@", error.description);
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@城市数据下载失败"), city.countryName, city.cityName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [dataTableView reloadData];
}


#pragma mark -
#pragma mark: implementation of DownloadListCellDelegate
- (void)didDeleteCity:(City*)city
{
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    [self.downloadTableView reloadData];
}

- (void)didStartUpdate:(City *)city
{
    [self createTimer];
    [_downloadTableView reloadData];
}

- (void)didCancelUpdate:(City *)city
{
    
}

- (void)didPauseUpdate:(City *)city
{
    [self killTimer];
    [_downloadTableView reloadData];
}

- (void)didFinishUpdate:(City *)city
{
    [self killTimer];
    
    [[CityDownloadService defaultService] UnzipCityDataAsynchronous:city.cityId unzipDelegate:self];
}

- (void)didFailUpdate:(City *)city error:(NSError *)error
{
    [self killTimer];
    
    PPDebug(@"update failed, error = %@", error.description);
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@城市数据更新失败"), city.countryName, city.cityName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
//    [self popupMessage:message title:nil];
    [_downloadTableView reloadData];
}


#pragma mark - 
#pragma mark: delegate of unzip city.
- (void)didFailUnzip:(City*)city
{
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:city.cityId];
    NSString *type = @"";
    (localCity.updateStatus == UPDATE_FAILED) ? (type=NSLS(@"更新")) : (type=NSLS(@"下载"));
    
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@城市数据%@失败"), city.countryName, city.cityName, type];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self popupMessage:message title:nil];
    
    [dataTableView reloadData];
    [_downloadTableView reloadData];
}

- (void)didFinishUnzip:(City*)city 
{
    [dataTableView reloadData];
    
    self.downloadList = [[PackageManager defaultManager] getLocalCityList];
    [_downloadTableView reloadData];
}

@end
