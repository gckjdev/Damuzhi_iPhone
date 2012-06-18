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

- (UIImage *)routeRankGoodImage
{
    return [UIImage strectchableImageName:@"line_star.png"];
}

- (UIImage *)routeRankBadImage;
{
    return [UIImage strectchableImageName:@"line_star2.png"];
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


@end
