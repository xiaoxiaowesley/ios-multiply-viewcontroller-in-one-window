//
//  ParallelViewController.h
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import <UIKit/UIKit.h>
#import "ParallelChildViewContollerWrapperView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParallelViewController : UIViewController
-(instancetype)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *) rightViewController;
-(void)addViewController:(UIViewController *)viewController;
@property(nonatomic,readonly) NSArray<__kindof UIViewController *> * viewControllers;

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;

-(ParallelChildViewContollerWrapperView *)getWrapperViewByViewController:(UIViewController *)vc;

-(ParallelChildViewContollerWrapperView *)appendWrapperViewWithViewController:(UIViewController *)vc wrapperFrame:(CGRect) wrapperFrame;

-(void)addLeftView:(UIViewController *)vc;

-(void)addRightView:(UIViewController *)vc;

-(CGFloat)halfWidth;

-(CGRect)childViewFrame;

-(CGRect)leftViewFrame;

-(CGRect)rightViewFrame;

-(CGRect)newViewStartFrame;

-(CGRect)newViewEndFrame;

-(CGRect)oldViewEndFrame;

-(CGRect)oldViewStartFrame;
@end

NS_ASSUME_NONNULL_END
