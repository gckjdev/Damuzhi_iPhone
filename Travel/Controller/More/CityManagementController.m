//
//  CityManagementController.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityManagementController.h"
#import "AppManager.h"
#import "ImageName.h"
#import "PackageManager.h"
#import "StringUtil.h"
#import "FontSize.h"
#import "UIImageUtil.h"
#import "ImageManager.h"
#import "UIViewUtils.h"
#import "DeviceDetection.h"

#define REGION_BUTTON_HEIGHT    30
#define PROMPT_LABEL_HEIGHT 30
#define CITY_SEARCH_BAR_HEIGHT 44
#define SELF_VIEW_WIDTH 320
#define NAVIGATION_BAR_HEIGHT 44
#define SELF_VIEW_HEIGHT ([[UIScreen mainScreen] bounds].size.height- 20 - NAVIGATION_BAR_HEIGHT)



@interface CityManagementController ()

@property (retain, nonatomic) NSMutableArray *downloadingCities;
@property (retain, nonatomic) NSArray *countryNameList;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property(retain, nonatomic) UILabel *label;

@property (retain, nonatomic) NSArray *regions;
@property (retain, nonatomic) AppManager *appManager;
@property (retain, nonatomic) NSArray *allCitys;
@property (retain, nonatomic) NSArray *showCitys;
@property (retain, nonatomic) NSArray *firstPinyinList;

@property (retain, nonatomic) NSArray *twentySixLetters;
@end

@implementation CityManagementController 

static CityManagementController *_instance;
@synthesize delegate = _delegate;
@synthesize downloadingCities = _downloadingCities;
@synthesize downloadList = _downloadList;
@synthesize downloadTableView = _downloadTableView;
@synthesize promptLabel = _promptLabel;
@synthesize citySearchBar = _citySearchBar;
@synthesize cityListBtn = _cityListBtn;
@synthesize downloadListBtn = _downloadListBtn;
@synthesize countryNameList = _countryNameList;
@synthesize firstPinyinList = _firstPinyinList;
@synthesize filteredListContent = _filteredListContent;
@synthesize label = _label;


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
    [_cityListBtn release];
    [_downloadListBtn release];
    [_promptLabel release];
    [_citySearchBar release];
    [_downloadingCities release];
    
    [_countryNameList release];
    [_firstPinyinList release];
    [_filteredListContent release];
    [_label release];
    [_cityListBackgroundImageView release];
    [_regionHolderView release];
    [_regions release];
    
    [_appManager release];
    [_allCitys release];
    [_showCitys release];
    [_twentySixLetters release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.appManager = [AppManager defaultManager];
    }
    return self;
}

- (void)getCityData
{
    self.downloadList = [[PackageManager defaultManager] getDownLoadLocalCityList];
    self.countryNameList = [[PackageManager defaultManager] getDownLoadCountryGroupList];
    
    self.label.hidden = ([self.downloadList count] == 0)? NO:YES;
    [self.downloadTableView addSubview:self.label];
    self.filteredListContent = [[[NSMutableArray alloc] init] autorelease];
    
    self.regions = [[_appManager app] regionsList];
    self.allCitys = [_appManager getCityList];
    self.showCitys = [_appManager getCityList];
    [self updateFirstPinyinList];
    
    
    
    NSMutableArray *mutableArray = [[[NSMutableArray alloc] init] autorelease];
    [mutableArray addObject:HOT_CITY];
    for (int index = 0 ; index < 26 ; index ++)
    {
        char c = 'A';
        NSString *letter = [NSString stringWithFormat:@"%c", c + index];
        [mutableArray addObject:letter];
    }
    self.twentySixLetters = mutableArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.cityListBackgroundImageView setImage:[UIImage imageNamed:IMAGE_CITY_MAIN_BOTTOM]];
    
    self.downloadingCities = [NSMutableArray array];
    
    self.label = [self labelWithTitle:NSLS(@"您暂未下载离线城市数据")];
    [self getCityData];
    
    [self addCityManageButtons];
    
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    self.promptLabel.backgroundColor = [UIColor colorWithRed:121.0/255.0 green:164.0/255.0 blue:180.0/255.0 alpha:1]; 
    dataTableView.frame = CGRectMake(0, PROMPT_LABEL_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - PROMPT_LABEL_HEIGHT - REGION_BUTTON_HEIGHT);
    [_regionHolderView updateOriginY:PROMPT_LABEL_HEIGHT];
    
    [self.view addSubview:self.promptLabel];
    
    self.downloadTableView.frame = CGRectMake(0, 0, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT);
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
    
    self.promptLabel.hidden = NO;
    self.citySearchBar.hidden = YES;
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:@""
                          fontSize:FONT_SIZE
                         imageName:@"search_btn.png"
                            action:@selector(clickSearch:)];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 26)] autorelease];
    [imageView setImage:[UIImage imageNamed:@"city_ing.png"]];
    dataTableView.tableFooterView = imageView;
    
    [self addRegionButtons];
    [self setDefaultSelectRegion];
}

