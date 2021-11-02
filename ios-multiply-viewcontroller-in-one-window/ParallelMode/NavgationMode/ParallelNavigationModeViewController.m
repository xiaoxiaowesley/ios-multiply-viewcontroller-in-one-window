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


@interface ParallelNavigationModeViewController ()<ParallelChildViewContollerWrapperViewDelegate>
@end

@implementation ParallelNavigationModeViewController

#pragma mark -Override ViewController Methods

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViewControllers];
    [self updateViewControllers:self.view.bounds.size orientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    [self updateViewControllers:size orientation:[[UIApplication sharedApplication] statusBarOrientation]];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override Super Methods (NavigationController-liked Methods)
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Run animation if
    UIViewController * oldRight = self.viewControllers.lastObject;
    //Show push animation
    [self cycleFromViewController:oldRight toViewController:viewController animated:YES];
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.viewControllers.count>2) {
        
        UIViewController * secondToLastViewController = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
        UIViewController * lastViewController  = [self.viewControllers objectAtIndex:self.viewControllers.count-1];

        UIView * secondToLastWrapper = [super getWrapperViewByViewController:secondToLastViewController];
        UIView * lastWrapper = [super getWrapperViewByViewController:lastViewController];

        [lastViewController willMoveToParentViewController:nil];
        if (animated) {
            
            [UIView animateWithDuration:0.25
                              animations:^{
                                lastWrapper.frame = [self newViewStartFrame];
                                secondToLastWrapper.frame = [self rightViewFrame];
                                }
                             completion:^(BOOL finished) {
                                [lastWrapper removeFromSuperview];
                                [lastViewController removeFromParentViewController];
            }];
        }else{
            // WrapperView removeFromSuperView,ViewController remove from ParentView
            [lastWrapper removeFromSuperview];
            [lastViewController removeFromParentViewController];
            //Move to right side because Second to last ViewController become the last ViewController
            secondToLastWrapper.frame = [self rightViewFrame];
        }
      
        [super popViewControllerAnimated:animated];
        return lastViewController;
    }else{
        NSLog(@"can not pop");
        return nil;
    }
}

#pragma mark - Private Methods

-(void)layoutViewControllers{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    //Two front two viewcontrollers fixed on the left and right side
    UIViewController * bottomVC = [self.viewControllers objectAtIndex:0];
    [self addLeftView:bottomVC];
    
    UIViewController * nextToBottomVC = [self.viewControllers objectAtIndex:1];
    [self addRightView:nextToBottomVC];
    
    bottomVC.isRootViewController = YES;
    nextToBottomVC.isRootViewController = YES;

    // hidden the two root viewcontroller's navigation bar
    ParallelChildViewControllerWrapperView * bottomWrapper = [self getWrapperViewByViewController:bottomVC];
    [bottomWrapper hiddenNavigationBar:YES];
    
    ParallelChildViewControllerWrapperView * nextToBottomWrapper = [self getWrapperViewByViewController:nextToBottomVC];
    [nextToBottomWrapper hiddenNavigationBar:YES];
}

-(void)updateViewControllers:(CGSize)size orientation:(UIInterfaceOrientation)orientation{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    CGFloat halfWidth = (size.width - HingeWidth)/2.0;
    CGRect leftViewFrame = CGRectMake(0, 0, halfWidth, size.height);
    CGRect rightViewFrame = CGRectMake(halfWidth + HingeWidth, 0, size.width/2.0, size.height);

    if (UIInterfaceOrientationIsPortrait(orientation)) {
        for (int i = 0 ; i<self.viewControllers.count; i++) {
            UIViewController * vc = [self.viewControllers objectAtIndex:i];
            ParallelChildViewControllerWrapperView *wrapper = [self getWrapperViewByViewController:vc];
            if(i == 1){
                wrapper.frame = CGRectMake(size.width, size.height, size.width, size.height);
            }else{
                wrapper.frame = CGRectMake(0, 0, size.width, size.height);
                [self.view bringSubviewToFront:wrapper];
            }
        }
    }else if (UIInterfaceOrientationIsLandscape(orientation)){
        for (int i = 0 ; i<self.viewControllers.count; i++) {
            UIViewController * vc = [self.viewControllers objectAtIndex:i];
            ParallelChildViewControllerWrapperView *wrapper = [self getWrapperViewByViewController:vc];
            if(i == 0){
                wrapper.frame = leftViewFrame;
            }else{
                wrapper.frame = rightViewFrame;
            }
            [self.view bringSubviewToFront:wrapper];
        }
    }
}

- (void)cycleFromViewController: (UIViewController*) oldVC
               toViewController: (UIViewController*) newVC
                       animated:(BOOL) animated{
    ParallelChildViewControllerWrapperView * oldWrapperView = [self getWrapperViewByViewController:oldVC];
    NSAssert(oldWrapperView!=nil, @"can not find wrapperview by id");
    if (!animated) {
        [self addNewView:newVC];
    }else{
        [self addChildViewController:newVC];
        
        ParallelChildViewControllerWrapperView * newWrapperView = [self appendWrapperViewWithViewController:newVC
                                                                                               wrapperFrame:[self newViewControllerBeginFrame]];
        
        [UIView animateWithDuration:0.25
                          animations:^{
                            newWrapperView.frame = [self newViewControllerEndFrame];;
                            }
                         completion:^(BOOL finished) {
                            [newVC didMoveToParentViewController:self];
         }];
    }
}

-(void)addLeftView:(UIViewController *)vc{
    [self addChildViewController:vc];
    [self appendWrapperViewWithViewController:vc wrapperFrame:[self leftViewFrame]];
    [vc didMoveToParentViewController:self];
}

-(void)addRightView:(UIViewController *)vc{
    [self addChildViewController:vc];
    [self appendWrapperViewWithViewController:vc wrapperFrame:[self rightViewFrame]];
    [vc didMoveToParentViewController:self];
}

-(void)addNewView:(UIViewController *)vc{
    [self addChildViewController:vc];
    [self appendWrapperViewWithViewController:vc wrapperFrame:[self rightViewFrame]];
    [vc didMoveToParentViewController:self];
}

-(CGRect)newViewControllerBeginFrame{
    if (UIInterfaceOrientationIsPortrait([self currentOrientation])) {
        CGRect rect = [super fullScreenModeFrame];
        return CGRectMake(rect.size.width, rect.size.height,rect.size.width, rect.size.height);
    }else{
        return [super newViewStartFrame];
    }
}

-(CGRect)newViewControllerEndFrame{
    if (UIInterfaceOrientationIsPortrait([self currentOrientation])) {
        return [super fullScreenModeFrame];
    }else{
        return [super splitModeRightFrame];
    }
}

-(UIInterfaceOrientation)currentOrientation{
    return [[UIApplication sharedApplication] statusBarOrientation];
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
