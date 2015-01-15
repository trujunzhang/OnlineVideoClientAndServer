//
//  VITabBar.m
//  Vinoli
//
//  Created by Nicolas Goles on 6/6/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "JZGGIconTabBar.h"


@interface JZGGIconTabBar () {
    UIButton *_selectedButton;
}
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *tabBarItemArrays;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *separators; // Between-buttons separators
@property (nonatomic, strong) NSMutableArray *marginSeparators; // Start/End Separators

// Appearance
@property (nonatomic, assign) CGFloat tabBarHeight;
@property (nonatomic, strong) UIColor *tabBarBackgroundColor;
@property (nonatomic, strong) UIColor *tabBarTintColor;

// References to Constraints
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end


@implementation JZGGIconTabBar

#pragma mark - Public API


- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray *)viewControllers inTop:(BOOL)inTop selectedIndex:(NSInteger)selectedIndex tabBarWidth:(CGFloat)tabBarWidth tabBarItemArrays:(NSMutableArray *)tabBarItemArrays {
    self = [super initWithFrame:frame];
    if(self) {
        self.inTop = inTop;
        _buttons = [[NSMutableArray alloc] init];
        _separators = [[NSMutableArray alloc] init];
        _marginSeparators = [[NSMutableArray alloc] init];
        self.viewControllers = viewControllers;
        self.tabBarItemArrays = tabBarItemArrays;
//      self.tabBarHeight = CGFLOAT_MIN;
        self.tabBarHeight = 80;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self initSubViewsWithControllers:self.tabBarItemArrays];

        [self addHeightConstraints];
        [self addAllLayoutConstraints];

        [self paintDebugViews];
    }
    return self;
}


- (void)setSelectedButton:(id)selectedButton {
    NSUInteger oldButtonIndex = [_buttons indexOfObject:_selectedButton];
    NSUInteger newButtonIndex = [_buttons indexOfObject:selectedButton];

    if(oldButtonIndex != NSNotFound) {
        UITabBarItem *oldTabBarItem = self.tabBarItemArrays[oldButtonIndex];
        [_selectedButton setImage:oldTabBarItem.image forState:UIControlStateNormal];
    }

    if(newButtonIndex != NSNotFound) {
        UITabBarItem *newTabBarItem = self.tabBarItemArrays[newButtonIndex];
        [selectedButton setImage:newTabBarItem.selectedImage forState:UIControlStateNormal];
    }

    _selectedButton = selectedButton;
}


- (void)startDebugMode {
    [self paintDebugViews];
    [self addDebugConstraints];
    [self updateConstraints];
}


#pragma mark - UIView


- (void)didMoveToSuperview {
    // When the app is first launched set the selected button to be the first button
    [self setSelectedButton:[_buttons firstObject]];
}


#pragma mark - Delegate


- (void)tabButtonPressed:(id)sender {
    NSUInteger buttonIndex = [_buttons indexOfObject:sender];
    [self.delegate tabBar:self didPressButton:sender atIndex:buttonIndex];
}


#pragma mark - Subviews


/** takes an array of ViewControllers to internally instanciate
* it's Subview structure. (buttons, separators & margins).
* note: will not lay it out right away.
*/
- (void)initSubViewsWithControllers:(NSArray *)tabBarItemArrays {
    // Add Buttons
    NSUInteger tagCounter = 0;

    for (UITabBarItem *tabBarItem in tabBarItemArrays) {

        UIView *barView;
        UIButton *button = [self getButtonView:tagCounter withTabBarItem:tabBarItem];
        barView = button;

        [self addSubview:barView];
        [_buttons addObject:barView];

        tagCounter++;
    }

    // Add Separators
    NSInteger limit = [self.subviews count] - 1;

    for (int i = 0;i < limit;++i) {
        UIView *separator = [[UIView alloc] init];

        separator.translatesAutoresizingMaskIntoConstraints = NO;
        separator.tag = i + kSeparatorOffsetTag;

        [self addSubview:separator];
        [_separators addObject:separator];
    }

    // Add Margin Separators (we always have two margins)
    for (int i = 0;i < 2;++i) {
        UIView *marginSeparator = [[UIView alloc] init];

        marginSeparator.translatesAutoresizingMaskIntoConstraints = NO;
        marginSeparator.tag = i + kMarginSeparatorOffsetTag;

        [self addSubview:marginSeparator];
        [_marginSeparators addObject:marginSeparator];
    }
}


