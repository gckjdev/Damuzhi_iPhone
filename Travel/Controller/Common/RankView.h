//
//  RankView.h
//  Travel
//
//  Created by haodong qiu on 12年7月3日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankView : UIView

- (id)initWithGoodImage:(UIImage *)goodImage 
               badImage:(UIImage *)badImage 
              imageSize:(CGSize)imageSize 
                  space:(CGFloat)space 
               maxCount:(NSInteger)maxCount 
                   rank:(NSInteger)rank;

@end
