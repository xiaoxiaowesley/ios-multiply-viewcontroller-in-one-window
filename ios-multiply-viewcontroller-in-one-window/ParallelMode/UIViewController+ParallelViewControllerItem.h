//
//  UIViewController+ParallelViewControllerItem.h
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import <UIKit/UIKit.h>
#import "ParallelViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (ParallelViewControllerItem)
@property(nonatomic,readonly,strong) UINavigationItem *parallelNavigationItem;
@property(nullable,nonatomic,readwrite,strong) ParallelViewController *parallelViewController;
@property(nonatomic,readwrite,assign) BOOL isRootViewController;
@end

NS_ASSUME_NONNULL_END
