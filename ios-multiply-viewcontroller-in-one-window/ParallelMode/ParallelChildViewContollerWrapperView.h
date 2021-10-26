//
//  ParallelWrapperView.h
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ParallelChildViewContollerWrapperView;
@protocol ParallelChildViewContollerWrapperViewDelegate <NSObject>
-(void)onClickBack:(ParallelChildViewContollerWrapperView *)wrapperView viewController:(UIViewController *)viewController;
@end

@interface ParallelChildViewContollerWrapperView : UIView
-(instancetype)initWithFrame:(CGRect)frame viewController:(nonnull UIViewController*)vc;
-(void)hiddenNavigationBar:(BOOL)hidden;
@property(nonatomic,readonly,strong)UINavigationBar * navigationBar;
@property(nonatomic,weak) UIViewController *viewController;
@property(nullable, nonatomic, weak) id<ParallelChildViewContollerWrapperViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