- (UIButton *)getButtonView:(NSUInteger)tagCounter withTabBarItem:(UITabBarItem *)tabBarItem {
    UIButton *button = [[UIButton alloc] init];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tag = tagCounter;
    [button setImage:tabBarItem.image forState:UIControlStateNormal];
    [button setImage:tabBarItem.selectedImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
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
        UIView *uiView = _buttons[i];
        CGRect rect = CGRectMake(startX, 0, tabBarItemWidth, tabBarHeight);
        uiView.frame = rect;
        CGRect cgRect = uiView.bounds;

        startX = startX + tabBarItemWidth;
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


- (void)addAllLayoutConstraints {
    NSDictionary *viewsDictionary = [self visualFormatStringViewsDictionaryWithButtons:_buttons
                                                                            separators:_separators
                                                                      marginSeparators:_marginSeparators];

    NSString *visualFormatString = [self visualFormatConstraintStringWithButtons:_buttons
                                                                      separators:_separators
                                                                marginSeparators:_marginSeparators];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormatString
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];

    NSMutableArray *allSeparators = [NSMutableArray arrayWithArray:_separators];
    [allSeparators addObjectsFromArray:_marginSeparators];

    [self addConstraints:[self separatorWidthConstraintsWithSeparators:allSeparators]];
    [self addConstraints:[self centerAlignmentConstraintsWithButtons:_buttons
                                                          separators:allSeparators]];
}


- (void)addDebugConstraints {
    [self addConstraints:[self heightConstraintsWithSeparators:_separators]];
    [self addConstraints:[self heightConstraintsWithSeparators:_marginSeparators]];
}


#pragma Creation


- (NSArray *)separatorWidthConstraintsWithSeparators:(NSArray *)separators {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];

    [separators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *separator = (UIView *)obj;
        UIView *targetSeparator;

        if([obj isEqual:[separators lastObject]]) {
            targetSeparator = [separators firstObject];
        } else {
            targetSeparator = [separators objectAtIndex:(idx + 1)];
        }

        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:separator
                                                  attribute:NSLayoutAttributeWidth
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:targetSeparator
                                                  attribute:NSLayoutAttributeWidth
                                                 multiplier:1.0
                                                   constant:0.0];
        [constraints addObject:constraint];
    }];

    return constraints;
}


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


- (NSArray *)centerAlignmentConstraintsWithButtons:(NSArray *)buttons
                                        separators:(NSArray *)separators {
    NSMutableArray *constraints = [[NSMutableArray alloc] init];

    NSMutableArray *buttonsAndSeparators = [[NSMutableArray alloc] init];

    [buttonsAndSeparators addObjectsFromArray:buttons];
    [buttonsAndSeparators addObjectsFromArray:separators];

    // We could iterate through buttons only, but having Y axis
    // aligned separators is more visually pleasing for debugging.
    for (UIView *view in buttonsAndSeparators) {
        NSLayoutConstraint *constraint;
        constraint = [NSLayoutConstraint constraintWithItem:view
                                                  attribute:NSLayoutAttributeCenterY
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                  attribute:NSLayoutAttributeCenterY
                                                 multiplier:1.0
                                                   constant:0.0];
        [constraints addObject:constraint];
    }

    return constraints;
}


#pragma mark Helpers


- (NSDictionary *)visualFormatStringViewsDictionaryWithButtons:(NSArray *)buttons
                                                    separators:(NSArray *)separators
                                              marginSeparators:(NSArray *)marginSeparators {
    // There's always N - 1 Separators
    NSParameterAssert([buttons count] - 1 == [separators count]);

    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];

    for (UIButton *button in buttons) {
        NSString *key = [NSString stringWithFormat:@"button%ld", (long)button.tag];
        viewsDictionary[key] = button;
    }

    for (UIView *separator in separators) {
        NSString *key = [NSString stringWithFormat:@"separator%ld", (long)separator.tag];
        viewsDictionary[key] = separator;
    }

    for (UIView *marginSeparator in marginSeparators) {
        NSString *key = [NSString stringWithFormat:@"marginSeparator%ld", (long)marginSeparator.tag];
        viewsDictionary[key] = marginSeparator;
    }

    return viewsDictionary;
}


- (NSString *)visualFormatConstraintStringWithButtons:(NSArray *)buttons
                                           separators:(NSArray *)separators
                                     marginSeparators:(NSArray *)marginSeparators {
    NSEnumerator *buttonsEnumerator = [buttons objectEnumerator];
    NSMutableArray *constraintParts = [[NSMutableArray alloc] init];

    UIButton *button;
    NSInteger separatorCounter = 0;

    while (button = [buttonsEnumerator nextObject]) {
        NSString *buttonFormat = [NSString stringWithFormat:@"button%ld", (long)button.tag];
        [constraintParts addObject:[NSString stringWithFormat:@"[%@]", buttonFormat]];

        if([button isEqual:[buttons lastObject]]) {
            break;
        }

        UIView *separator = separators[separatorCounter];
        NSString *separatorFormat = [NSString stringWithFormat:@"separator%ld", (long)separator.tag];
        [constraintParts addObject:[NSString stringWithFormat:@"[%@]", separatorFormat]];
        separatorCounter++;
    }

    UIView *firstMarginSeparator = marginSeparators[0];
    UIView *lastMarginSeparator = marginSeparators[1];
    NSMutableString *constraint = [NSMutableString stringWithFormat:@"H:|[marginSeparator%ld]",
                                                                    (long)firstMarginSeparator.tag];
    [constraint appendString:[constraintParts componentsJoinedByString:@""]];
    [constraint appendString:[NSString stringWithFormat:@"[marginSeparator%ld]|", (long)lastMarginSeparator.tag]];

    return constraint;
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

    for (UIView *marginSeparator in _marginSeparators) {
        marginSeparator.backgroundColor = [UIColor greenColor];
    }
}

@end
