//
//  HotelHeaderView.m
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "HotelHeaderView.h"
#import "Place.pb.h"

@interface HotelHeaderView ()

@property (assign, nonatomic) NSInteger section;

@end


@implementation HotelHeaderView
@synthesize section = _section;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_iconImageView release];
    [_nameLabel release];
    [_starLabel release];
    [_rankView release];
    [_priceLabel release];
    [_selectButton release];
    [super dealloc];
}

+ (id)createHeaderView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HotelHeaderView" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create HotelHeaderView but cannot find Nib");
        return nil;
    }
    
    return [topLevelObjects objectAtIndex:0];
}

+ (CGFloat)getHeaderViewHeight
{
    return 50;
}

- (void)setViewWith:(Place *)hotel section:(NSInteger)section
{
    self.section = section;
    self.nameLabel.text = hotel.name;
}

- (IBAction)clickSelectButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickSelectButton:)]) {
        [_delegate didClickSelectButton:_section];
    }
}

@end
