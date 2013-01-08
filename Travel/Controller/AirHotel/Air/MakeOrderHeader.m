//
//  MakeOrderHeader.m
//  Travel
//
//  Created by haodong on 12-11-28.
//
//

#import "MakeOrderHeader.h"
#import "LocaleUtils.h"
#import "LogUtil.h"

@interface MakeOrderHeader()
@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) id<MakeOrderHeaderDelegate> delegate;
@end

@implementation MakeOrderHeader
@synthesize section = _section;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_buttonHolderView release];
    [_closeButton release];
    [_iconImageView release];
    [_titleLabel release];
    [_deleteButton release];
    [super dealloc];
}

+ (id)createHeaderView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MakeOrderHeader" owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create MakeOrderHeader but cannot find Nib");
        return nil;
    }
    
    return [topLevelObjects objectAtIndex:0];
}

+ (CGFloat)getHeaderViewHeight
{
    return 44;
}

- (void)setViewWithDelegate:(id<MakeOrderHeaderDelegate>)delegate
                    section:(NSInteger)section
         airHotelHeaderType:(AirHotelHeaderType)type
         isHideFilterButton:(BOOL)isHideFilterButton
        selectedButtonIndex:(int)index
          isHideCloseButton:(BOOL)isHideCloseButton
                    isClose:(BOOL)isClose
         isHideDeleteButton:(BOOL)isHideDeleteButton
{
    self.delegate = delegate;
    self.section = section;
    
    if (type == AirHeader) {
        self.titleLabel.text = NSLS(@"机票");
        self.iconImageView.image = [UIImage imageNamed:@"ticket_p1.png"];
    } else if (type == HotelHeader) {
        self.titleLabel.text = NSLS(@"酒店");
        self.iconImageView.image = [UIImage imageNamed:@"hotel_p1.png"];
    }
    
    self.buttonHolderView.hidden = isHideFilterButton;
    if (isHideFilterButton == NO) {
        [self updateSelectedButton:index];
    }
    
    self.closeButton.hidden = isHideCloseButton;
    self.closeButton.selected = isClose;

    self.deleteButton.hidden = isHideDeleteButton;
}

- (void)updateSelectedButton:(int)index
{
    for (int tag = 1; tag <= 3; tag ++) {
        UIButton *button = (UIButton *)[self.buttonHolderView viewWithTag:tag];
        if (tag == index) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }
}

- (IBAction)clickCloseButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    if ([_delegate respondsToSelector:@selector(didClickCloseButton:)]) {
        [_delegate didClickCloseButton:_section];
    }
}

- (IBAction)clickDeleteButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickDeleteButton:)]) {
        [_delegate didClickDeleteButton:_section];
    }
}

- (IBAction)clickGoButton:(id)sender {
    [self updateSelectedButton:1];
    if ([_delegate respondsToSelector:@selector(didClickGoButton)]) {
        [_delegate didClickGoButton];
    }
}

- (IBAction)clickGoAndBackButton:(id)sender {
    [self updateSelectedButton:2];
    if ([_delegate respondsToSelector:@selector(didClickGoAndBackButton)]) {
        [_delegate didClickGoAndBackButton];
    }
}

- (IBAction)clickBackButton:(id)sender {
    [self updateSelectedButton:3];
    if ([_delegate respondsToSelector:@selector(didClickBackButton)]) {
        [_delegate didClickBackButton];
    }
}


@end
