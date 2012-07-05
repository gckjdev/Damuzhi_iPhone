//
//  ImageManager.m
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "ImageManager.h"
#import "UIImageUtil.h"

static ImageManager *_defaultManager = nil;

@implementation ImageManager

+ (id)defaultManager
{
    if (_defaultManager == nil){
        _defaultManager = [[ImageManager alloc] init];
    }
    
    return _defaultManager;
}

- (int)getPositionWithRowNum:(int)rowNum rowCount:(int)rowCount
{
    if (rowNum >= rowCount || rowCount < 0) {
        return -9999;
    }
    
    if (rowCount == 1) {
        return POSITION_ONLY_ONE;
    }
    
    if (rowNum == 0) {
        return POSITION_TOP;
    }else if (rowNum == rowCount - 1){
        return POSITION_BOTTOM;
    }else {
        return POSITION_MIDDLE;
    }
}

- (UIImage *)navigationBgImage
{
    return [UIImage imageNamed:@"topmenu_bg.png"];
}



- (UIImage *)filterBtnsHolderViewBgImage
{
    return [UIImage strectchableImageName:@"select_tr_bg.png"];
}

- (UIImage *)filgerBtnBgImage
{
    return [UIImage strectchableImageName:@"select_down.png" leftCapWidth:20];
}

- (UIImage *)listBgImage
{
    return [UIImage strectchableImageName:@"li_bg.png"];
}

- (UIImage *)rankGoodImage
{
    return [UIImage strectchableImageName:@"good.png"];
}

- (UIImage *)rankBadImage;
{
    return [UIImage strectchableImageName:@"good2.png"];
}

- (UIImage *)departIcon
{
    return [UIImage imageNamed:@"select_icon1.png"];
}

- (UIImage *)angencyIcon
{
    return [UIImage imageNamed:@"select_icon2.png"];
}

- (UIImage *)routeCountIcon
{
    return [UIImage imageNamed:@"select_icon3.png"];
}

- (UIImage *)statisticsBgImage
{
    return [UIImage strectchableImageName:@"select_bg_zy1.png"];
}

- (UIImage *)lineImage
{
    return [UIImage strectchableImageName:@"select_bg_line.png"];
}

- (UIImage *)routeDetailTitleBgImage
{
    return [UIImage strectchableImageName:@"line_title_bg.png"];
}

- (UIImage *)routeDetailAgencyBgImage
{
    return [UIImage strectchableImageName:@"line_title_bg2.png"];
}

- (UIImage *)bookButtonImage
{
    return [UIImage imageNamed:@"line_order_btn.png"];
}

- (UIImage *)dailyScheduleTitleBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_ONLY_ONE || position == POSITION_TOP) {
        return [UIImage imageNamed:@"line_table_1.png"];
    }else if (position == POSITION_BOTTOM || position == POSITION_MIDDLE) {
        return [UIImage imageNamed:@"line_table_5.png"]; 
    }else {
        return nil;
    }
}

- (UIImage *)lineNavBgImage
{
    return [UIImage strectchableImageName:@"line_nav_bg.png"];
}

- (UIImage *)lineListBgImage
{
    return [UIImage strectchableImageName:@"line_list_bg.png"];
}

- (UIImage *)tableBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_MIDDLE) {
        return [UIImage strectchableImageName:@"table5_bg1_center.png"]; 
    }
    
    if (position == POSITION_TOP) {
        return [UIImage strectchableImageName:@"table5_bg1_top.png"]; 
    }
    
    if (position == POSITION_BOTTOM) {
        return [UIImage strectchableImageName:@"table5_bg1_down.png"]; 
    }
    
    if (position == POSITION_ONLY_ONE) {
        return [UIImage strectchableImageName:@"table5_bg1_only_one.png"];
    }
    
    return nil;
}

- (UIImage *)tableLeftBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_MIDDLE || position == POSITION_TOP) {
        return [UIImage strectchableImageName:@"line_table_2a.png"]; 
    }
    
    if (position == POSITION_BOTTOM || position == POSITION_ONLY_ONE) {
        return [UIImage strectchableImageName:@"line_table_4a.png"]; 
    }

    return nil;
}

- (UIImage *)tableRightBgImageWithRowNum:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_MIDDLE || position == POSITION_TOP) {
        return [UIImage strectchableImageName:@"line_table_2b.png"]; 
    }
    
    if (position == POSITION_BOTTOM || position == POSITION_ONLY_ONE) {
        return [UIImage strectchableImageName:@"line_table_4b.png"]; 
    }
    
    return nil;
}

- (UIImage *)arrowImage
{
    return [UIImage imageNamed:@"line_zk.png"];
}

- (UIImage *)bookingBgImage
{
    return [UIImage strectchableImageName:@"date_t_bg.png"];
}

- (UIImage *)signUpBgImage
{
    return [UIImage strectchableImageName:@"signup_bg.png"];
}

- (UIImage *)selectDownImage
{
    return [UIImage strectchableImageName:@"select_down.png" leftCapWidth:10];
}


- (UIImage *)morePointImage
{
    return [UIImage imageNamed:@"more_icon.png"];
}



- (UIImage *)accessoryImage
{
    return [UIImage imageNamed:@"go_btn.png"];
}



- (UIImage *)orderListHeaderView:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_MIDDLE) {
        return [UIImage strectchableImageName:@"order_list_2.png" leftCapWidth:50]; 
    }
    
    if (position == POSITION_TOP || position == POSITION_ONLY_ONE) {
        return [UIImage strectchableImageName:@"order_list_1.png" leftCapWidth:50]; 
    }
    
    if (position == POSITION_BOTTOM) {
        return [UIImage strectchableImageName:@"order_list_3.png" leftCapWidth:50]; 
    }
    
    return nil;
}

- (UIImage *)orangePoint
{
    return [UIImage imageNamed:@"line_p2.png"];
}

- (UIImage *)routeFeekbackBgImage1
{
    return [UIImage strectchableImageName:@"fk_bg.png" leftCapWidth:12];
}
- (UIImage *)routeFeekbackBgImage2
{
    return [UIImage strectchableImageName:@"fk_bg2.png" leftCapWidth:(21)];
}

- (UIImage *)orderTel
{
    return [UIImage imageNamed:@"order_tel.png"];
}

@end
