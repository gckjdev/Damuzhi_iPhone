//
//  MakeAirOrderHeader.m
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import "MakeAirOrderHeader.h"

@implementation MakeAirOrderHeader

+ (id)createHeaderView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MakeAirOrderHeader" owner:self options:nil];
    
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
