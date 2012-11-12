
//  CommonPlaceListController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceListController.h"
#import "PlaceListController.h"
#import "PlaceService.h"
#import "SelectController.h"
#import "AppManager.h"
#import "SelectedItemIdsManager.h"
#import "UIImageUtil.h"
#import "CommonWebController.h"
#import "AppUtils.h"
#import "PPNetworkRequest.h"
#import "PPDebug.h"
#import "PlaceUtils.h"
#import "ImageManager.h"
#import "AppService.h"
#import "FontSize.h"
#define TAG_PLACE_COUNT_LABEL 1
#define EACH_FETCH 20

@implementation PlaceListFilter

//- (void)findAllPlaces:(PPViewController<PlaceServiceDelegate>*)viewController
//{
//    return [[PlaceService defaultService] findPlaces:[self getCategoryId]  viewController:viewController];
//}

- (void)findAllPlacesWithStart:(int)start
                         count:(int)count
               selectedItemIds:(PlaceSelectedItemIds *)selectedItemIds
                needStatistics:(BOOL)needStatistics 
                viewController:(PPViewController<PlaceServiceDelegate>*)viewController
                        filter:(id<PlaceListFilterProtocol>)filter
{
    [[PlaceService defaultService] findPlacesWithCategoryId:[self getCategoryId]
                                                             start:start 
                                                             count:count
                                                   selectedItemIds:selectedItemIds 
                                                    needStatistics:needStatistics
                                                    viewController:viewController
                                                            filter:filter];
}

@end


@interface CommonPlaceListController ()
{
    int _start;
    int _totalCount;
}

@property (retain, nonatomic) PlaceListController* placeListController;
@property (retain, nonatomic) PlaceListFilter<PlaceListFilterProtocol> *filterHandler;
@property (assign, nonatomic) int currentCityId;

@property (retain, nonatomic) NSArray *allPlaceList;
@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) PlaceSelectedItemIds *selectedItemIds;

@end

@implementation CommonPlaceListController

@synthesize currentCityId = _currentCityId;
@synthesize modeButton = _modeButton;
@synthesize buttonHolderView = _buttonHolderView;
@synthesize placeListHolderView = _placeListHolderView;
@synthesize placeListController = _placeListController;
@synthesize filterHandler = _filterHandler;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize placeList = _placeList;
@synthesize allPlaceList = _allPlaceList;

- (void)dealloc {
    PPRelease(_filterHandler);
    PPRelease(_placeListController);
//    PPRelease(_selectController);
    [_buttonHolderView release];
    [_placeListHolderView release];
    [_modeButton release];
    [_selectedItemIds release];
    PPRelease(_placeList);
    PPRelease(_allPlaceList);
    
    [super dealloc];
}

- (id)initWithFilterHandler:(PlaceListFilter<PlaceListFilterProtocol>*)handler
{
    self = [super init];
    if (self) {
        self.filterHandler = handler;
    }
        
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)clickHelp:(id)sender
{
    CommonWebController *controller = [[CommonWebController alloc] initWithWebUrl:[AppUtils getHelpHtmlFilePath]];
    controller.navigationItem.title = NSLS(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"帮助")
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickHelp:)];
    
    self.currentCityId = [[AppManager defaultManager] getCurrentCityId];
    
    [self setNavigationBarTitle];

    [_filterHandler createFilterButtons:self.buttonHolderView controller:self];
    
    _buttonHolderView.backgroundColor = [UIColor colorWithPatternImage:[[ImageManager defaultManager] filterBtnsHolderViewBgImage]];

    self.selectedItemIds = [[SelectedItemIdsManager defaultManager] getPlaceSelectedItems:[_filterHandler getCategoryId]];
    
    self.placeListController = [[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController supportPullDownToRefresh:YES supportPullUpToLoadMore:YES pullDelegate:self] autorelease];
        
    [_placeListController showInView:_placeListHolderView];

//    [_filterHandler findAllPlaces:self];
    
    _start = 0;
    
    [_filterHandler findAllPlacesWithStart:_start 
                                     count:EACH_FETCH
                           selectedItemIds:_selectedItemIds
                            needStatistics:YES
                            viewController:self
                                    filter:self.filterHandler];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    
    [super viewDidAppear:animated];
    
    [_placeListController viewDidAppear:animated];
}



