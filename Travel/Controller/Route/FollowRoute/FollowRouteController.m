//
//  FollowRouteController.m
//  Travel
//
//  Created by haodong qiu on 12年7月14日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "FollowRouteController.h"
#import "RouteListCell.h"
#import "ImageManager.h"
#import "RouteStorage.h"
#import "CommonRouteDetailController.h"
#import "TravelNetworkConstants.h"

@interface FollowRouteController ()

@property (assign, nonatomic) int routeType;

@end

@implementation FollowRouteController
@synthesize routeType = _routeType;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithRouteType:(int)routeType
{
    self = [super init];
    if (self) {
        self.routeType = routeType;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的关注";
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 11, 46, 22)];
    [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [deleteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [deleteButton addTarget:self action:@selector(clickClear:) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButtonView addSubview:deleteButton];
    [deleteButton release];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    [rightButtonView release];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.dataList = [[RouteStorage followManager:_routeType] findAllRoutesSortByLatest];
    [self updateNoDataTips];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidAppear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RouteListCell getCellHeight];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:[RouteListCell getCellIdentifier]];
    if (cell == nil) {
        cell = [RouteListCell createCell:self];		
        
        UIImageView *view = [[UIImageView alloc] init];
        [view setImage:[[ImageManager defaultManager] listBgImage]];
        [cell setBackgroundView:view];
        [view release];
    }
    RouteListCell* routeCell = (RouteListCell*)cell;
    [routeCell setCellData:[dataList objectAtIndex:indexPath.row]];
    
    if (tableView.editing) {
        routeCell.totalView.frame = CGRectOffset(routeCell.totalView.frame, 10, 0);
    }else {
        routeCell.totalView.frame = (CGRect){CGPointMake(0, 0), routeCell.totalView.frame.size};
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int routeId = [[dataList objectAtIndex:indexPath.row] routeId];
    
    CommonRouteDetailController *controller = [[CommonRouteDetailController alloc] initWithRouteId:routeId routeType:_routeType];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TouristRoute *delRoute = (TouristRoute *)[dataList objectAtIndex:indexPath.row];
        [[RouteService defaultService] unfollowRoute:delRoute routeType:_routeType viewController:self];
        
        NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
        [mutableDataList removeObjectAtIndex:indexPath.row];
        self.dataList = mutableDataList;
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)clickClear:(id)sender
{
    [dataTableView setEditing:!dataTableView.editing animated:YES];
    [dataTableView reloadData];
}


- (void)updateNoDataTips
{
    if ([dataList count] ==0 ) {
        [self showTipsOnTableView:NSLS(@"暂没关注信息")];
    } else {
        [self hideTipsOnTableView];
    }
}


#pragma mark - RouteServiceDelegate method
- (void)unfollowRouteDone:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    [self updateNoDataTips];
}


@end
