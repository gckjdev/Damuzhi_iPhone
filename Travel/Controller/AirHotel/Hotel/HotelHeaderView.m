//
//  HotelHeaderView.m
//  Travel
//
//  Created by haodong on 12-11-24.
//
//

#import "HotelHeaderView.h"
#import "Place.pb.h"
#import "PPApplication.h"
#import "PlaceUtils.h"

@interface HotelHeaderView ()

@property (assign, nonatomic) NSInteger section;

@end


@implementation HotelHeaderView
@synthesize section = _section;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_nameLabel release];
    [_starLabel release];
    [_rankView release];
    [_priceLabel release];
    [_selectButton release];
    [_iconView release];
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
    
    //set icon
    self.iconView.image = [UIImage imageNamed:@"default_s.png"];
    self.iconView.callbackOnSetImage = self;
    self.iconView.url = [NSURL URLWithString:[hotel icon]];;
    [GlobalGetImageCache() manage:self.iconView];
    
    //set star
    self.starLabel.text = [PlaceUtils hotelStarToString:hotel.hotelStar];
    
    //set price
    self.priceLabel.text = [NSString stringWithFormat:@"参考价格:%@",[PlaceUtils getPrice:hotel]];
    
    
    for (int rank = 0 ; rank < 3; rank ++) {
        
    }
    
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (void) managedImageCancelled:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (IBAction)clickSelectButton:(id)sender {
    
    _selectButton.selected = !_selectButton.selected;
    
    if ([_delegate respondsToSelector:@selector(didClickSelectButton:)]) {
        [_delegate didClickSelectButton:_section];
    }
}

@end
