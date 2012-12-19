//
//  ImageManager.m
//  Travel
//
//  Created by 小涛 王 on 12-6-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "ImageManager.h"
#import "UIImageUtil.h"
#import "DeviceDetection.h"

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
    return [UIImage strectchableImageName:@"line_title_bg2@2x.png"];
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
//    return [UIImage strectchableImageName:@"line_nav_bg.png"];
    return [UIImage strectchableImageName:@"line_n_bg1@2x.png"];
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

- (UIImage *)arrowRightImage
{
    return [UIImage imageNamed:@"line_zk2.png"];
}

//- (UIImage *)bookingBgImage
//{
//    return [UIImage strectchableImageName:@"date_t_bg.png"];
//}

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
 
- (UIImage *)orderListHeaderView:(int)rowNum rowCount:(int)rowCount open:(BOOL)open
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_MIDDLE) {
        return [UIImage strectchableImageName:@"order_list_2.png" leftCapWidth:50]; 
    }
    
    if (position == POSITION_TOP || position == POSITION_ONLY_ONE) {
        return [UIImage strectchableImageName:@"order_list_1.png" leftCapWidth:50]; 
    }
    
    if (position == POSITION_BOTTOM) {
        return (open ? [UIImage strectchableImageName:@"order_list_2.png" leftCapWidth:50] : 
                [UIImage strectchableImageName:@"order_list_3.png" leftCapWidth:50]); 
    }
    
    return nil;
}

- (UIImage *)orderListCellBgImage:(int)rowNum rowCount:(int)rowCount
{
    int position = [self getPositionWithRowNum:rowNum rowCount:rowCount];
    
    if (position == POSITION_TOP || position == POSITION_MIDDLE) {
        return [UIImage strectchableImageName:@"order_list_4.png" topCapHeight:10]; 
    }
    
    if (position == POSITION_BOTTOM || position == POSITION_ONLY_ONE) {
        return ([UIImage strectchableImageName:@"order_list_5.png" topCapHeight:5]); 
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

- (UIImage *)routeClassifyButtonBgImage1WithRow:(int)row
                                         column:(int)column
                                      totalRows:(int)totalRows  
                                    totalColumn:(int)totalColumn
{
    if (totalColumn <= 1 || totalRows < 1) {
        return nil;
    }
    
    if (totalRows == 1) {
        if (row == 0 &&  column == 0) {
            return [UIImage imageNamed:@"filter_1_off.png"];
        }else if (row == 0 &&  column == totalColumn - 1) {
            return [UIImage imageNamed:@"filter_3_off.png"];
        }else {
            return [UIImage imageNamed:@"filter_2_off.png"];
        }
    }else {
        if (row == 0) {
            if (column == 0) {
                return [UIImage imageNamed:@"filter_4_off.png"]; 
            }else if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_5_off.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_2_off.png"]; 
            }
        }else if (row == totalRows - 1) {
            if (column == 0) {
                return [UIImage imageNamed:@"filter_8_off.png"]; 
            }else if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_9_off.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_6_off.png"]; 
            }
        }else {
            if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_7_off.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_6_off.png"]; 
            }
        }
        
    }
}

- (UIImage *)routeClassifyButtonBgImage2WithRow:(int)row
                                         column:(int)column
                                      totalRows:(int)totalRows  
                                    totalColumn:(int)totalColumn
{
    if (totalColumn <= 1 || totalRows < 1) {
        return nil;
    }
    
    if (totalRows == 1) {
        if (row == 0 &&  column == 0) {
            return [UIImage imageNamed:@"filter_1_on.png"];
        }else if (row == 0 &&  column == totalColumn - 1) {
            return [UIImage imageNamed:@"filter_3_on.png"];
        }else {
            return [UIImage imageNamed:@"filter_2_on.png"];
        }
    }else {
        if (row == 0) {
            if (column == 0) {
                return [UIImage imageNamed:@"filter_4_on.png"]; 
            }else if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_5_on.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_2_on.png"]; 
            }
        }else if (row == totalRows - 1) {
            if (column == 0) {
                return [UIImage imageNamed:@"filter_8_on.png"]; 
            }else if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_9_on.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_6_on.png"]; 
            }
        }else {
            if (column == totalColumn - 1) {
                return [UIImage imageNamed:@"filter_7_on.png"]; 
            }else {
                return [UIImage imageNamed:@"filter_6_on.png"]; 
            }
        }
        
    }
}

- (UIImage *)flyImage
{
    return [UIImage imageNamed:@"fly_p1.png"];
}

- (UIImage *)placeTourBgImage
{
    return [UIImage strectchableImageName:@"line_table_2b.png" topCapHeight:5];
}

- (UIImage *)placeTourBtnBgImage
{
    return [UIImage strectchableImageName:@"line_table_2a.png" topCapHeight:5];
}
    
- (UIImage *)accommodationBgImage:(BOOL)isLast
{
    return [UIImage imageNamed:(isLast ? @"line_n_t4.png" : @"line_n_t7.png")];
}

- (UIImage *)allBackgroundImage
{
    if ([DeviceDetection isIPhone5]) {
        return [UIImage imageNamed:@"all_page_bg2_i5.jpg"];
    } else {
        return [UIImage imageNamed:@"all_page_bg2.jpg"];
    }
}

- (UIImage *)hotelListBgImage
{
    return [UIImage strectchableImageName:@"hotel_list_bg.png"];
}

- (UIImage *)flightListTopBgImage
{
    return [UIImage strectchableImageName:@"flight_top_bg.png"];
}

- (UIImage *)flightListBottomBgImage
{
    return [UIImage strectchableImageName:@"flight_bottom_bg.png"];
}

@end