- (void)clickBack:(id)sender
{
    [_selectedItemIds reset];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBarTitle
{
    UILabel *categoryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -8, 39, 20)];
    categoryNameLabel.text = [_filterHandler getCategoryName];
    categoryNameLabel.font = [UIFont boldSystemFontOfSize:19];
    categoryNameLabel.textColor = [UIColor whiteColor];
    categoryNameLabel.backgroundColor = [UIColor clearColor];

    UILabel *placeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, -8, 40, 20)];
    placeCountLabel.text = [NSString stringWithFormat:NSLS(@"(%d)"), dataList.count];
    placeCountLabel.font = [UIFont systemFontOfSize:12];
    placeCountLabel.textColor = [UIColor colorWithRed:183 green:222 blue:243 alpha:1];
    placeCountLabel.backgroundColor = [UIColor clearColor];
    placeCountLabel.tag = TAG_PLACE_COUNT_LABEL;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
    [view addSubview:categoryNameLabel];
    [view addSubview:placeCountLabel];
    [self.navigationItem setTitleView:view];

    [categoryNameLabel release];
    [placeCountLabel release];
    [view release];
}

- (void)updateNavigationBarTitle
{
    UILabel *placeCountLabel = (UILabel*)[self.navigationItem.titleView viewWithTag:TAG_PLACE_COUNT_LABEL];
    [placeCountLabel setText:[NSString stringWithFormat:NSLS(@"(%d)"), _totalCount]];
}

- (void)viewDidUnload
{
    [self setButtonHolderView:nil];
    [self setPlaceListHolderView:nil];
    [self setModeButton:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)findRequestDone:(int)resultCode
                 result:(int)result
             resultInfo:(NSString *)resultInfo
             totalCount:(int)totalCount
              placeList:(NSArray *)placeList
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"网络弱，数据加载失败" title:nil];
    }
    
    if (_start == 0) {
        _placeListController.noMoreData = NO;
        self.placeList = [NSArray array];
    }
    
    _start += [placeList count];
    _totalCount = totalCount;
    
    if (_start >= totalCount || [placeList count] == 0) {
        _placeListController.noMoreData = YES;
    }
    
//    self.allPlaceList = placeList;
//    self.placeList = [self filterAndSort:_allPlaceList];
    self.placeList = [_placeList arrayByAddingObjectsFromArray:placeList];
    
    // Update place count in navigation bar.
    [self updateNavigationBarTitle];
    
    
    self.dataTableView.tableFooterView.hidden = NO;
    
    // Reload place list.
    [_placeListController setPlaceList:_placeList];
    
    [_placeListController dataSourceDidFinishLoadingNewData];
    [_placeListController dataSourceDidFinishLoadingMoreData];
}

- (void)didPullDownToRefresh
{
//    [_filterHandler findAllPlaces:self];
    _start = 0;
    
    [_filterHandler findAllPlacesWithStart:_start 
                                     count:EACH_FETCH
                           selectedItemIds:_selectedItemIds
                            needStatistics:NO 
                            viewController:self
                                    filter:self.filterHandler];
}

- (void)didPullUpToLoadMore
{
    [_filterHandler findAllPlacesWithStart:_start 
                                     count:EACH_FETCH
                           selectedItemIds:_selectedItemIds
                            needStatistics:NO
                            viewController:self
                                    filter:self.filterHandler];
}

- (NSArray*)filterAndSort:(NSArray*)placeList
{    
    return [_filterHandler filterAndSotrPlaceList:placeList selectedItems:_selectedItemIds];
}

- (IBAction)clickMapButton:(id)sender
{    
    _modeButton.selected = !_modeButton.selected;
    
    // Show or hide some buttons.
    if (_modeButton.selected) {
        [self hideSomeFilterButtons];
    } else {
        [self showFilterButtons];
    }
    
    // Show animation.    
    UIViewAnimationTransition animationTransition = (_modeButton.selected ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight);
    [self showSwitchAnimation:animationTransition];

    // Switch mode.
    if (_modeButton.selected){
        [_placeListController switchToMapMode];
    }
    else{
        [_placeListController switchToListMode];
    }
}

