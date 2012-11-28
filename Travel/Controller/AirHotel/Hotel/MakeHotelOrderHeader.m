//
//  MakeHotelOrderHeader.m
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import "MakeHotelOrderHeader.h"

@implementation MakeHotelOrderHeader

+ (id)createHeaderView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MakeHotelOrderHeader" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create HotelHeaderView but cannot find Nib");
        return nil;
    }
    
    return [topLevelObjects objectAtIndex:0];
}

+ (CGFloat)getHeaderViewHeight
{
    return 44;
}

@end