- (void)setDefaultSelectRegion
{
    if ([_regions count] > 0) {
        Region *region = [_regions objectAtIndex:0];
        UIButton *button = (UIButton *)[self.regionHolderView viewWithTag:region.regionId];
        [self clickRegionButton:button];
    }
}


-(void)clickSearch:(id)sender
{
    if (self.dataTableView.hidden == YES) {
        return;
    }
    self.promptLabel.hidden = !self.promptLabel.hidden;
    self.citySearchBar.hidden = !self.citySearchBar.hidden;
    if (self.promptLabel.hidden == YES) {
        dataTableView.frame = CGRectMake(0, CITY_SEARCH_BAR_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - CITY_SEARCH_BAR_HEIGHT - REGION_BUTTON_HEIGHT);
        [_regionHolderView updateOriginY:CITY_SEARCH_BAR_HEIGHT];
    }else {
        dataTableView.frame = CGRectMake(0, PROMPT_LABEL_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - PROMPT_LABEL_HEIGHT - REGION_BUTTON_HEIGHT);
        [_regionHolderView updateOriginY:PROMPT_LABEL_HEIGHT];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}

- (UILabel *)labelWithTitle:(NSString*)title
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, _downloadTableView.frame.size.width, 30)] autorelease];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    return label;
}

