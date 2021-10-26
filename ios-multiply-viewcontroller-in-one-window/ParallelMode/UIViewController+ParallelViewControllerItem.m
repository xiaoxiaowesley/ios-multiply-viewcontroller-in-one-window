//
//  UIViewController+ParallelViewControllerItem.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import "UIViewController+ParallelViewControllerItem.h"
#import <objc/runtime.h>

static void * ParallelViewControllerPropertyKey = &ParallelViewControllerPropertyKey;
static void * ParallelNavigationItemPropertyKey = &ParallelNavigationItemPropertyKey;
static void * ParallelIsRootViewControllerPropertyKey = &ParallelIsRootViewControllerPropertyKey;

@implementation UIViewController (ParallelViewControllerItem)

- (ParallelViewController *)parallelViewController {
    return objc_getAssociatedObject(self, ParallelViewControllerPropertyKey);
}

- (void)setParallelViewController:(ParallelViewController *)parallelViewController {
    objc_setAssociatedObject(self, ParallelViewControllerPropertyKey, parallelViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UINavigationItem *)parallelNavigationItem{
    UINavigationItem * item = objc_getAssociatedObject(self, ParallelNavigationItemPropertyKey);
    if (!item) {
        item = [[UINavigationItem alloc] init];
        [self setParallelNavigationItem:item];
        return item;
    }else{
        return item;
    }
}

-(void)setParallelNavigationItem:(UINavigationItem *)parallelNavigationItem{
    objc_setAssociatedObject(self, ParallelNavigationItemPropertyKey, parallelNavigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setIsRootViewController:(BOOL) isRootViewController
{
    NSNumber *number = [NSNumber numberWithBool: isRootViewController];
    objc_setAssociatedObject(self, ParallelIsRootViewControllerPropertyKey, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isRootViewController
{
    NSNumber *number = objc_getAssociatedObject(self, ParallelIsRootViewControllerPropertyKey);
    if (number) {
        return [number boolValue];
    }else{
        return NO;
    }
}
@end
