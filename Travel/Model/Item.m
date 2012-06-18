//
//  Item.m
//  Travel
//
//  Created by 小涛 王 on 12-6-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize itemId = _itemId;
@synthesize itemName = _itemName;
@synthesize count = _count;

- (void)dealloc
{
    [_itemName release];
    [super dealloc];
}

- (Item*)initWithItemId:(int)itemId
               itemName:(NSString *)itemName
                  count:(int)count
{
    self = [super init];
    if (self) {
        self.itemId = itemId;
        self.itemName = itemName;
        self.count = count;
    }
    
    return self;
}

- (Item*)initWithNameIdPair:(NameIdPair*)nameIdPair
                      count:(int)count
{
    self = [super init];
    if (self) {
        self.itemId = nameIdPair.id;
        self.itemName = nameIdPair.name;
        self.count = count;
    }
    
    return self;
}

@end
