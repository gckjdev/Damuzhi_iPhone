//
//  HistoryController.m
//  Travel
//
//  Created by haodong qiu on 12年3月29日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "HistoryController.h"
#import "PlaceStorage.h"
#import "PlaceListController.h"
#import "FontSize.h"
@interface HistoryController ()

@property (retain, nonatomic) NSArray *placeList;
@property (retain, nonatomic) PlaceListController *placeListController;

@end

@implementation HistoryController
@synthesize placeListHolderView;
@synthesize placeList = _placeList;
@synthesize placeListController = _placeListController;

- (void)dealloc {
    PPRelease(placeListHolderView);
    PPRelease(_placeList);
    PPRelease(_placeListController);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:HISTORY];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"清空") 
                          fontSize:FONT_SIZE
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickDelete:)];
    
    self.placeList = [[PlaceStorage historyManager] allPlacesSortByLatest];
    
    self.placeListController = [[[PlaceListController alloc] initWithSuperNavigationController:self.navigationController supportPullDownToRefresh:NO supportPullUpToLoadMore:NO pullDelegate:nil] autorelease];
    
    [_placeListController showInView:placeListHolderView];
    
    [_placeListController setPlaceList:_placeList];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [self setPlaceListHolderView:nil];
    [self setPlaceListController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)clickDelete:(id)sender
{
    if ([_placeList count] == 0) 
        return ;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                    message:NSLS(@"确定要清空所有浏览记录")
                                                   delegate:self 
                                          cancelButtonTitle:NSLS(@"取消") otherButtonTitles:NSLS(@"确定"), nil];
    [alert show];
    [alert release];
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[PlaceStorage historyManager] deleteAllPlaces];
         self.placeList = [[PlaceStorage historyManager] allPlacesSortByLatest];
        [self.placeListController setPlaceList:_placeList];
    }
}

@end