#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredListContent removeAllObjects];
    
    for (City *city in _allCitys)
    {
        int cityLocation = [city.cityName rangeOfString:searchText].location;
        if ([city.cityName isEqualToString:@"厦门"])
        {
            if (cityLocation < [city.cityName length] || [searchText isEqualToString:@"x"])
            {
                [self.filteredListContent addObject:city];
            }
            continue;
        }
        
        if (cityLocation < [city.cityName length]
            || [searchText isEqualToString:[city.cityName pinyinFirstLetter]]
            || [searchText isEqualToString:[[city.cityName pinyinFirstLetter] uppercaseString]])
        {
            [self.filteredListContent addObject:city];
        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)viewDidUnload
{
    [self setPromptLabel:nil];
    [self setCitySearchBar:nil];
    [self setCityListBackgroundImageView:nil];
    [self setRegionHolderView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
	return [CityListCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == dataTableView) {
        if ([self hasSection]) {
            return [self.firstPinyinList count];
        } else {
            return 1;
        }
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else{
        return [self.countryNameList count];
    }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    if (tableView == self.downloadTableView) {
        NSArray *downLoadCityListFromCountry = [[PackageManager defaultManager] getdownLoadCityListFromCountry:[self.countryNameList objectAtIndex:section]];
        return [downLoadCityListFromCountry count];
    }
    else if (tableView == dataTableView){
        if ([self hasSection]) {
            NSString *firstLetter = [_firstPinyinList objectAtIndex:section];
            NSArray *citys = [_appManager getCityListByFirstLetter:firstLetter basicCityList:_showCitys];
            return [citys count];
        } else {
            return [_showCitys count];
        }
    }else if (tableView == self.searchDisplayController.searchResultsTableView){
        return [_filteredListContent count];
    }else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == dataTableView) {
        if ([self hasSection]) {
            return [self.firstPinyinList objectAtIndex:section];
        } else {
            return nil;
        }
    } else if (tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    } else {
        return  [self.countryNameList objectAtIndex:section];
    }
}

#define COUNT_ONE_PAGE ([DeviceDetection isIPhone5] ? (8) : (6) )
- (BOOL)hasSection
{
    NSArray *showHotCitys = [_appManager getCityListByFirstLetter:HOT_CITY basicCityList:_showCitys];
    int allCount = [_showCitys count] + [showHotCitys count];
    
    return allCount > COUNT_ONE_PAGE;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.dataTableView) {
        if ([self hasSection]) {
            return _twentySixLetters;
        } else {
            return nil;
        }
    }else {
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    int reSection = 0;
    for (NSString *sectionName in _firstPinyinList) {
        if ([sectionName isEqualToString:title]
            || ([[sectionName pinyinFirstLetter] isEqualToString:[title lowercaseString]] && ![sectionName isEqualToString:HOT_CITY]) ) {
            break;
        }
        reSection ++;
    }
    
    return reSection;
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
        int section = [indexPath section];
        int count = [_downloadList count];
        
        if (row >= count){
            PPDebug(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
            return cell;
        }
        DownloadListCell* downloadCell = (DownloadListCell*)cell;
        NSArray *arr = [[PackageManager defaultManager] getdownLoadCityListFromCountry:[self.countryNameList objectAtIndex:section]];
        [downloadCell setCellData:[arr objectAtIndex :row]] ;
        
        downloadCell.downloadListCellDelegate = self;
    }
    else {
        cell = [theTableView dequeueReusableCellWithIdentifier:[CityListCell getCellIdentifier]];
        
        if (cell == nil) {
            cell = [CityListCell createCell:self];				
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *cellBgImageName = IMAGE_CITY_CELL_BG;
        City *city = nil;
        if (theTableView == dataTableView) {
            
            if ([self hasSection]) {
                NSString *firstLetter = [_firstPinyinList objectAtIndex:indexPath.section];
                NSArray *citys = [_appManager getCityListByFirstLetter:firstLetter basicCityList:_showCitys];
                city = [citys objectAtIndex:indexPath.row];
                
                if ([firstLetter isEqualToString:HOT_CITY]) {
                    cellBgImageName = IMAGE_HOT_CITY_CELL_BG;
                }
                
            } else {
                city = [_showCitys objectAtIndex:indexPath.row];
            }
        }else if (theTableView == self.searchDisplayController.searchResultsTableView){
            city = [_filteredListContent objectAtIndex:indexPath.row];
        }
        
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[UIImage imageNamed:cellBgImageName]];
        [cell setBackgroundView:view];
        [view release];
        
        CityListCell* cityCell = (CityListCell*)cell;
        [cityCell setCellData:city];
        cityCell.cityListCellDelegate = self;
    }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadTableView) {
        
    } else {
        City *city = nil;
        if (tableView == self.dataTableView) 
        {
            if ([self hasSection]) {
                NSString *firstLetter = [_firstPinyinList objectAtIndex:indexPath.section];
                NSArray *citys = [_appManager getCityListByFirstLetter:firstLetter basicCityList:_showCitys];
                city = [citys objectAtIndex:indexPath.row];
            } else {
                city = [_showCitys objectAtIndex:indexPath.row];
            }
        } else if (tableView == self.searchDisplayController.searchResultsTableView) {
            city = [_filteredListContent objectAtIndex:indexPath.row];
        }
        
        [self finishSelectCity:city];
    }
    
}

#pragma mark -
#pragma mark: implementation of buttons event
- (void)clickCityListButton:(id)sender
{
    
    [self setNavigationRightButton:@"" 
                          fontSize:FONT_SIZE
                         imageName:@"search_btn.png" 
                            action:@selector(clickSearch:)];
    
    // Set buttons status.
    _downloadListBtn.selected = NO;
    _cityListBtn.selected = YES;
    
    // Show city list table view.
    self.regionHolderView.hidden = NO;
    self.dataTableView.hidden = NO;
    self.downloadTableView.hidden = YES;
    
    int downloadListButtonClickedFlag1 = 0;
    int downloadListButtonClickedFlag2 = 1;
    if (self.promptLabel.hidden == NO) {
        self.dataTableView.frame = CGRectMake(0, PROMPT_LABEL_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - PROMPT_LABEL_HEIGHT - REGION_BUTTON_HEIGHT);
        [_regionHolderView updateOriginY:PROMPT_LABEL_HEIGHT];
        downloadListButtonClickedFlag1 = 1;
    }
    if (self.citySearchBar.hidden == NO) {
        self.dataTableView.frame = CGRectMake(0, CITY_SEARCH_BAR_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - CITY_SEARCH_BAR_HEIGHT - REGION_BUTTON_HEIGHT);
        [_regionHolderView updateOriginY:CITY_SEARCH_BAR_HEIGHT];
        downloadListButtonClickedFlag2 = 0;
    }
    if (downloadListButtonClickedFlag1 < downloadListButtonClickedFlag2)
    {
        /*
         When clickDownloadListButton: is called, both promptLabel and citySearchBar are hidden.
         In this case(and only in this case), downloadListButtonClickedFlag1 is 0,downloadListButtonClickedFlag2 is 1.
        */
        self.promptLabel.hidden = NO;
        self.dataTableView.frame = CGRectMake(0, PROMPT_LABEL_HEIGHT + REGION_BUTTON_HEIGHT, SELF_VIEW_WIDTH, SELF_VIEW_HEIGHT - PROMPT_LABEL_HEIGHT - REGION_BUTTON_HEIGHT);
        [_regionHolderView updateOriginY:PROMPT_LABEL_HEIGHT];
    } 
    
    // reload city list table view
    [self.dataTableView reloadData];
}

- (void)clickDownloadListButton:(id)sender
{

    self.navigationItem.rightBarButtonItem = nil;

    // Set buttons status.
    _downloadListBtn.selected = YES;
    _cityListBtn.selected = NO;
    
    // Show download management table view.
    dataTableView.hidden = YES;
    _downloadTableView.hidden = NO;

    self.promptLabel.hidden = YES;
    self.citySearchBar.hidden = YES;
    self.regionHolderView.hidden = YES;
    
    //necessary
    [self getCityData];
    
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
    if ([self.downloadingCities count] == 0) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)handleTimer
{
    [dataTableView reloadData];
    [_downloadTableView reloadData];
}

- (void)finishSelectCity:(City*)city
{
    [[AppManager defaultManager] setCurrentCityId:city.cityId delegate:_delegate];
    
    NSString *message = [NSString stringWithFormat:NSLS(@"%@%@"), city.countryName, city.cityName];
    [self popupMessage:message title:NSLS(@"提示")];
    self.searchDisplayController.active = NO;
    [self.dataTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark: implementation of CityListCellDelegate
- (void)didSelectCurrendCity:(City*)city
{
    [self finishSelectCity:city];
}

- (void)didStartDownload:(City*)city
{
    [self createTimer];
    [self.downloadingCities addObject:[NSNumber numberWithInt:city.cityId]];
    [dataTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)didCancelDownload:(City*)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];

    [dataTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)didPauseDownload:(City*)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];

    [dataTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)didClickOnlineBtn:(City*)city
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didFinishDownload:(City*)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];

    [dataTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    [[CityDownloadService defaultService] UnzipCityDataAsynchronous:city.cityId unzipDelegate:self];
}

- (void)didFailDownload:(City *)city error:(NSError *)error
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];

    PPDebug(@"download failed, error = %@", error.description);
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@下载暂停"), city.countryName, city.cityName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [dataTableView reloadData];
}


