//
//  ContainerViewController.h
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "ParallelViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParallelShoppingModeViewController : ParallelViewController

@property(nonatomic,getter=isNavigationBarHidden) BOOL navigationBarHidden;

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.

@end


NS_ASSUME_NONNULL_END
