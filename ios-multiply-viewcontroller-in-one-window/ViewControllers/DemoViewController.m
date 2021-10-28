//
//  DemoViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/13.
//

#import "DemoViewController.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import "ParallelShoppingModeViewController.h"

@interface DemoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *content;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = @"this is a viewcontroller";
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;

    UIColor * color = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    self.view.backgroundColor = color;
    self.content.backgroundColor = color;
    
    NSLog(@"DemoViewController frame x:%f,y:%f,width:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    self.parallelNavigationItem.title = @"DemoViewController";
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (IBAction)onClickPush:(id)sender {
    DemoViewController * vc = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
    [self.parallelViewController pushViewController:vc animated:YES];
}

- (IBAction)onClickPop:(id)sender {
    [self.parallelViewController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -Override ViewController Methods

-(void)loadView{
    [super loadView];
}
- (void)willMoveToParentViewController:(nullable UIViewController *)parent{
    
}
- (void)didMoveToParentViewController:(nullable UIViewController *)parent{
    
};


@end
