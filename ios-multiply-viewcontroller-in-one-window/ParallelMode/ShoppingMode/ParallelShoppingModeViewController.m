//
//  ContainerViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/12.
//

#import "ParallelShoppingModeViewController.h"
#import "ParallelChildViewControllerWrapperView.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import <objc/runtime.h>

#define HingeWidth 5


@interface ParallelShoppingModeViewController ()<ParallelChildViewContollerWrapperViewDelegate>
@end

@implementation ParallelShoppingModeViewController

#pragma mark -Override ViewController Methods

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)layoutParallViewControllers{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    //Two front two viewcontrollers fixed on the left and right side
    UIViewController * leftVC = [self.viewControllers objectAtIndex:0];
    [self addLeftView:leftVC];
    
    UIViewController * rightVC = [self.viewControllers objectAtIndex:1];
    [self addRightView:rightVC];
    
    leftVC.isRootViewController = YES;
    rightVC.isRootViewController = YES;

    // hidden the two root viewcontroller's navigation bar
    ParallelChildViewControllerWrapperView * leftWrapper = [self getWrapperViewByViewController:leftVC];
    [leftWrapper hiddenNavigationBar:YES];
    
    ParallelChildViewControllerWrapperView * rightWrapper = [self getWrapperViewByViewController:rightVC];
    [rightWrapper hiddenNavigationBar:YES];
    
    if (self.viewControllers.count > 2) {
        // Except for the first two viewcontrollers and the last one, the rest are placed to the left
        if (self.viewControllers.count>3) {
            for (int i = 2; i<self.viewControllers.count-1; i++) {
                UIViewController * leftVC = [self.viewControllers objectAtIndex:i];
                [self addLeftView:leftVC];
            }
        }
        //Top viewcontroller on the stack always place to the right
        UIViewController * rightVC = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
        [self addRightView:rightVC];
    }
}

-(void)updateViewControllers:(CGSize)size{
    NSAssert(self.viewControllers.count>=2, @"self.viewControllers count can't less than 2");
    
    CGFloat halfWidth = (size.width - HingeWidth)/2.0;
    CGRect leftViewFrame = CGRectMake(0, 0, halfWidth, size.height);
    CGRect rightViewFrame = CGRectMake(halfWidth + HingeWidth, 0, size.width/2.0, size.height);

    for (int i = 0 ; i<self.viewControllers.count; i++) {
        UIViewController * vc = [self.viewControllers objectAtIndex:i];
        ParallelChildViewControllerWrapperView *wrapper = [self getWrapperViewByViewController:vc];
        if(i == 1 || i == (self.viewControllers.count-1)){
            wrapper.frame = rightViewFrame;
        }else{
            wrapper.frame = leftViewFrame;
        }
    }
}

- (void)cycleFromViewController: (UIViewController*) oldVC
               toViewController: (UIViewController*) newVC
                       animated:(BOOL) animated{
    
    ParallelChildViewControllerWrapperView * oldWrapperView = [self getWrapperViewByViewController:oldVC];
    NSAssert(oldWrapperView!=nil, @"can not find wrapperview by id");
    
    if (!animated) {
        if (oldVC) {
            oldWrapperView.frame = [self leftViewFrame];
        }
        
        [self addRightView:newVC];
    }else{
        [self addChildViewController:newVC];
        
        ParallelChildViewControllerWrapperView * newWrapperView = [self appendWrapperViewWithViewController:newVC wrapperFrame:[self newViewStartFrame]];

        oldWrapperView.frame = [self oldViewStartFrame];
        
        [UIView animateWithDuration:0.25
                          animations:^{
                            newWrapperView.frame = [self newViewEndFrame];;
                            oldWrapperView.frame = [self leftViewFrame];
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

#pragma mark Public Methods
-(BOOL)isNavigationBarHidden{
    return _navigationBarHidden;
}
@end
