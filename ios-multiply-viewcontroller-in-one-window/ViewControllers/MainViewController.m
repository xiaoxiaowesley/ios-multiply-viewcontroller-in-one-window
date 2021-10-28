//
//  Demo2ViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/14.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MainViewController frame x:%f,y:%f,width:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;

    UIColor * color = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    self.view.backgroundColor = color;
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
