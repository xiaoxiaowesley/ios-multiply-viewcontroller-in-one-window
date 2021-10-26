//
//  ParallelViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import "ParallelViewController.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import <objc/runtime.h>

#define HingeWidth 5

@interface ParallelViewController ()
{
    NSMutableArray<__kindof UIViewController *> * _internalViewControllers;
}
@end

@implementation ParallelViewController

- (instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *) rightViewController{
    
    self = [super init];
    if (self) {
        _internalViewControllers = [[NSMutableArray alloc]init];        
        [self addViewController:leftViewController];
        [self addViewController:rightViewController];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Private Methods

-(void)addViewController:(UIViewController *)viewController{
    viewController.parallelViewController = self;
    [_internalViewControllers addObject:viewController];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    UIViewController * last = [_internalViewControllers lastObject];
    [_internalViewControllers removeLastObject];
    return last;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self addViewController:viewController];
}

#pragma mark - Public Methods
- (NSArray<__kindof UIViewController *> *)viewControllers {
    return _internalViewControllers;
}

-(ParallelChildViewContollerWrapperView *)getWrapperViewByViewController:(UIViewController *)vc{
    NSInteger tag = (NSInteger)vc;
    return (ParallelChildViewContollerWrapperView *)[self.view viewWithTag:tag];
}

-(NSInteger)getWrapperViewTagByViewController:(UIViewController *)vc{
    return (NSInteger)vc;
}

-(ParallelChildViewContollerWrapperView *)appendWrapperViewWithViewController:(UIViewController *)vc wrapperFrame:(CGRect) wrapperFrame{
    ParallelChildViewContollerWrapperView * wrapperView = [[ParallelChildViewContollerWrapperView alloc]initWithFrame:wrapperFrame viewController:vc];
    // convert pointer to NSInteger record tag
    wrapperView.tag = [self getWrapperViewTagByViewController:vc];
    [self.view addSubview:wrapperView];
    [wrapperView addSubview:vc.view];
    return wrapperView;
}

#pragma mark - Helper Methods

-(CGFloat)halfWidth{
    return (self.view.bounds.size.width - HingeWidth)/2.0;
}

-(CGRect)childViewFrame{
    return CGRectMake(0, 0, [self halfWidth], self.view.bounds.size.height);
}

-(CGRect)leftViewFrame{
    return CGRectMake(0, 0, [self halfWidth], self.view.bounds.size.height);
}

-(CGRect)rightViewFrame{
    return CGRectMake([self halfWidth] + HingeWidth, 0, self.view.bounds.size.width/2.0, self.view.bounds.size.height);
}

-(CGRect)newViewStartFrame{
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width/2.0, self.view.bounds.size.height);
}

-(CGRect)newViewEndFrame{
    return [self rightViewFrame];
}

-(CGRect)oldViewEndFrame{
    return [self leftViewFrame];
}

-(CGRect)oldViewStartFrame{
    return [self rightViewFrame];
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
@end
