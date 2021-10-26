//
//  ParallelNavigationModeViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import "ParallelNavigationModeViewController.h"
#import "ParallelChildViewControllerWrapperView.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import <objc/runtime.h>

#define HingeWidth 5

@interface ParallelNavigationModeViewController ()<ParallelChildViewContollerWrapperViewDelegate>{
    UINavigationController *_leftNavigationController;
    UINavigationController *_rightNavigationController;
    UIDeviceOrientation _lastOrientation;
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
    NSLog(@"viewWillTransitionToSize ,width:%f,height:%f",size.width,size.height);
    [self updateViewControllers:size orientation:[UIDevice currentDevice].orientation];
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
    _leftNavigationController = [[UINavigationController alloc]initWithRootViewController:[self.viewControllers objectAtIndex:0]];
    [self addLeftView:_leftNavigationController];
    
    _rightNavigationController = [[UINavigationController alloc]initWithRootViewController:[self.viewControllers objectAtIndex:1]];
    [self addRightView:_rightNavigationController];

    // hide the two root viewcontroller's navigation bar
    ParallelChildViewControllerWrapperView * leftWrapper = [self getWrapperViewByViewController:_leftNavigationController];
    [leftWrapper hiddenNavigationBar:YES];
    ParallelChildViewControllerWrapperView * rightWrapper = [self getWrapperViewByViewController:_rightNavigationController];
    [rightWrapper hiddenNavigationBar:YES];
    
    _leftNavigationController.isRootViewController = YES;
    _rightNavigationController.isRootViewController = YES;
    
    _lastOrientation = [UIDevice currentDevice].orientation;
}

-(void)updateViewControllers:(CGSize)size orientation:(UIDeviceOrientation)orientation{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        CGFloat halfWidth = (size.width - HingeWidth)/2.0;
        CGRect leftViewFrame = CGRectMake(0, 0, halfWidth, size.height);
        CGRect rightViewFrame = CGRectMake(halfWidth + HingeWidth, 0, size.width/2.0, size.height);
        
        // left-right display split when Portrait
        ParallelChildViewControllerWrapperView * leftWrapper = [self getWrapperViewByViewController:_leftNavigationController];
        leftWrapper.frame = leftViewFrame;
        
        ParallelChildViewControllerWrapperView * rightWrapper = [self getWrapperViewByViewController:_rightNavigationController];
        rightWrapper.frame = rightViewFrame;
    }else{
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        ParallelChildViewControllerWrapperView * leftWrapper = [self getWrapperViewByViewController:_leftNavigationController];
        leftWrapper.frame = frame;
        
    }
    _lastOrientation = orientation;
}

-(ParallelChildViewControllerWrapperView *)appendWrapperViewWithViewController:(UIViewController *)vc wrapperFrame:(CGRect) wrapperFrame {
    ParallelChildViewControllerWrapperView * wrapperView = [super appendWrapperViewWithViewController:vc wrapperFrame:wrapperFrame];
    vc.view.frame = [self childViewFrame];
    wrapperView.delegate = self;
    return wrapperView;
}

#pragma mark  ParallelChildViewContollerWrapperViewDelegate
-(void)onClickBack:(ParallelChildViewControllerWrapperView *)wrapperView viewController:(UIViewController *)viewController{
    [self popViewControllerAnimated:YES];
}
@end
