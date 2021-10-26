//
//  ParallelNavigationModeViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import "ParallelNavigationModeViewController.h"
#import "ParallelChildViewContollerWrapperView.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import <objc/runtime.h>

#define HingeWidth 5

@interface ParallelNavigationModeViewController ()<ParallelChildViewContollerWrapperViewDelegate>{
    UINavigationController *_rightNavigationController;
}
@end

@implementation ParallelNavigationModeViewController


#pragma mark -Override ViewController Methods

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ParallelViewController frame x:%f,y:%f,width:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    self.view.backgroundColor = [UIColor blackColor];

    [self layoutParallViewControllers];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [self updateViewControllers:size];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override Super Methods (NavigationController-liked Methods)
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [_rightNavigationController pushViewController:viewController animated:animated];
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
   return [_rightNavigationController popViewControllerAnimated:animated];
}

#pragma mark - Private Methods

-(void)layoutParallViewControllers{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    //Two front two viewcontrollers fixed on the left and right side
    UIViewController * leftVC = [self.viewControllers objectAtIndex:0];
    [self addLeftView:leftVC];
    _rightNavigationController = [[UINavigationController alloc]initWithRootViewController:[self.viewControllers objectAtIndex:1]];
    [self addRightView:_rightNavigationController];

    // hide the two root viewcontroller's navigation bar
    ParallelChildViewContollerWrapperView * leftWrapper = [self getWrapperViewByViewController:leftVC];
    [leftWrapper hiddenNavigationBar:YES];
    ParallelChildViewContollerWrapperView * rightWrapper = [self getWrapperViewByViewController:_rightNavigationController];
    [rightWrapper hiddenNavigationBar:YES];
    
    leftVC.isRootViewController = YES;
    _rightNavigationController.isRootViewController = YES;
}

-(void)updateViewControllers:(CGSize)size{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    CGFloat halfWidth = (size.width - HingeWidth)/2.0;
    CGRect leftViewFrame = CGRectMake(0, 0, halfWidth, size.height);
    CGRect rightViewFrame = CGRectMake(halfWidth + HingeWidth, 0, size.width/2.0, size.height);
    
    ParallelChildViewContollerWrapperView *wrapper = [self getWrapperViewByViewController:[self.viewControllers objectAtIndex:0]];
    wrapper.frame = leftViewFrame;

    ParallelChildViewContollerWrapperView * rightWrapper = [self getWrapperViewByViewController:_rightNavigationController];
    rightWrapper.frame = rightViewFrame;
}

-(ParallelChildViewContollerWrapperView *)appendWrapperViewWithViewController:(UIViewController *)vc wrapperFrame:(CGRect) wrapperFrame {
    ParallelChildViewContollerWrapperView * wrapperView = [super appendWrapperViewWithViewController:vc wrapperFrame:wrapperFrame];
    vc.view.frame = [self childViewFrame];
    wrapperView.delegate = self;
    return wrapperView;
}

#pragma mark  ParallelChildViewContollerWrapperViewDelegate
-(void)onClickBack:(ParallelChildViewContollerWrapperView *)wrapperView viewController:(UIViewController *)viewController{
    [self popViewControllerAnimated:YES];
}

#pragma mark Public Methods
-(BOOL)isNavigationBarHidden{
    return YES;
}
@end