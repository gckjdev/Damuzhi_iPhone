//
//  ReferenceCell.h
//  Travel
//
//  Created by haodong qiu on 12年7月24日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewCell.h"

@protocol ReferenceCellDelegate <NSObject>

@optional
- (void)didLoadReferenceContent:(UIWebView *)webView;

@end


@interface ReferenceCell : PPTableViewCell

@property (retain, nonatomic) IBOutlet UIWebView *contentWebView;

@end
