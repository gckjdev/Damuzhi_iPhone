//
//  RankView.m
//  Travel
//
//  Created by haodong qiu on 12年7月3日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "RankView.h"

@implementation RankView


- (id)initWithGoodImage:(UIImage *)goodImage 
               badImage:(UIImage *)badImage 
              imageSize:(CGSize)imageSize 
                  space:(CGFloat)space 
               maxCount:(NSInteger)maxCount 
                   rank:(NSInteger)rank
{
    if (maxCount <= 0) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, maxCount * (imageSize.width + space) - space, imageSize.height);
        
        for (NSInteger i = 0 ; i < maxCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (imageSize.width + space) , 0, imageSize.width, imageSize.height)];
            [imageView setImage:(i < rank ? goodImage : badImage)];
            [self addSubview:imageView];
            [imageView release];
        }
    }
    return self;
}


@end