#pragma mark -
#pragma mark: implementation of DownloadListCellDelegate
- (void)didDeleteCity:(City*)city
{
    [self getCityData];
    [self.downloadTableView reloadData];
}

- (void)didStartUpdate:(City *)city
{
    [self createTimer];
    [self.downloadingCities addObject:[NSNumber numberWithInt:city.cityId]];
    [_downloadTableView reloadData];
}

- (void)didCancelUpdate:(City *)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];
    [_downloadTableView reloadData];
}

- (void)didPauseUpdate:(City *)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];
    [_downloadTableView reloadData];
}

- (void)didFinishUpdate:(City *)city
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];
    [[CityDownloadService defaultService] UnzipCityDataAsynchronous:city.cityId unzipDelegate:self];
}

- (void)didFailUpdate:(City *)city error:(NSError *)error
{
    [self.downloadingCities removeObject:[NSNumber numberWithInt:city.cityId]];
    [self killTimer];

    PPDebug(@"update failed, error = %@", error.description);
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@更新暂停"), city.countryName, city.cityName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self getCityData];
    [_downloadTableView reloadData];
}


#pragma mark - 
#pragma mark: delegate of unzip city.
- (void)didFailUnzip:(City*)city
{
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:city.cityId];
    NSString *type = @"";
    (localCity.updateStatus == UPDATE_FAILED) ? (type=NSLS(@"更新")) : (type=NSLS(@"下载"));
    
    NSString *message = [NSString stringWithFormat:NSLS(@"%@.%@%@暂停"), city.countryName, city.cityName, type];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self popupMessage:message title:nil];
    
    [dataTableView reloadData];
    [_downloadTableView reloadData];
}

