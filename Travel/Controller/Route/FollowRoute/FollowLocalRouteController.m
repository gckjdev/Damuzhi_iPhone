//
//  FollowLocalRouteController.m
//  Travel
//
//  Created by haodong on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FollowLocalRouteController.h"
#import "RouteListCell.h"
#import "ImageManager.h"
#import "LocalRouteStorage.h"
#import "LocalRouteDetailController.h"
#import "TravelNetworkConstants.h"
#import "FontSize.h"

@interface FollowLocalRouteController ()

@property (retain, nonatomic) UIButton* deleteButton;

@end

@implementation FollowLocalRouteController
@synthesize deleteButton;

- (void)dealloc
{  
    [deleteButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关注线路";
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         fontSize:FONT_SIZE
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 46, 30)];
    [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topmenu_btn_right.png"]];
    [deleteButton setImageEdgeInsets:UIEdgeInsetsMake(2, 3, 0, 0)];
    
    deleteButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE - 1];
    
    [deleteButton addTarget:self action:@selector(clickClear:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50 , 44)];
    [rightButtonView addSubview:deleteButton];
    
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    [rightButtonView release];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.dataList = [[LocalRouteStorage followManager] findAllRoutesSortByLatest];
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
    
    LocalRouteDetailController *controller = [[LocalRouteDetailController alloc] initWithLocalRouteId:routeId];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LocalRoute *delRoute = (LocalRoute *)[dataList objectAtIndex:indexPath.row];
        [[RouteService defaultService] unFollowLocalRoute:delRoute viewController:self];
        
        NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:dataList];
        [mutableDataList removeObjectAtIndex:indexPath.row];
        self.dataList = mutableDataList;
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if ([self.dataList count] == 0) {
            [self clickClear:nil];
        }
    }
}


- (void)clickClear:(id)sender
{
    [dataTableView setEditing:!dataTableView.editing animated:YES];
    [dataTableView reloadData];
    
    
    [deleteButton removeFromSuperview];
    if (dataTableView.editing) 
    {
        [deleteButton setImage:nil forState:UIControlStateNormal]; //necessary
        [deleteButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else 
    {
        [deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    }
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50 , 44)];
    [rightButtonView addSubview:deleteButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
    [rightButtonView release];
}


- (void)updateNoDataTips
{
    if ([dataList count] ==0 ) {
        [self showTipsOnTableView:NSLS(@"您还没有关注线路")];
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
