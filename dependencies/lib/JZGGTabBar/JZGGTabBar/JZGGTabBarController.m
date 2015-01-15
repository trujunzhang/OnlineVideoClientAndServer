//
//  VITabBarController.m
//  Vinoli
//
//  Created by Nicolas Goles on 5/16/14.
//  Copyright (c) 2014 Goles. All rights reserved.
//

#import "JZGGTabBarController.h"
#import "JZGGTabBar.h"


@interface JZGGTabBarController ()<JZGGTabBarDelegate>
@property (nonatomic, strong) UIView *presentationView;
@property (nonatomic, assign) BOOL isFirstAppear;
@end


@implementation JZGGTabBarController

- (instancetype)initWithTabBarView:(JZGGTabBar *)tabBarView {
    self = [super init];
    if(self) {
        self.tabBarView = tabBarView;
        self.viewControllers = tabBarView.viewControllers;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//   self.view.frame = [[UIScreen mainScreen] bounds];

    _tabBarView.delegate = self;

    _presentationView = [[UIView alloc] init];
    _presentationView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_tabBarView];
    [self.view addSubview:_presentationView];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutTabBarView];
    [_tabBarView needsUpdateConstraints];
    [_tabBarView setNeedsLayout];

    if(_debug) {
        [self startDebugMode];
        [_tabBarView startDebugMode];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    NSParameterAssert(_viewControllers.count > 0);

    // Select first view controller on first Launch.
    if(!_isFirstAppear) {
        _isFirstAppear = YES;
        [self selectViewController:[_viewControllers firstObject]];
    }
}


#pragma mark - Delegation


- (void)tabBar:(JZGGTabBar *)tabBar didPressButton:(id)button atIndex:(NSUInteger)tabIndex {
    UIViewController *selectedViewController = _viewControllers[tabIndex];
    self.selectedIndex = tabIndex;

    if([_delegate respondsToSelector:@selector(ggTabBarController:shouldSelectViewController:)]) {
        if([_delegate ggTabBarController:self shouldSelectViewController:selectedViewController]) {
            [_delegate ggTabBarController:self didSelectViewController:selectedViewController];
        }
    }

    [self selectViewController:selectedViewController withButton:button];
}


# pragma mark - View Controller Selection


- (void)selectViewController:(UIViewController *)viewController withButton:(id)button {
    [_tabBarView setSelectedButton:button];
    [self selectViewController:viewController];
}


- (void)selectViewController:(UIViewController *)viewController {
    UIView *presentedView = [_presentationView.subviews firstObject];
    if(presentedView) {
        [presentedView removeFromSuperview];
    }

    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_presentationView addSubview:viewController.view];
    [self fitView:viewController.view intoView:_presentationView];
}


#pragma mark - Layout


- (void)layoutTabBarView {
    NSDictionary *viewsDictionary = @{@"tabbar_view" : _tabBarView,
            @"presentation_view" : _presentationView};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tabbar_view(400)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[presentation_view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];

    NSString *format = @"V:|[presentation_view][tabbar_view]|";
    if(self.tabBarView.inTop) {
        format = @"V:|[tabbar_view][presentation_view]|";
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
}


- (void)fitView:(UIView *)toPresentView intoView:(UIView *)containerView {
    NSDictionary *viewsDictioanry = @{@"presented_view" : toPresentView};

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[presented_view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictioanry]];
}


#pragma mark - Debug


- (void)startDebugMode {
    _presentationView.backgroundColor = [UIColor yellowColor];
}

@end

