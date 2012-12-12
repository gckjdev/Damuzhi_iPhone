//
//  FlightSeatView.m
//  Travel
//
//  Created by haodong on 12-12-11.
//
//

#import "FlightSeatView.h"

@implementation FlightSeatView

+ (id)createFlightSeatView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FlightSeatView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create FlightSeatView but cannot find Nib");
        return nil;
    }
    
    return [topLevelObjects objectAtIndex:0];
}


@end