- (void)showSwitchAnimation:(UIViewAnimationTransition)animationTransition
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:animationTransition
						   forView:self.view cache:YES];
    
    [UIView commitAnimations];
}

- (void)hideSomeFilterButtons
{
    for (UIView *subView in [self.buttonHolderView subviews]) {
        if (subView.tag ==SORT_BUTTON_TAG) {
            subView.hidden = YES;
        }
    }
    
    return;
}

- (void)showFilterButtons
{
    for (UIView *subView in [self.buttonHolderView subviews]) {
            subView.hidden = NO;
    }
}


- (void)clickCategoryButton:(id)sender
{
    NSArray *subCategoryItemList = [[AppManager defaultManager] getSubCategoryItemList:[_filterHandler getCategoryId]];
    
    [self pushSelectedControllerWithTitle:((UIButton*)sender).titleLabel.text 
                                 itemList:subCategoryItemList
                          selectedItemIds:_selectedItemIds.subCategoryItemIds
                             multiOptions:YES
                              needConfirm:YES
                            needShowCount:YES];
}

- (void)clickSortButton:(id)sender
{    
    NSArray *sortItemList = [[AppManager defaultManager] getSortItemList:[_filterHandler getCategoryId]];
    
    [self pushSelectedControllerWithTitle:((UIButton*)sender).titleLabel.text
                                 itemList:sortItemList
                          selectedItemIds:_selectedItemIds.sortItemIds
                             multiOptions:NO
                              needConfirm:YES
                            needShowCount:NO];
}

- (void)clickPrice:(id)sender
{    
    NSArray *priceRankItemList = [[AppManager defaultManager] getPriceRankItemList:_currentCityId];
    
    [self pushSelectedControllerWithTitle:((UIButton*)sender).titleLabel.text
                                 itemList:priceRankItemList 
                          selectedItemIds:_selectedItemIds.priceRankItemIds 
                             multiOptions:YES 
                              needConfirm:YES
                            needShowCount:NO];
}

- (void)clickArea:(id)sender
{
    NSArray *areaItemList = [[AppManager defaultManager] getAreaItemList:[_filterHandler getCategoryId]];
    
    [self pushSelectedControllerWithTitle:((UIButton*)sender).titleLabel.text
                                 itemList:areaItemList
                          selectedItemIds:_selectedItemIds.areaItemIds 
                             multiOptions:YES
                              needConfirm:YES
                            needShowCount:YES];
}

- (void)clickService:(id)sender
{
    
    NSArray *serviceItemList = [[AppManager defaultManager] getServiceItemList:[_filterHandler getCategoryId]];
    
    [self pushSelectedControllerWithTitle:((UIButton*)sender).titleLabel.text
                                 itemList:serviceItemList
                          selectedItemIds:_selectedItemIds.serviceItemIds 
                             multiOptions:YES
                              needConfirm:YES
                            needShowCount:YES];
}


- (void)pushSelectedControllerWithTitle:(NSString *)title
                               itemList:(NSArray *)itemList
                        selectedItemIds:(NSMutableArray *)selectedItemIds 
                           multiOptions:(BOOL)multiOptions 
                            needConfirm:(BOOL)needConfirm
                          needShowCount:(BOOL)needShowCount;
{
    NSString *text = [NSString stringWithFormat:@"%@%@", [_filterHandler getCategoryName], title];
    SelectController *controller = [[SelectController alloc] initWithTitle:text
                                                                  itemList:itemList
                                                           selectedItemIds:selectedItemIds
                                                              multiOptions:multiOptions 
                                                               needConfirm:needConfirm
                                                             needShowCount:needShowCount];
    
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)setSelectControllerNavigationTitle:(SelectController*)controller title:(NSString*)title
{
    PPDebug(@"cagegory name : %@", [_filterHandler getCategoryName]);
    controller.navigationItem.title = [NSString stringWithFormat:NSLS(@"%@%@"),[_filterHandler getCategoryName],title];
}


- (void)didSelectFinish:(NSArray*)selectedList
{     
    _start = 0;
    
    [_filterHandler findAllPlacesWithStart:_start
                                     count:EACH_FETCH
                           selectedItemIds:_selectedItemIds
                            needStatistics:NO 
                            viewController:self
                                    filter:self.filterHandler];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_placeListController.dataTableView reloadData];
}


@end
