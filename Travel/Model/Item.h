//
//  Item.h
//  Travel
//
//  Created by 小涛 王 on 12-6-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.pb.h"

@interface Item : NSObject

@property (assign, nonatomic) int itemId;
@property (copy, nonatomic) NSString *itemName;
@property (assign, nonatomic) int count;

- (Item*)initWithItemId:(int)itemId
               itemName:(NSString *)itemName
                  count:(int)count;

- (Item*)initWithNameIdPair:(NameIdPair*)nameIdPair
                      count:(int)count;

@end