- (void)didFinishUnzip:(City*)city 
{
    [self getCityData];
    [dataTableView reloadData];
    [_downloadTableView reloadData];
}

#define COUNT_REGION_BUTTON 6.0
- (void)addRegionButtons
{
    int count = [self.regions count];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 320 / COUNT_REGION_BUTTON;
    CGFloat height = 30;
    
    if (count > COUNT_REGION_BUTTON){
        width = 320.00 / count;
    }
    
    int index = 0;
    for(Region *region in self.regions)
    {
        x = index * width;
        CGRect frame =  CGRectMake(x, y, width, height);
        UIButton *button = [self createRegionButton:frame buttonTitle:[region regionName]];
        button.tag = region.regionId;
        [button addTarget:self action:@selector(clickRegionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.regionHolderView addSubview:button];
        index++;
    }
}

- (void)clickRegionButton:(id)sender
{
    NSArray *subviews = [self.regionHolderView subviews];
    for(UIView *view in subviews) {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *oneButton = (UIButton *)view;
            oneButton.selected = NO;
        }
    }
    
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
    
    [self filterByRegion:button.tag];
}

- (void)filterByRegion:(int)regionId
{
    self.showCitys = [_appManager getCityListByRegionId:regionId basicCityList:_allCitys];
    [self updateFirstPinyinList];
    
    PPDebug(@"total:%d %d:%d", [_allCitys count], regionId, [_showCitys count]);
    
    [self.dataTableView reloadData];
}

- (void)updateFirstPinyinList
{
    NSMutableArray *mutableArray =  [NSMutableArray arrayWithArray:[_appManager getFirstLetterList:_showCitys]];
    if ([_appManager hasHotCity:_showCitys]) {
        [mutableArray insertObject:HOT_CITY atIndex:0];
    }
    
    self.firstPinyinList = mutableArray;
}

#define COLOR_REGION_TITLE [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1]
- (UIButton *)createRegionButton:(CGRect)frame buttonTitle:(NSString *)buttonTitle
{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    ;
    
    [button setTitle:buttonTitle  forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [button setTitleColor:COLOR_REGION_TITLE forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[[ImageManager defaultManager] regionNormalBgImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[[ImageManager defaultManager] regionSelectedBgImage] forState:UIControlStateSelected];
    
    return button;
}

@end
