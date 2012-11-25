//
//  HotelHeaderView.m
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "HotelHeaderView.h"

@implementation HotelHeaderView

+ (id)createHeader
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HotelHeaderView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create HotelHeaderView but cannot find Nib");
        return nil;
    }
    
    return [topLevelObjects objectAtIndex:0];
}




@end
