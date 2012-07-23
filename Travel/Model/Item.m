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

+ (Item *)itemWithId:(int)itemId
            itemName:(NSString *)itemName
               count:(int)count
{
    return [[[Item alloc] initWithItemId:itemId itemName:itemName count:count] autorelease];;
}

+ (Item *)itemWithNameIdPair:(NameIdPair *)pair
                       count:(int)count
{
    return [[[Item alloc] initWithNameIdPair:pair count:count] autorelease];
}

+ (Item *)itemWithStatistics:(Statistics *)statics
{
    return [[[Item alloc] initWithItemId:statics.id itemName:statics.name count:statics.count] autorelease];
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
