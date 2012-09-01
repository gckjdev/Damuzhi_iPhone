//
//  CommonWebController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "CityOverviewService.h"


@protocol CommonWebDataSourceProtocol <NSObject>
- (NSString*)getTitleName;
- (void)requestDataWithDelegate:(PPViewController<CityOverviewServiceDelegate>*)delegate;
+ (NSObject<CommonWebDataSourceProtocol>*)createDataSource;

@end

@interface CommonWebController : PPViewController <UIWebViewDelegate, CityOverviewServiceDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString *htmlPath;
@property (retain, nonatomic) NSObject<CommonWebDataSourceProtocol> *dataSource;

- (CommonWebController*)initWithWebUrl:(NSString*)htmlPath;

- (id)initWithDataSource:(NSObject<CommonWebDataSourceProtocol>*)source;

- (void)showInView:(UIView *)superView;

@end
