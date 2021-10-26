//
//  ParallelWrapperView.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/15.
//

#import "ParallelChildViewContollerWrapperView.h"
#import "ParallelShoppingModeViewController.h"
#import "UIViewController+ParallelViewControllerItem.h"

@implementation ParallelChildViewContollerWrapperView

-(instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController*)vc{
    self = [super initWithFrame:frame];
    if (self) {
        _viewController = vc;
    }
    return self;
}

#pragma mark - Override View Methods
-(void)layoutSubviews{
    if (![_viewController isRootViewController]) {        
        UINavigationBar * naviBar = [self getNavigationBar:_viewController];
        [self addSubview:naviBar];
        [super layoutSubviews];
    }
}

-(void)updateConstraints{
    [self updateNavigationBarConstraint];
    [super updateConstraints];
}

#pragma mark - Private Method

-(void)hiddenNavigationBar:(BOOL)hidden{
    if (_navigationBar) {
        _navigationBar.hidden = hidden;
    }
}

- (UINavigationBar *)getNavigationBar:(UIViewController *)vc {
    
    UIView * rootView = vc.view;
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = 44.f + statusHeight;

    UINavigationBar * naviBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, rootView.bounds.size.width, navigationBarHeight)];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onClickBackAction:)];

    UINavigationItem *navigItem = [vc parallelNavigationItem];
    navigItem.leftBarButtonItem = cancelItem;
    naviBar.items = [NSArray arrayWithObjects: navigItem,nil];
    naviBar.tag = 1234;
    return naviBar;
}

-(void)onClickBackAction:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBack:viewController:)]) {
        [_delegate onClickBack:self viewController:_viewController];
    }
}

- (void)updateNavigationBarConstraint
{
    if (!_navigationBar) {
        return ;
    }
    NSAssert(_navigationBar, @"_navigationBar can not nil");
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = 44.f + statusHeight;

    NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:_navigationBar
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:navigationBarHeight];


    NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:_navigationBar
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:1
                                                                          constant:200];

    NSLayoutConstraint * leadingConstraint = [NSLayoutConstraint constraintWithItem:_navigationBar
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];

    NSLayoutConstraint * topConstraint = [NSLayoutConstraint constraintWithItem:_navigationBar
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:(NSLayoutAttributeTop)
                                                                     multiplier:1
                                                                       constant:0];
    
    [_navigationBar addConstraints:@[widthConstraint,heightConstraint,leadingConstraint,topConstraint]];
}


@end
