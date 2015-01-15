//
//  VITabBar.m
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "JZGGLayoutStringTabBar.h"


@interface JZGGLayoutStringTabBar () {
    UILabel *_selectedButton;
    UIView *_divider;
    NSInteger _selectedIndex;
    CGFloat _tabBarWidth;
}

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *separators; // Between-buttons separators

// Appearance
@property (nonatomic, assign) CGFloat tabBarHeight;

// References to Constraints
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end


@implementation JZGGLayoutStringTabBar

#pragma mark - Public API


- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex tabBarWidth:(CGFloat)tabBarWidth tabBarItemArrays:(NSMutableArray *)tabBarItemArrays {
    self = [super initWithFrame:frame];
    if(self) {
        self.inTop = inTop;

        self.backgroundColor = [UIColor whiteColor];

        _selectedIndex = selectedIndex;
        _buttons = [[NSMutableArray alloc] init];
        _separators = [[NSMutableArray alloc] init];
        _tabBarWidth = tabBarWidth;

        self.viewControllers = viewControllers;
        self.tabBarHeight = 46;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initSubViewsWithControllers:self.viewControllers];

        [self addHeightConstraints];
    }
    return self;
}


- (void)setSelectedButton:(UILabel *)selectedButton {
    NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
    NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];

    if(oldButtonIndex != NSNotFound) {
        _selectedButton.backgroundColor = [UIColor whiteColor];
        [_selectedButton setTextColor:[self getDefaultLabelColor]];
    }

    if(newButtonIndex != NSNotFound) {
        [selectedButton setTextColor:[UIColor redColor]];
    }

    _selectedButton = selectedButton;
    _selectedIndex = NSNotFound;

    //[self paintDebugViews];
}


- (UIColor *)getDefaultLabelColor {
    return [UIColor lightGrayColor];
}


- (void)startDebugMode {
    [self paintDebugViews];
    [self addDebugConstraints];
    [self updateConstraints];
}


#pragma mark - UIView


- (void)didMoveToSuperview {
    // When the app is first launched set the selected button to be the first button
//   [self setSelectedButton:[_buttons firstObject]];
}


#pragma mark - Delegate


- (void)tabButtonPressed:(id)sender {
    UITapGestureRecognizer *tapGestureRecognizer = sender;
    NSInteger buttonIndex = tapGestureRecognizer.view.tag;
    NSLog(@"buttonIndex = %i", buttonIndex);

//   NSUInteger buttonIndex = [_buttons indexOfObject:object];
    [self.delegate tabBar:self didPressButton:_buttons[buttonIndex] atIndex:buttonIndex];
}


#pragma mark - Subviews


/** takes an array of ViewControllers to internally instanciate
* it's Subview structure. (buttons, separators & margins).
* note: will not lay it out right away.
*/
- (void)initSubViewsWithControllers:(NSArray *)viewControllers {
    // Add Buttons
    NSUInteger tagCounter = 0;

    for (UIViewController *viewController in viewControllers) {

        UIView *barView;
        UIView *button = [self getButtonView:tagCounter viewController:viewController];
        barView = button;

        [self addSubview:barView];
        [_buttons addObject:barView];

        tagCounter++;
    }

    // Add Separators
    NSInteger limit = [self.subviews count] - 1;

    for (int i = 0;i < limit;++i) {
        UIView *separator = nil;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_separator"]];
        separator = imageView;

        separator.translatesAutoresizingMaskIntoConstraints = NO;
        separator.tag = i + kSeparatorOffsetTag;

        [self addSubview:separator];
        [_separators addObject:separator];
    }

    _divider = [[UIView alloc] init];
    _divider.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_divider];

}


- (UIView *)getButtonView:(NSUInteger)tagCounter viewController:(UIViewController *)viewController {
    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *title = viewController.title;

    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.tag = tagCounter;

    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    titleLabel.textColor = [self getDefaultLabelColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [titleLabel sizeToFit];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tabButtonPressed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.view.tag = tagCounter;
    [titleLabel addGestureRecognizer:tapGestureRecognizer];
    titleLabel.userInteractionEnabled = YES;


    return titleLabel;
}


#pragma mark - Layout -


- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.bounds;

    NSUInteger integer = _separators.count;
    NSUInteger count = _buttons.count;
    [self layoutTabBarItems];

//   _divider.frame = [FrameCalculator frameForBottomDivide:rect.size.width containerHeight:rect.size.height];
}


- (void)layoutTabBarItems {
    CGFloat tabBarHeight = self.frame.size.height;
    NSUInteger buttonCount = _buttons.count;

    CGFloat tabBarItemWidth = [self getTabBarItemWidth:buttonCount];

    CGFloat startX = tabBarPadding;
    for (int i = 0;i < buttonCount;i++) {
        UILabel *label = _buttons[i];
        label.frame = CGRectMake(startX, 0, tabBarItemWidth, tabBarHeight);
        startX = startX + tabBarItemWidth;

        if(i == _selectedIndex && _selectedIndex != NSNotFound) {
            [self.delegate tabBar:self didPressButton:label atIndex:_selectedIndex];
        }

        if(i != buttonCount - 1) {// last item
            UIView *separatorView = _separators[i];
            separatorView.frame = CGRectMake(startX, 0, separatorWidth, tabBarHeight);
            startX = startX + separatorWidth;
        }
    }
}


- (CGFloat)getTabBarItemWidth:(NSUInteger)buttonCount {
    CGFloat aFloat = self.frame.size.width;
    CGFloat totalWidth = (aFloat - tabBarPadding * 2);
    CGFloat allSeperatorWidth = separatorWidth * _separators.count;

    CGFloat tabBarItemWidth = (totalWidth - allSeperatorWidth) / buttonCount;
    return tabBarItemWidth;
}


#pragma mark - Constraints -


- (void)removeSubViews {
    while ([self.subviews count] > 0)
        [[self.subviews lastObject] removeFromSuperview];
}


- (void)reloadTabBarButtons {
    [self removeConstraints:[self constraints]];
    [self removeSubViews];
    [self initSubViewsWithControllers:self.viewControllers];
}


#pragma mark Add


- (void)addHeightConstraints {
    // Adjust the constraint multiplier and item depending if there's a custom tabBarHeight
    CGFloat multiplier = self.tabBarHeight == CGFLOAT_MIN ? 1.5 : 0.0;

    id item = self.tabBarHeight == CGFLOAT_MIN ? [_buttons firstObject] : nil;
    CGFloat layoutConstant = item ? 0.0 : self.tabBarHeight;

    if(_heightConstraint) {
        [self removeConstraint:_heightConstraint];
        _heightConstraint = nil;
    }

    _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:item
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:multiplier
                                                      constant:layoutConstant];

    [self addConstraint:_heightConstraint];
}


- (void)addDebugConstraints {
    [self addConstraints:[self heightConstraintsWithSeparators:_separators]];
}


#pragma Creation


- (NSArray *)heightConstraintsWithSeparators:(NSArray *)separators {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];

    for (UIView *separator in separators) {
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:separator
                                                  attribute:NSLayoutAttributeHeight
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                 multiplier:1.0
                                                   constant:10.0];
        [constraints addObject:constraint];
    }

    return constraints;
}


#pragma mark - Debug


- (void)paintDebugViews {
    self.backgroundColor = [UIColor blueColor];

    for (UIView *button in _buttons) {
        button.backgroundColor = [UIColor whiteColor];
    }

    for (UIView *separator in _separators) {
        separator.backgroundColor = [UIColor redColor];
    }

}

@end
